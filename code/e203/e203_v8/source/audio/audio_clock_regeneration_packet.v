// Implementation of HDMI audio clock regeneration packet
// By Sameer Puri https://github.com/sameer

// See HDMI 1.4b Section 5.3.3
module audio_clock_regeneration_packet
#(
    parameter VIDEO_RATE = 25.2E6,
    parameter AUDIO_RATE = 48e3
)
(
    input  clk_pixel,
    input  clk_audio,
    output reg clk_audio_counter_wrap,
    output  [23:0] header,
    output  [55:0] sub [3:0]
);

initial clk_audio_counter_wrap =1'b0;

// See Section 7.2.3, values derived from "Other" row in Tables 7-1, 7-2, 7-3.
localparam N = 20'd6144;

localparam CLK_AUDIO_COUNTER_WIDTH = 6;
localparam CLK_AUDIO_COUNTER_END = 6'd47;
reg [CLK_AUDIO_COUNTER_WIDTH-1:0] clk_audio_counter ;
initial clk_audio_counter = 6'd0;
reg internal_clk_audio_counter_wrap ;
initial internal_clk_audio_counter_wrap = 1'd0;
always @(posedge clk_audio)
begin
    if (clk_audio_counter == CLK_AUDIO_COUNTER_END)
    begin
        clk_audio_counter <= 6'd0;
        internal_clk_audio_counter_wrap <= !internal_clk_audio_counter_wrap;
    end
    else
        clk_audio_counter <= clk_audio_counter + 1'd1;
end

reg [1:0] clk_audio_counter_wrap_synchronizer_chain ;
initial clk_audio_counter_wrap_synchronizer_chain = 2'd0;
always @(posedge clk_pixel)
    clk_audio_counter_wrap_synchronizer_chain <= {internal_clk_audio_counter_wrap, clk_audio_counter_wrap_synchronizer_chain[1]};

localparam CYCLE_TIME_STAMP_COUNTER_IDEAL = 20'd25000;
localparam CYCLE_TIME_STAMP_COUNTER_WIDTH = 15 ;

reg [19:0] cycle_time_stamp ;
initial cycle_time_stamp = 20'd0;
reg [CYCLE_TIME_STAMP_COUNTER_WIDTH-1:0] cycle_time_stamp_counter ;
initial cycle_time_stamp_counter = 15'd0;
always @(posedge clk_pixel)
begin
    if (clk_audio_counter_wrap_synchronizer_chain[1] ^ clk_audio_counter_wrap_synchronizer_chain[0])
    begin
        cycle_time_stamp_counter <= 15'd0;
        cycle_time_stamp <= {5'd0, cycle_time_stamp_counter + 15'd1};
        clk_audio_counter_wrap <= !clk_audio_counter_wrap;
    end
    else
        cycle_time_stamp_counter <= cycle_time_stamp_counter + 15'd1;
end

// "An HDMI Sink shall ignore bytes HB1 and HB2 of the Audio Clock Regeneration Packet header."
`ifdef MODEL_TECH
assign header = {8'd0, 8'd0, 8'd1};
`else
assign header = {8'dX, 8'dX, 8'd1};
`endif

// "The four Subpackets each contain the same Audio Clock regeneration Subpacket."
genvar i;
generate
    for (i = 0; i < 4; i=i+1)
    begin: same_packet
        assign sub[i] = {N[7:0], N[15:8], {4'd0, N[19:16]}, cycle_time_stamp[7:0], cycle_time_stamp[15:8], {4'd0, cycle_time_stamp[19:16]}, 8'd0};
    end
endgenerate

endmodule
