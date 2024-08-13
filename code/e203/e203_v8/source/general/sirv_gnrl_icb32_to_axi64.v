//`timescale  1ns/1ns  

module sirv_gnrl_icb32_to_axi64 # (
  parameter AXI_FIFO_DP = 0,
  parameter AXI_FIFO_CUT_READY = 1,
  parameter AW = 32,
  parameter FIFO_OUTS_NUM = 8,
  parameter FIFO_CUT_READY = 0,
  parameter DW = 64 // 64 or 32 bits
) (
  input              i_icb_cmd_valid, 
  output             i_icb_cmd_ready, 
  input  [1-1:0]     i_icb_cmd_read, 
  input  [AW-1:0]    i_icb_cmd_addr, 
  input  [32-1:0]    i_icb_cmd_wdata, 
  input  [32/8-1:0]  i_icb_cmd_wmask,
  input  [1:0]       i_icb_cmd_size,

  output             i_icb_rsp_valid, 
  input              i_icb_rsp_ready, 
  output             i_icb_rsp_err,
  output [32-1:0]    i_icb_rsp_rdata, 
  
  output o_axi_arvalid,
  input  o_axi_arready,
  output [AW-1:0] o_axi_araddr,
  output [3:0] o_axi_arcache,
  output [2:0] o_axi_arprot,
  output [1:0] o_axi_arlock,
  output [1:0] o_axi_arburst,
  output [7:0] o_axi_arlen,
  output [2:0] o_axi_arsize,

  output o_axi_awvalid,
  input  o_axi_awready,
  output [AW-1:0] o_axi_awaddr,
  output [3:0] o_axi_awcache,
  output [2:0] o_axi_awprot,
  output [1:0] o_axi_awlock,
  output [1:0] o_axi_awburst,
  output [7:0] o_axi_awlen,
  output [2:0] o_axi_awsize,

  input  o_axi_rvalid,
  output o_axi_rready,
  input  [64-1:0] o_axi_rdata,
  input  [1:0] o_axi_rresp,
  input  o_axi_rlast,

  output o_axi_wvalid,
  input  o_axi_wready,
  output [64-1:0] o_axi_wdata,
  output [(64/8)-1:0] o_axi_wstrb,
  output o_axi_wlast,

  input  o_axi_bvalid,
  output o_axi_bready,
  input  [1:0] o_axi_bresp,

  input  clk,  
  input  rst_n
  );



  /*
  wire i_axi_arvalid;
  wire i_axi_arready;
  wire [AW-1:0] i_axi_araddr;
  wire [3:0] i_axi_arcache;
  wire [2:0] i_axi_arprot;
  wire [1:0] i_axi_arlock;
  wire [1:0] i_axi_arburst;
  wire [7:0] i_axi_arlen;
  wire [2:0] i_axi_arsize;

  wire i_axi_awvalid;
  wire i_axi_awready;
  wire [AW-1:0] i_axi_awaddr;
  wire [3:0] i_axi_awcache;
  wire [2:0] i_axi_awprot;
  wire [1:0] i_axi_awlock;
  wire [1:0] i_axi_awburst;
  wire [7:0] i_axi_awlen;
  wire [2:0] i_axi_awsize;

  wire i_axi_rvalid;
  wire i_axi_rready;
  wire [64-1:0] i_axi_rdata;
  wire [1:0] i_axi_rresp;
  wire i_axi_rlast;

  wire i_axi_wvalid;
  wire i_axi_wready;
  wire [64-1:0] i_axi_wdata;
  wire [(64/8)-1:0] i_axi_wstrb;
  wire i_axi_wlast;

  wire i_axi_bvalid;
  wire i_axi_bready;
  wire [1:0] i_axi_bresp;
  */

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  // Convert the ICB to AXI Read/Write address and Wdata channel
  //
  //   Generate the AXI address channel valid which is direct got 
  //     from ICB command channel
  assign o_axi_arvalid = i_icb_cmd_valid & i_icb_cmd_read;
  
  // If it is the read transaction, need to pass to AR channel only
  // If it is the write transaction, need to pass to AW and W channel both
      // But in all case, need to check FIFO is not ful
  wire rw_fifo_full;
  assign i_icb_cmd_ready = (~rw_fifo_full) & 
             (i_icb_cmd_read ? o_axi_arready : (o_axi_awready & o_axi_wready));
  assign o_axi_awvalid = i_icb_cmd_valid & (~i_icb_cmd_read) & o_axi_wready  & (~rw_fifo_full);
  assign o_axi_wvalid  = i_icb_cmd_valid & (~i_icb_cmd_read) & o_axi_awready & (~rw_fifo_full); 
  //
  
  //   Generate the AXI address channel address which is direct got 
  //     from ICB command channel
  assign o_axi_araddr = i_icb_cmd_addr;
  assign o_axi_awaddr = i_icb_cmd_addr;
  
  //
  // For these attribute signals we just make it tied to zero
  assign o_axi_arcache = 4'b0;
  assign o_axi_awcache = 4'b0;
  assign o_axi_arprot =  3'b0;
  assign o_axi_awprot =  3'b0;
  assign o_axi_arlock = 2'b0;
  assign o_axi_awlock = 2'b0;
  //
  // The ICB does not support burst now, so just make it fixed
  assign o_axi_arburst = 2'b0;
  assign o_axi_awburst = 2'b0;
  assign o_axi_arlen = 8'b0;
  assign o_axi_awlen = 8'b0;
  
  
  assign o_axi_arsize = 3'b11;
  assign o_axi_awsize = 3'b11;
  
  // Generate the Write data channel
  wire   cmd_y_lo_hi = i_icb_cmd_addr[2];
  assign o_axi_wdata = {i_icb_cmd_wdata,i_icb_cmd_wdata};
  //assign i_axi_wstrb = i_icb_cmd_wmask;
  assign o_axi_wstrb = cmd_y_lo_hi ?  {i_icb_cmd_wmask,{4{1'b0}}}:{{4{1'b0}},i_icb_cmd_wmask};
  assign o_axi_wlast = 1'b1;

  wire rw_fifo_wen = i_icb_cmd_valid & i_icb_cmd_ready;
  wire rw_fifo_ren = i_icb_rsp_valid & i_icb_rsp_ready;

  wire rw_fifo_i_ready;
  wire rw_fifo_i_valid = rw_fifo_wen;
  wire rw_fifo_o_valid ;
  wire rw_fifo_o_ready = rw_fifo_ren;

  assign rw_fifo_full    = (~rw_fifo_i_ready);
  wire rw_fifo_empty   = (~rw_fifo_o_valid);

  wire i_icb_rsp_read;
  wire rsp_y_lo_hi;

  wire [1:0] rw_fifo_channel_i;
  wire [1:0] rw_fifo_channel_o;
  

  assign rw_fifo_channel_i ={i_icb_cmd_read,cmd_y_lo_hi};
  assign {i_icb_rsp_read,rsp_y_lo_hi}=rw_fifo_channel_o;

  sirv_gnrl_fifo # (
    .CUT_READY (FIFO_CUT_READY),
    .MSKO      (1),
    .DP  (FIFO_OUTS_NUM),
    .DW  (2)
  ) u_sirv_gnrl_rw_fifo (
    .i_vld(rw_fifo_i_valid),
    .i_rdy(rw_fifo_i_ready),
    .i_dat(rw_fifo_channel_i ),
    .o_vld(rw_fifo_o_valid),
    .o_rdy(rw_fifo_o_ready),  
    .o_dat(rw_fifo_channel_o ),  
  
    .clk  (clk),
    .rst_n(rst_n)
  );


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
// Generate the response channel
  assign i_icb_rsp_valid = i_icb_rsp_read ? o_axi_rvalid : o_axi_bvalid;
  assign o_axi_rready = i_icb_rsp_read & i_icb_rsp_ready;
  assign o_axi_bready = (~i_icb_rsp_read) & i_icb_rsp_ready;

  assign i_icb_rsp_err = i_icb_rsp_read ? o_axi_rresp[1] //SLVERR or DECERR 
                                        : o_axi_bresp[1];
  assign i_icb_rsp_rdata = i_icb_rsp_read ? (rsp_y_lo_hi?o_axi_rdata[63:32]:o_axi_rdata[31:0]) : {32{1'b0}}; 


  /*
  sirv_axi_buffer #(
     .CHNL_FIFO_DP         (AXI_FIFO_DP       ), 
     .CHNL_FIFO_CUT_READY  (AXI_FIFO_CUT_READY),
     .AW                   (AW),
     .DW                   (64) 
    ) u_sirv_axi_buffer (
    .i_axi_arvalid   (i_axi_arvalid),
    .i_axi_arready   (i_axi_arready),
    .i_axi_araddr    (i_axi_araddr ),
    .i_axi_arcache   (i_axi_arcache),
    .i_axi_arprot    (i_axi_arprot ),
    .i_axi_arlock    (i_axi_arlock ),
    .i_axi_arburst   (i_axi_arburst),
    .i_axi_arlen     (i_axi_arlen  ),
    .i_axi_arsize    (i_axi_arsize ),
                                   
    .i_axi_awvalid   (i_axi_awvalid),
    .i_axi_awready   (i_axi_awready),
    .i_axi_awaddr    (i_axi_awaddr ),
    .i_axi_awcache   (i_axi_awcache),
    .i_axi_awprot    (i_axi_awprot ),
    .i_axi_awlock    (i_axi_awlock ),
    .i_axi_awburst   (i_axi_awburst),
    .i_axi_awlen     (i_axi_awlen  ),
    .i_axi_awsize    (i_axi_awsize ),
                                   
    .i_axi_rvalid    (i_axi_rvalid ),
    .i_axi_rready    (i_axi_rready ),
    .i_axi_rdata     (i_axi_rdata  ),
    .i_axi_rresp     (i_axi_rresp  ),
    .i_axi_rlast     (i_axi_rlast  ),
                                   
    .i_axi_wvalid    (i_axi_wvalid ),
    .i_axi_wready    (i_axi_wready ),
    .i_axi_wdata     (i_axi_wdata  ),
    .i_axi_wstrb     (i_axi_wstrb  ),
    .i_axi_wlast     (i_axi_wlast  ),
                                   
    .i_axi_bvalid    (i_axi_bvalid ),
    .i_axi_bready    (i_axi_bready ),
    .i_axi_bresp     (i_axi_bresp  ),
                                   
    .o_axi_arvalid   (o_axi_arvalid),
    .o_axi_arready   (o_axi_arready),
    .o_axi_araddr    (o_axi_araddr ),
    .o_axi_arcache   (o_axi_arcache),
    .o_axi_arprot    (o_axi_arprot ),
    .o_axi_arlock    (o_axi_arlock ),
    .o_axi_arburst   (o_axi_arburst),
    .o_axi_arlen     (o_axi_arlen  ),
    .o_axi_arsize    (o_axi_arsize ),
                      
    .o_axi_awvalid   (o_axi_awvalid),
    .o_axi_awready   (o_axi_awready),
    .o_axi_awaddr    (o_axi_awaddr ),
    .o_axi_awcache   (o_axi_awcache),
    .o_axi_awprot    (o_axi_awprot ),
    .o_axi_awlock    (o_axi_awlock ),
    .o_axi_awburst   (o_axi_awburst),
    .o_axi_awlen     (o_axi_awlen  ),
    .o_axi_awsize    (o_axi_awsize ),
                     
    .o_axi_rvalid    (o_axi_rvalid ),
    .o_axi_rready    (o_axi_rready ),
    .o_axi_rdata     (o_axi_rdata  ),
    .o_axi_rresp     (o_axi_rresp  ),
    .o_axi_rlast     (o_axi_rlast  ),
                    
    .o_axi_wvalid    (o_axi_wvalid ),
    .o_axi_wready    (o_axi_wready ),
    .o_axi_wdata     (o_axi_wdata  ),
    .o_axi_wstrb     (o_axi_wstrb  ),
    .o_axi_wlast     (o_axi_wlast  ),
                   
    .o_axi_bvalid    (o_axi_bvalid ),
    .o_axi_bready    (o_axi_bready ),
    .o_axi_bresp     (o_axi_bresp  ),
       
    .clk  (clk),
    .rst_n(rst_n)
  );
  */

endmodule



module sirv_axi_buffer
  #(
    parameter CHNL_FIFO_DP = 2,
    parameter CHNL_FIFO_CUT_READY = 2,
    parameter AW = 32,
    parameter DW = 32 
    )
  (
  input  i_axi_arvalid,
  output i_axi_arready,
  input  [AW-1:0] i_axi_araddr,
  input  [3:0] i_axi_arcache,
  input  [2:0] i_axi_arprot,
  input  [1:0] i_axi_arlock,
  input  [1:0] i_axi_arburst,
  input  [7:0] i_axi_arlen,
  input  [2:0] i_axi_arsize,

  input  i_axi_awvalid,
  output i_axi_awready,
  input  [AW-1:0] i_axi_awaddr,
  input  [3:0] i_axi_awcache,
  input  [2:0] i_axi_awprot,
  input  [1:0] i_axi_awlock,
  input  [1:0] i_axi_awburst,
  input  [7:0] i_axi_awlen,
  input  [2:0] i_axi_awsize,

  output i_axi_rvalid,
  input  i_axi_rready,
  output [64-1:0] i_axi_rdata,
  output [1:0] i_axi_rresp,
  output i_axi_rlast,

  input  i_axi_wvalid,
  output i_axi_wready,
  input  [64-1:0] i_axi_wdata,
  input  [(64/8)-1:0] i_axi_wstrb,
  input  i_axi_wlast,

  output i_axi_bvalid,
  input  i_axi_bready,
  output [1:0] i_axi_bresp,

  output o_axi_arvalid,
  input  o_axi_arready,
  output [AW-1:0] o_axi_araddr,
  output [3:0] o_axi_arcache,
  output [2:0] o_axi_arprot,
  output [1:0] o_axi_arlock,
  output [1:0] o_axi_arburst,
  output [7:0] o_axi_arlen,
  output [2:0] o_axi_arsize,

  output o_axi_awvalid,
  input  o_axi_awready,
  output [AW-1:0] o_axi_awaddr,
  output [3:0] o_axi_awcache,
  output [2:0] o_axi_awprot,
  output [1:0] o_axi_awlock,
  output [1:0] o_axi_awburst,
  output [7:0] o_axi_awlen,
  output [2:0] o_axi_awsize,

  input  o_axi_rvalid,
  output o_axi_rready,
  input  [64-1:0] o_axi_rdata,
  input  [1:0] o_axi_rresp,
  input  o_axi_rlast,

  output o_axi_wvalid,
  input  o_axi_wready,
  output [64-1:0] o_axi_wdata,
  output [(64/8)-1:0] o_axi_wstrb,
  output o_axi_wlast,

  input  o_axi_bvalid,
  output o_axi_bready,
  input  [1:0] o_axi_bresp,
       
  input  clk,  
  input  rst_n 
  );


localparam AR_CHNL_W = 8+3+2+4+3+2+AW;
localparam AW_CHNL_W = AR_CHNL_W;

wire [AR_CHNL_W -1:0] i_axi_ar_chnl = 
    {
    i_axi_araddr,
    i_axi_arcache,
    i_axi_arprot ,
    i_axi_arlock ,
    i_axi_arburst,
    i_axi_arlen  ,
    i_axi_arsize  
    };

wire [AR_CHNL_W -1:0] o_axi_ar_chnl;
assign   {
    o_axi_araddr,
    o_axi_arcache,
    o_axi_arprot ,
    o_axi_arlock ,
    o_axi_arburst,
    o_axi_arlen  ,
    o_axi_arsize   
    } = o_axi_ar_chnl;

sirv_gnrl_fifo #(
    .CUT_READY (CHNL_FIFO_CUT_READY),
    .MSKO      (0),
    .DP  (CHNL_FIFO_DP),
    .DW  (AR_CHNL_W)
) o_axi_ar_fifo (
  .i_rdy    (i_axi_arready),
  .i_vld    (i_axi_arvalid),
  .i_dat    (i_axi_ar_chnl),

  .o_rdy    (o_axi_arready),
  .o_vld    (o_axi_arvalid),
  .o_dat    (o_axi_ar_chnl),

  .clk      (clk  ),
  .rst_n    (rst_n)
  );


