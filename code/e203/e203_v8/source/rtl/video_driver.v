

module video_driver(
    input           pixel_clk,
    input           pixel_clk_5x,
    input           clk_audio,
    input [16-1:0] audio_sample_word [1:0],
    input           sys_rst_n,
    
    //RGB
    output          video_hs,
    output          video_vs,
    output          video_de, 
    output  [23:0]  video_rgb,

    output       tmds_clk_p,   
    output       tmds_clk_n,
    output [2:0] tmds_data_p,   
    output [2:0] tmds_data_n, 
    
    output          lcd_driver_en,
    input           almost_empty,
    output          data_req,
    input   [23:0]  pixel_data
);

//parameter define


//640*480@(60Hz)
parameter  H_SYNC   =  11'd96;
parameter  H_BACK   =  11'd48;
parameter  H_DISP   =  11'd640;
parameter  H_FRONT  =  11'd16;
parameter  H_TOTAL  =  11'd800;


parameter  V_SYNC   =  11'd2;
parameter  V_BACK   =  11'd33;
parameter  V_DISP   =  11'd480;
parameter  V_FRONT  =  11'd10;
parameter  V_TOTAL  =  11'd525;


parameter  frame_width  =  H_TOTAL;
parameter  frame_height  =  V_TOTAL;
parameter  screen_width  =  H_DISP;
parameter  screen_height  =  V_DISP;
parameter  hsync_pulse_start  =  H_FRONT;
parameter  hsync_pulse_size  =  H_SYNC;
parameter  vsync_pulse_start  =  V_FRONT;
parameter  vsync_pulse_size  =  V_SYNC;

localparam NUM_CHANNELS = 3;


reg    video_data_period;
reg  [10:0] cx;
reg  [10:0] cy;
wire    vsync;
wire    hsync;

wire    reset;
wire    clk_pixel;
assign  clk_pixel = pixel_clk;
assign  reset = !sys_rst_n;

assign  video_vs=vsync;
assign  video_hs=hsync;
assign  video_de=video_data_period;


wire         lcd_driver_en;
wire  [10:0] cx_temp;
wire  [10:0] cy_temp;


assign hsync = ~(cx >= screen_width + hsync_pulse_start && cx < screen_width + hsync_pulse_start + hsync_pulse_size);
assign vsync = (cy == screen_height + vsync_pulse_start - 1)?(~(cx >= screen_width + hsync_pulse_start))
            :  (cy == screen_height + vsync_pulse_start + vsync_pulse_size - 1)?(~(cx < screen_width + hsync_pulse_start))
            :  (~(cy >= screen_height + vsync_pulse_start && cy < screen_height + vsync_pulse_start + vsync_pulse_size))
            ;
