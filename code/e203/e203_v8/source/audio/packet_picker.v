// Implementation of HDMI packet choice logic.
// By Sameer Puri https://github.com/sameer

module packet_picker
#(
    parameter VIDEO_ID_CODE = 4,
    parameter VIDEO_RATE = 0,
    parameter IT_CONTENT = 1,
    parameter AUDIO_BIT_WIDTH = 16,
    parameter AUDIO_RATE = 0,
    parameter VENDOR_NAME = 64'd0,
    parameter PRODUCT_DESCRIPTION = 128'd0,
    parameter SOURCE_DEVICE_INFORMATION = 8'd0  
)
(
    input  clk_pixel,
    input  clk_audio,
    input  reset,
    input  video_field_end,
    input  packet_enable,
    input  [4:0] packet_pixel_counter,
    input  [AUDIO_BIT_WIDTH-1:0] audio_sample_word [1:0],
    output  [23:0] header,
    output  [55:0] sub [3:0]
);

// Connect the current packet type's data to the output.
reg [7:0] packet_type;

initial begin
    packet_type =8'd0;
end

wire [23:0] headers [255:0];
//logic [55:0] subs [255:0] [3:0];
wire [55:0] subs [1023:0];
wire [9:0]   packet_type_t2;
wire [9:0]   packet_type_t2_p1;
wire [9:0]   packet_type_t2_p2;
wire [9:0]   packet_type_t2_p3;
assign packet_type_t2 = {packet_type,2'd0};
assign packet_type_t2_p1 = {packet_type,2'd1};
assign packet_type_t2_p2 = {packet_type,2'd2};
assign packet_type_t2_p3 = {packet_type,2'd3};
assign header = headers[packet_type];
//assign sub[0] = subs[packet_type][0];
//assign sub[1] = subs[packet_type][1];
//assign sub[2] = subs[packet_type][2];
//assign sub[3] = subs[packet_type][3];
assign sub[0] = subs[packet_type_t2];
assign sub[1] = subs[packet_type_t2_p1];
assign sub[2] = subs[packet_type_t2_p2];
assign sub[3] = subs[packet_type_t2_p3];

// NULL packet
// "An HDMI Sink shall ignore bytes HB1 and HB2 of the Null Packet Header and all bytes of the Null Packet Body."
`ifdef MODEL_TECH
assign headers[0] = {8'd0, 8'd0, 8'd0};
assign subs[0] = 56'd0;
assign subs[1] = 56'd0;
assign subs[2] = 56'd0;
assign subs[3] = 56'd0;
`else
assign headers[0] = {8'dX, 8'dX, 8'd0};
assign subs[0] = 56'dX;
assign subs[1] = 56'dX;
assign subs[2] = 56'dX;
assign subs[3] = 56'dX;
`endif

// Audio Clock Regeneration Packet
wire clk_audio_counter_wrap;
audio_clock_regeneration_packet #(.VIDEO_RATE(VIDEO_RATE), .AUDIO_RATE(AUDIO_RATE)) audio_clock_regeneration_packet (.clk_pixel(clk_pixel), .clk_audio(clk_audio), .clk_audio_counter_wrap(clk_audio_counter_wrap), .header(headers[1]), .sub(subs[7:4]));

// Audio Sample packet
/*
localparam SAMPLING_FREQUENCY = AUDIO_RATE == 32000 ? 4'b0011
    : AUDIO_RATE == 44100 ? 4'b0000
    : AUDIO_RATE == 88200 ? 4'b1000
    : AUDIO_RATE == 176400 ? 4'b1100
    : AUDIO_RATE == 48000 ? 4'b0010
    : AUDIO_RATE == 96000 ? 4'b1010
    : AUDIO_RATE == 192000 ? 4'b1110
    : 4'bXXXX;
*/
localparam SAMPLING_FREQUENCY = 4'b0010;
//localparam int AUDIO_BIT_WIDTH_COMPARATOR = AUDIO_BIT_WIDTH < 20 ? 20 : AUDIO_BIT_WIDTH == 20 ? 25 : AUDIO_BIT_WIDTH < 24 ? 24 : AUDIO_BIT_WIDTH == 24 ? 29 : -1;
localparam AUDIO_BIT_WIDTH_COMPARATOR = 20;
//localparam bit [2:0] WORD_LENGTH = 3'(AUDIO_BIT_WIDTH_COMPARATOR - AUDIO_BIT_WIDTH);
localparam WORD_LENGTH = 3'd4;
//localparam bit WORD_LENGTH_LIMIT = AUDIO_BIT_WIDTH <= 20 ? 1'b0 : 1'b1;
localparam WORD_LENGTH_LIMIT = 1'b0;

reg [AUDIO_BIT_WIDTH-1:0] audio_sample_word_transfer [1:0];
reg audio_sample_word_transfer_control;

initial audio_sample_word_transfer_control = 1'd0;

always @(posedge clk_audio)
begin
    audio_sample_word_transfer <= audio_sample_word;
    audio_sample_word_transfer_control <= !audio_sample_word_transfer_control;
end

reg [1:0] audio_sample_word_transfer_control_synchronizer_chain;
initial audio_sample_word_transfer_control_synchronizer_chain = 2'd0;
always @(posedge clk_pixel)
    audio_sample_word_transfer_control_synchronizer_chain <= {audio_sample_word_transfer_control, audio_sample_word_transfer_control_synchronizer_chain[1]};

reg sample_buffer_current ;
initial sample_buffer_current =1'b0;

reg [1:0] samples_remaining;
initial samples_remaining =2'd0;
//logic [23:0] audio_sample_word_buffer [1:0] [3:0] [1:0];
reg [23:0] audio_sample_word_buffer [15:0];
wire [AUDIO_BIT_WIDTH-1:0] audio_sample_word_transfer_mux [1:0];
wire [3:0]     sample_buffer_current_8;
wire [2:0]     samples_remaining_2;
wire [15:0]    sample_buffer_current_8_samples_remaining_2;
wire [AUDIO_BIT_WIDTH-1:0] audio_sample_word_transfer_mux_temp[1:0];
assign      sample_buffer_current_8 = {sample_buffer_current,3'd0};
assign      samples_remaining_2 = {samples_remaining,1'b0};
assign      sample_buffer_current_8_samples_remaining_2 = {sample_buffer_current_8,samples_remaining_2};

assign  audio_sample_word_transfer_mux_temp = {audio_sample_word_buffer[sample_buffer_current_8_samples_remaining_2+1][23:(24-AUDIO_BIT_WIDTH)], audio_sample_word_buffer[sample_buffer_current_8_samples_remaining_2][23:(24-AUDIO_BIT_WIDTH)]};
assign audio_sample_word_transfer_mux = (audio_sample_word_transfer_control_synchronizer_chain[0] ^ audio_sample_word_transfer_control_synchronizer_chain[1])
                                        ?audio_sample_word_transfer : audio_sample_word_transfer_mux_temp;

/*
always@(*)
begin
    if (audio_sample_word_transfer_control_synchronizer_chain[0] ^ audio_sample_word_transfer_control_synchronizer_chain[1])
        audio_sample_word_transfer_mux = audio_sample_word_transfer;
    else
        audio_sample_word_transfer_mux = {audio_sample_word_buffer[sample_buffer_current_8_samples_remaining_2+1][23:(24-AUDIO_BIT_WIDTH)], audio_sample_word_buffer[sample_buffer_current_8_samples_remaining_2][23:(24-AUDIO_BIT_WIDTH)]};
end
*/


reg sample_buffer_used;
initial sample_buffer_used = 1'b0;
reg sample_buffer_ready;
initial sample_buffer_ready = 1'b0;

always @(posedge clk_pixel)
begin
    if (sample_buffer_used)
        sample_buffer_ready <= 1'b0;
    if (audio_sample_word_transfer_control_synchronizer_chain[0] ^ audio_sample_word_transfer_control_synchronizer_chain[1])
    begin
        audio_sample_word_buffer[sample_buffer_current_8_samples_remaining_2] <=  {audio_sample_word_transfer_mux[0],8'b0};
        audio_sample_word_buffer[sample_buffer_current_8_samples_remaining_2+1] <={audio_sample_word_transfer_mux[1],8'b0};
        if (samples_remaining == 2'd3)
        begin
            samples_remaining <= 2'd0;
            sample_buffer_ready <= 1'b1;
            sample_buffer_current <= !sample_buffer_current;
        end
        else
            samples_remaining <= samples_remaining + 1'd1;
    end
end

//logic [23:0] audio_sample_word_packet [3:0] [1:0];
reg [23:0] audio_sample_word_packet [7:0];
reg [3:0] audio_sample_word_present_packet;

reg [7:0] frame_counter;
initial frame_counter = 8'b0;
always @(posedge clk_pixel)
begin
    if (reset)
    begin
        frame_counter <= 8'd0;
    end
    else if (packet_pixel_counter == 5'd31 && packet_type == 8'h02) // Keep track of current IEC 60958 frame
    begin
        frame_counter <= frame_counter + 8'd4;
        if (frame_counter >= 8'd192)
            frame_counter <= frame_counter - 8'd192;
    end
end
audio_sample_packet #(.SAMPLING_FREQUENCY(SAMPLING_FREQUENCY), .WORD_LENGTH({{WORD_LENGTH[0], WORD_LENGTH[1], WORD_LENGTH[2]}, WORD_LENGTH_LIMIT})) audio_sample_packet (.frame_counter(frame_counter), .valid_bit({2'b00, 2'b00, 2'b00, 2'b00}), .user_data_bit({2'b00, 2'b00, 2'b00, 2'b00}), .audio_sample_word(audio_sample_word_packet), .audio_sample_word_present(audio_sample_word_present_packet), .header(headers[2]), .sub(subs[11:8]));

auxiliary_video_information_info_frame #(
    .VIDEO_ID_CODE(7'd1),
    .IT_CONTENT(IT_CONTENT)
) auxiliary_video_information_info_frame(.header(headers[130]), .sub(subs[523:520]));


source_product_description_info_frame #(.VENDOR_NAME(VENDOR_NAME), .PRODUCT_DESCRIPTION(PRODUCT_DESCRIPTION), .SOURCE_DEVICE_INFORMATION(SOURCE_DEVICE_INFORMATION)) source_product_description_info_frame(.header(headers[131]), .sub(subs[527:524]));


audio_info_frame audio_info_frame(.header(headers[132]), .sub(subs[531:528]));


// "A Source shall always transmit... [an InfoFrame] at least once per two Video Fields"
reg audio_info_frame_sent ;
initial audio_info_frame_sent = 1'b0;
reg auxiliary_video_information_info_frame_sent ;
initial auxiliary_video_information_info_frame_sent = 1'b0;
reg source_product_description_info_frame_sent;
initial source_product_description_info_frame_sent = 1'b0;
reg last_clk_audio_counter_wrap;
initial last_clk_audio_counter_wrap = 1'b0;
always @(posedge clk_pixel)
begin
    if (sample_buffer_used)
        sample_buffer_used <= 1'b0;

    if (reset || video_field_end)
    begin
        audio_info_frame_sent <= 1'b0;
        auxiliary_video_information_info_frame_sent <= 1'b0;
        source_product_description_info_frame_sent <= 1'b0;
        packet_type <= 8'dx;
    end
    else if (packet_enable)
    begin
        if (last_clk_audio_counter_wrap ^ clk_audio_counter_wrap)
        begin
            packet_type <= 8'd1;
            last_clk_audio_counter_wrap <= clk_audio_counter_wrap;
        end
        else if (sample_buffer_ready)
        begin
            packet_type <= 8'd2;
            //audio_sample_word_packet <= audio_sample_word_buffer[!sample_buffer_current];
            if(sample_buffer_current)
                audio_sample_word_packet<={audio_sample_word_buffer[7],audio_sample_word_buffer[6],audio_sample_word_buffer[5],audio_sample_word_buffer[4],audio_sample_word_buffer[3],audio_sample_word_buffer[2],audio_sample_word_buffer[1],audio_sample_word_buffer[0]};
            else
                audio_sample_word_packet<={audio_sample_word_buffer[15],audio_sample_word_buffer[14],audio_sample_word_buffer[13],audio_sample_word_buffer[12],audio_sample_word_buffer[11],audio_sample_word_buffer[10],audio_sample_word_buffer[9],audio_sample_word_buffer[8]};
            //audio_sample_word_packet <= sample_buffer_current?{audio_sample_word_buffer[7],audio_sample_word_buffer[6],audio_sample_word_buffer[5],audio_sample_word_buffer[4],audio_sample_word_buffer[3],audio_sample_word_buffer[2],audio_sample_word_buffer[1],audio_sample_word_buffer[0]}
                                                            //:{audio_sample_word_buffer[15],audio_sample_word_buffer[14],audio_sample_word_buffer[13],audio_sample_word_buffer[12],audio_sample_word_buffer[11],audio_sample_word_buffer[10],audio_sample_word_buffer[9],audio_sample_word_buffer[8]};
            audio_sample_word_present_packet <= 4'b1111;
            sample_buffer_used <= 1'b1;
        end
        else if (!audio_info_frame_sent)
        begin
            packet_type <= 8'h84;
            audio_info_frame_sent <= 1'b1;
        end
        else if (!auxiliary_video_information_info_frame_sent)
        begin
            packet_type <= 8'h82;
            auxiliary_video_information_info_frame_sent <= 1'b1;
        end
        else if (!source_product_description_info_frame_sent)
        begin
            packet_type <= 8'h83;
            source_product_description_info_frame_sent <= 1'b1;
        end
        else
            packet_type <= 8'd0;
    end
end

endmodule
