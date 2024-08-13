

module sd_card_user_top(

    input            clk,
	input            rst_n,
    input            audio_clk,   


    output           sd_ncs,      //chip select
    output           sd_dclk,     //sd card clock
    output           sd_mosi,     //sd card CMD
    input            sd_miso,     //sd card  data

    input           sd_icb_cmd_valid,
    input [31:0]    sd_icb_cmd_addr ,
    input           sd_icb_cmd_read,
    input [31:0]    sd_icb_cmd_wdata,

    output[7:0]      sd_fifo_read_data

);

localparam      sd_cig_base_addr=32'h80400000;


reg  [31:0]     config_r;
reg  [31:0]     sd_sec_read_addr_start;
reg  [31:0]     sd_sec_read_addr_end;
wire            sd_sec_read_addr_start_wr;
wire            sd_sec_read_addr_end_wr;
wire            sd_cofig_r_wr;



wire    sd_init_done;
wire    sd_sec_read;
reg     [31:0]      sd_sec_read_addr;
wire    [7:0]       sd_sec_read_data;
wire    sd_sec_read_data_valid;
wire    sd_sec_read_end;
wire    [7:0]       fifo_read_data;


wire    almost_full;
wire    almost_empty;

wire    rd_fifo_en;
wire    wr_fifo_en;

assign  rd_fifo_en = sd_init_done && (~almost_empty) && config_r[0];
assign  wr_fifo_en = sd_init_done && sd_sec_read_data_valid && config_r[0];

assign  sd_sec_read = sd_init_done && (~almost_full);

assign  sd_fifo_read_data = config_r[0]?fifo_read_data:8'b0;

assign  sd_sec_read_addr_start_wr = sd_icb_cmd_valid && (~sd_icb_cmd_read) && (sd_icb_cmd_addr==sd_cig_base_addr+32'd4);
assign  sd_sec_read_addr_end_wr = sd_icb_cmd_valid && (~sd_icb_cmd_read) && (sd_icb_cmd_addr==sd_cig_base_addr+32'd8);
assign  sd_cofig_r_wr = sd_icb_cmd_valid && (~sd_icb_cmd_read) && (sd_icb_cmd_addr==sd_cig_base_addr);

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        sd_sec_read_addr <=32'd21312;
    else if(sd_sec_read_addr_start_wr)
        sd_sec_read_addr<=sd_icb_cmd_wdata;
    else if(sd_sec_read_addr_end_wr)
        sd_sec_read_addr<=sd_sec_read_addr_start;
    else if(sd_sec_read_end) begin
        if(sd_sec_read_addr<sd_sec_read_addr_end)
            sd_sec_read_addr<=sd_sec_read_addr+1'b1;
        else
            sd_sec_read_addr<=sd_sec_read_addr_start;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        sd_sec_read_addr_start <=32'd21312;
    else if(sd_sec_read_addr_start_wr) begin
        sd_sec_read_addr_start<=sd_icb_cmd_wdata;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        sd_sec_read_addr_end <=32'd28714;
    else if(sd_sec_read_addr_end_wr) begin
        sd_sec_read_addr_end<=sd_icb_cmd_wdata;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        config_r <=32'd0;
    else if(sd_cofig_r_wr) begin
        config_r<=sd_icb_cmd_wdata;
    end
end



sd_card_top  sd_card_top_m0(
.clk                       (clk                ),
.rst                       (~rst_n             ),
.SD_nCS                    (sd_ncs                 ),
.SD_DCLK                   (sd_dclk                ),
.SD_MOSI                   (sd_mosi                ),
.SD_MISO                   (sd_miso                ),
.sd_init_done              (sd_init_done           ),
.sd_sec_read               (sd_sec_read            ),
.sd_sec_read_addr          (sd_sec_read_addr       ),
.sd_sec_read_data          (sd_sec_read_data       ),
.sd_sec_read_data_valid    (sd_sec_read_data_valid ),
.sd_sec_read_end           (sd_sec_read_end        ),
.sd_sec_write              (1'b0           ),
.sd_sec_write_addr         (32'b0           ),
.sd_sec_write_data         (8'b0            ),
.sd_sec_write_data_req     (  ),
.sd_sec_write_end          (  )
);



sd_card_fifo u_sd_card_fifo (
  .wr_clk(clk),                // input
  .wr_rst(~rst_n),                // input
  .wr_en(wr_fifo_en),                  // input
  .wr_data(sd_sec_read_data),              // input [7:0]
  .wr_full(),              // output
  .almost_full(almost_full),      // output
  .rd_clk(audio_clk),                // input
  .rd_rst(~rst_n),                // input
  .rd_en(rd_fifo_en),                  // input
  .rd_data(fifo_read_data),              // output [7:0]
  .rd_empty(),            // output
  .almost_empty(almost_empty)     // output
);






endmodule