wire [AW_CHNL_W-1:0] i_axi_aw_chnl = 
    {
    i_axi_awaddr,
    i_axi_awcache,
    i_axi_awprot ,
    i_axi_awlock ,
    i_axi_awburst,
    i_axi_awlen  ,
    i_axi_awsize  
    };

wire [AW_CHNL_W-1:0] o_axi_aw_chnl;
assign   {
    o_axi_awaddr,
    o_axi_awcache,
    o_axi_awprot ,
    o_axi_awlock ,
    o_axi_awburst,
    o_axi_awlen  ,
    o_axi_awsize  
    } = o_axi_aw_chnl;

sirv_gnrl_fifo #(
    .CUT_READY (CHNL_FIFO_CUT_READY),
    .MSKO      (0),
    .DP  (CHNL_FIFO_DP),
    .DW  (AW_CHNL_W)
) o_axi_aw_fifo (
  .i_rdy    (i_axi_awready),
  .i_vld    (i_axi_awvalid),
  .i_dat    (i_axi_aw_chnl ),

  .o_rdy    (o_axi_awready ),
  .o_vld    (o_axi_awvalid ),
  .o_dat    (o_axi_aw_chnl),

  .clk      (clk  ),
  .rst_n    (rst_n)
  );


localparam W_CHNL_W = 64+(64/8)+1;
wire [W_CHNL_W-1:0] i_axi_w_chnl = {
                                                i_axi_wdata,
                                                i_axi_wstrb,
                                                i_axi_wlast
                                                 };