assign  video_rgb =  video_de ? pixel_data : 24'd0;
assign data_req = (cx<screen_width) && (cy<screen_height); 
assign lcd_driver_en = (cy!=V_TOTAL-V_SYNC-V_BACK) && (cy!=V_TOTAL-V_SYNC-V_BACK+1'b1);
assign cx_temp = cx == frame_width-1'b1 ? 11'd0 : cx + 1'b1;
assign cy_temp = cx == frame_width-1'b1 ? cy == frame_height-1'b1 ? 11'd0 : cy + 1'b1 : cy;


always @(posedge clk_pixel)
begin
    if (reset)
        video_data_period <= 0;
    else
        video_data_period <= cx < screen_width && cy < screen_height;
end

always @(posedge pixel_clk )
begin
    if (!sys_rst_n) begin
        cx<= 11'd0;
        //cy<= frame_height-1'b1;
        cy<=V_TOTAL-V_SYNC-V_BACK;
    end
    else begin
        cx <= cx_temp;
        cy <= cy_temp;
    end
end


// See Specification Section 5.2

reg [2:0] mode = 3'd1;
reg [23:0] video_data = 24'd0;
reg [5:0] control_data = 6'd0;
reg [11:0] data_island_data = 12'd0;

// All logic below relates to the production and output of the 10-bit TMDS code.
wire [9:0] tmds_internal [NUM_CHANNELS-1:0] /* verilator public_flat */ ;
genvar i;
generate
    // TMDS code production.
    for (i = 0; i < NUM_CHANNELS; i=i+1)
    begin: tmds_gen
        tmds_channel #(.CN(i)) tmds_channel (.clk_pixel(pixel_clk), .video_data(video_data[i*8+7:i*8]), .data_island_data(data_island_data[i*4+3:i*4]), .control_data(control_data[i*2+1:i*2]), .mode(mode), .tmds(tmds_internal[i]));
    end
endgenerate


serializer_10_to_1 serializer_r(
    .serial_clk_5x      (pixel_clk_5x), 
    .paralell_data      (tmds_internal[2]), 
    .serial_data_p      (tmds_data_p[2]),
    .serial_data_n      (tmds_data_n[2])
    );  

serializer_10_to_1 serializer_g(
    .serial_clk_5x      (pixel_clk_5x), 
    .paralell_data      (tmds_internal[1]), 
    .serial_data_p      (tmds_data_p[1]),
    .serial_data_n      (tmds_data_n[1])
    );  


serializer_10_to_1 serializer_b(
    .serial_clk_5x      (pixel_clk_5x), 
    .paralell_data      (tmds_internal[0]), 
    .serial_data_p      (tmds_data_p[0]),
    .serial_data_n      (tmds_data_n[0])
    );  



wire [9:0] clk_10bit = 10'b0000011111;

serializer_10_to_1 serializer_clk(
    .serial_clk_5x      (pixel_clk_5x),
    .paralell_data      (clk_10bit),
    .serial_data_p      (tmds_clk_p), 
    .serial_data_n      (tmds_clk_n) 
    );

reg video_guard ;
reg video_preamble ;
always @(posedge pixel_clk)
begin
    if (!sys_rst_n) begin
        video_guard <= 1;
        video_preamble <= 0;
    end
    else begin
        video_guard <= cx >= frame_width - 2 && cx < frame_width && (cy == frame_height - 1 || cy < screen_height - 1 /* no VG at end of last line */);
        video_preamble <= cx >= frame_width - 10 && cx < frame_width - 2 && (cy == frame_height - 1 || cy < screen_height - 1 /* no VP at end of last line */);
    end
end

// See Section 5.2.3.1
parameter num_packets_alongside = 5'd4;        //just for 640*480


//
wire [10:0] cx_screen_width_18 = cx + screen_width + 18;
wire data_island_period_instantaneous = num_packets_alongside > 0 && cx >= screen_width + 14 && cx < screen_width + 14 + 128;
wire packet_enable = data_island_period_instantaneous && cx_screen_width_18[4:0] == 5'd0;

reg data_island_guard ;
reg data_island_preamble ;
reg data_island_period ;
always @(posedge pixel_clk)
begin
    if (!sys_rst_n) begin
        data_island_guard <= 0;
        data_island_preamble <= 0;
        data_island_period <= 0;
    end
    else begin
        data_island_guard <= num_packets_alongside > 0 && (
            (cx >= screen_width + 12 && cx < screen_width + 14) /* leading guard */ || 
            (cx >= screen_width + 14 + 128 && cx < screen_width + 14 + 128 + 2) /* trailing guard */
        );
        data_island_preamble <= num_packets_alongside > 0 && cx >= screen_width + 4 && cx < screen_width + 12;
        data_island_period <= data_island_period_instantaneous;
    end
end

// See Section 5.2.3.4

parameter VENDOR_NAME = {"Unknown", 8'd0}; // Must be 8 bytes null-padded 7-bit ASCII
parameter PRODUCT_DESCRIPTION = {"FPGA", 96'd0}; // Must be 16 bytes null-padded 7-bit ASCII
parameter SOURCE_DEVICE_INFORMATION = 8'h00; // See README.md or CTA-861-G for the list of valid codes

wire [23:0] header;
wire [55:0] sub [3:0];
wire video_field_end;
assign video_field_end = cx == screen_width - 1'b1 && cy == screen_height - 1'b1;
wire [4:0] packet_pixel_counter;
packet_picker #(
    .VIDEO_ID_CODE(1),
    .VIDEO_RATE(25000000),
    .IT_CONTENT(1),
    .AUDIO_RATE(48000),
    .AUDIO_BIT_WIDTH(16),
    .VENDOR_NAME(VENDOR_NAME),
    .PRODUCT_DESCRIPTION(PRODUCT_DESCRIPTION),
    .SOURCE_DEVICE_INFORMATION(SOURCE_DEVICE_INFORMATION)
) packet_picker (.clk_pixel(clk_pixel), .clk_audio(clk_audio), .reset(reset), .video_field_end(video_field_end), .packet_enable(packet_enable), .packet_pixel_counter(packet_pixel_counter), .audio_sample_word(audio_sample_word), .header(header), .sub(sub));


wire [8:0] packet_data;
packet_assembler packet_assembler (.clk_pixel(clk_pixel), .reset(reset), .data_island_period(data_island_period), .header(header), .sub(sub), .packet_data(packet_data), .counter(packet_pixel_counter));


always @(posedge clk_pixel)
begin
    if (reset)
    begin
        mode <= 3'd2;
        video_data <= 24'd0;
        control_data <= 6'd0;
        data_island_data <= 12'd0;
    end
    else
    begin
        mode <= data_island_guard ? 3'd4 : data_island_period ? 3'd3 : video_guard ? 3'd2 : video_data_period ? 3'd1 : 3'd0;
        //mode <= video_data_period ? 3'd1 : 3'd0;
        //mode <= video_de ? 3'd1 : data_island_guard ? 3'd4 : data_island_period ? 3'd3 : video_guard ? 3'd2 : 3'd0;
        video_data <= video_rgb;
        control_data <= {{1'b0, data_island_preamble}, {1'b0, video_preamble || data_island_preamble}, {vsync, hsync}}; // ctrl3, ctrl2, ctrl1, ctrl0, vsync, hsync
        data_island_data[11:4] <= packet_data[8:1];
        data_island_data[3] <= cx != 0;
        data_island_data[2] <= packet_data[0];
        data_island_data[1:0] <= {vsync, hsync};
    end
end



endmodule