wire [W_CHNL_W-1:0] o_axi_w_chnl;
assign { 
         o_axi_wdata,
         o_axi_wstrb,
         o_axi_wlast} = o_axi_w_chnl;

sirv_gnrl_fifo #(
    .CUT_READY (CHNL_FIFO_CUT_READY),
    .MSKO      (0),
    .DP  (CHNL_FIFO_DP),
    .DW  (W_CHNL_W)
) o_axi_wdata_fifo(
  .i_rdy    (i_axi_wready),
  .i_vld    (i_axi_wvalid),
  .i_dat    (i_axi_w_chnl ),

  .o_rdy    (o_axi_wready),
  .o_vld    (o_axi_wvalid),
  .o_dat    (o_axi_w_chnl),

  .clk        (clk  ),
  .rst_n      (rst_n)
);
//


localparam R_CHNL_W = 64+2+1;
wire [R_CHNL_W-1:0] o_axi_r_chnl = {
                                                o_axi_rdata,
                                                o_axi_rresp,
                                                o_axi_rlast 
                                                 };
wire [R_CHNL_W-1:0] i_axi_r_chnl;
assign {
        i_axi_rdata,
        i_axi_rresp,
        i_axi_rlast} = i_axi_r_chnl;

sirv_gnrl_fifo # (
    .CUT_READY (CHNL_FIFO_CUT_READY),
    .MSKO      (0),
    .DP  (CHNL_FIFO_DP),
    .DW  (R_CHNL_W)
) o_axi_rdata_fifo(
  .i_rdy    (o_axi_rready),
  .i_vld    (o_axi_rvalid),
  .i_dat    (o_axi_r_chnl ),


  .o_rdy    (i_axi_rready),
  .o_vld    (i_axi_rvalid),
  .o_dat    (i_axi_r_chnl),
  .clk      (clk  ),
  .rst_n    (rst_n)
);
//


localparam B_CHNL_W = 2;

wire [B_CHNL_W -1:0] o_axi_b_chnl = {
           o_axi_bresp
           };

wire [B_CHNL_W -1:0] i_axi_b_chnl;
assign {
           i_axi_bresp
           } = i_axi_b_chnl;

sirv_gnrl_fifo #(
    .CUT_READY (CHNL_FIFO_CUT_READY),
    .MSKO      (0),
    .DP  (CHNL_FIFO_DP),
    .DW  (B_CHNL_W)
) o_axi_bresp_fifo (
  .i_rdy    (o_axi_bready     ),
  .i_vld    (o_axi_bvalid     ),
  .i_dat    (o_axi_b_chnl),

  .o_rdy    (i_axi_bready),
  .o_vld    (i_axi_bvalid),
  .o_dat    (i_axi_b_chnl),

  .clk       (clk  ),
  .rst_n     (rst_n)
  );



endmodule 