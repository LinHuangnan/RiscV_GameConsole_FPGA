 /*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The system memory bus and the ROM instance 
//
// ====================================================================


//`include "e203_defines.v"
`include "../src/e203_defines.v"

module e203_subsys_mems(

  //test ports
  //output  almost_empty,


  input CLK50MHZ,
  input                          mem_icb_cmd_valid,
  output                         mem_icb_cmd_ready,
  input  [`E203_ADDR_SIZE-1:0]   mem_icb_cmd_addr, 
  input                          mem_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        mem_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      mem_icb_cmd_wmask,
  //
  output                         mem_icb_rsp_valid,
  input                          mem_icb_rsp_ready,
  output                         mem_icb_rsp_err,
  output [`E203_XLEN-1:0]        mem_icb_rsp_rdata,
  

    //////////////////////////////////////////////////////////
  output                         qspi0_ro_icb_cmd_valid,
  input                          qspi0_ro_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   qspi0_ro_icb_cmd_addr, 
  output                         qspi0_ro_icb_cmd_read, 
  output [`E203_XLEN-1:0]        qspi0_ro_icb_cmd_wdata,
  //
  input                          qspi0_ro_icb_rsp_valid,
  output                         qspi0_ro_icb_rsp_ready,
  input                          qspi0_ro_icb_rsp_err,
  input  [`E203_XLEN-1:0]        qspi0_ro_icb_rsp_rdata,


  //////////////////////////////////////////////////////////
  output                         dm_icb_cmd_valid,
  input                          dm_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   dm_icb_cmd_addr, 
  output                         dm_icb_cmd_read, 
  output [`E203_XLEN-1:0]        dm_icb_cmd_wdata,
  //
  input                          dm_icb_rsp_valid,
  output                         dm_icb_rsp_ready,
  input  [`E203_XLEN-1:0]        dm_icb_rsp_rdata,


  /////////////////////////////////////////////////////////
  output                         sysmem_icb_cmd_valid,
  input                          sysmem_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   sysmem_icb_cmd_addr, 
  output                         sysmem_icb_cmd_read, 
  output [`E203_XLEN-1:0]        sysmem_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      sysmem_icb_cmd_wmask,
  //
  input                          sysmem_icb_rsp_valid,
  output                         sysmem_icb_rsp_ready,
  input                          sysmem_icb_rsp_err  ,
  input  [`E203_XLEN-1:0]        sysmem_icb_rsp_rdata,

  /*
  //DDR3接口
  input             pad_loop_in      , //低位温度补偿输入
  input             pad_loop_in_h    , //高位温度补偿输入
  output            pad_rstn_ch0     , //Memory复位
  output            pad_ddr_clk_w    , //Memory差分时钟正端
  output            pad_ddr_clkn_w   , //Memory差分时钟负端
  output            pad_csn_ch0      , //Memory片选
  output [15:0]     pad_addr_ch0     , //Memory地址总线
  inout  [16-1:0]   pad_dq_ch0       , //数据总线
  inout  [16/8-1:0] pad_dqs_ch0      , //数据时钟正端
  inout  [16/8-1:0] pad_dqsn_ch0     , //数据时钟负端
  output [16/8-1:0] pad_dm_rdqs_ch0  , //数据Mask
  output            pad_cke_ch0      , //Memory差分时钟使能
  output            pad_odt_ch0      , //On Die Termination
  output            pad_rasn_ch0     , //行地址strobe
  output            pad_casn_ch0     , //列地址strobe
  output            pad_wen_ch0      , //写使能
  output [2:0]      pad_ba_ch0       , //Bank地址总线
  output            pad_loop_out     , //低位温度补偿输出
  output            pad_loop_out_h   ,  //高位温度补偿输出   
  output            ddr_init_done, 

  //hdmi interface
  output       tmds_clk_p,    // TMDS 时钟通道
  output       tmds_clk_n,
  output [2:0] tmds_data_p,   // TMDS 数据通道
  output [2:0] tmds_data_n,

  //以太网接口
  input              eth_rxc     , //RGMII接收数据时钟
  input              eth_rx_ctl  , //RGMII输入数据有效信号
  input       [3:0]  eth_rxd     , //RGMII输入数据
  output             eth_txc     , //RGMII发送数据时钟    
  output             eth_tx_ctl  , //RGMII输出数据有效信号
  output      [3:0]  eth_txd     , //RGMII输出数据          
  output             eth_rst_n   , //以太网芯片复位信号，低电平有效    
  input               transfer_flag,
  */

  input  clk,
  input  bus_rst_n,
  input  rst_n
  );

//parameter define
//开发板MAC地址 00-11-22-33-44-55
parameter  BOARD_MAC = 48'h00_11_22_33_44_55;     
//开发板IP地址 192.168.1.10
parameter  BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};  
//目的MAC地址 ff_ff_ff_ff_ff_ff
parameter  DES_MAC   = 48'hff_ff_ff_ff_ff_ff;  
//目的IP地址 192.168.1.102     
parameter  DES_IP    = {8'd192,8'd168,8'd1,8'd102};


      
  wire                         mrom_icb_cmd_valid;
  wire                         mrom_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   mrom_icb_cmd_addr; 
  wire                         mrom_icb_cmd_read; 
  
  wire                         mrom_icb_rsp_valid;
  wire                         mrom_icb_rsp_ready;
  wire                         mrom_icb_rsp_err  ;
  wire [`E203_XLEN-1:0]        mrom_icb_rsp_rdata;


  /*
  wire                         sysmem_icb_cmd_valid;
  wire                          sysmem_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   sysmem_icb_cmd_addr;
  wire                         sysmem_icb_cmd_read;
  wire [`E203_XLEN-1:0]        sysmem_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      sysmem_icb_cmd_wmask;
  //
  wire                          sysmem_icb_rsp_valid;
  wire                          sysmem_icb_rsp_ready;
  wire                          sysmem_icb_rsp_err;
  wire  [`E203_XLEN-1:0]        sysmem_icb_rsp_rdata;


  wire                          sysmem_icb_cmd_valid_1;
  wire                          sysmem_icb_cmd_ready_1;
  wire [`E203_ADDR_SIZE-1:0]    sysmem_icb_cmd_addr_1;
  wire                          sysmem_icb_cmd_read_1;
  wire [64-1:0]                 sysmem_icb_cmd_wdata_1;
  wire [64/8-1:0]               sysmem_icb_cmd_wmask_1;
  //
  wire                          sysmem_icb_rsp_valid_1;
  wire                          sysmem_icb_rsp_ready_1;
  wire                          sysmem_icb_rsp_err_1;
  wire  [64-1:0]                sysmem_icb_rsp_rdata_1;

  */

 localparam MROM_AW = 12  ;
 localparam MROM_DP = 1024;
  // There are several slaves for Mem bus, including:
  //  * DM        : 0x0000 0000 -- 0x0000 0FFF
  //  * MROM      : 0x0000 1000 -- 0x0000 1FFF
  //  * QSPI0-RO  : 0x2000 0000 -- 0x3FFF FFFF
  //  * SysMem    : 0x8000 0000 -- 0xFFFF FFFF

  sirv_icb1to8_bus # (
  .ICB_FIFO_DP        (2),// We add a ping-pong buffer here to cut down the timing path
  .ICB_FIFO_CUT_READY (1),// We configure it to cut down the back-pressure ready signal
  .AW                   (32),
  .DW                   (`E203_XLEN),
  .SPLT_FIFO_OUTS_NUM   (1),// The Mem only allow 1 oustanding
  .SPLT_FIFO_CUT_READY  (1),// The Mem always cut ready
  //  * DM        : 0x0000 0000 -- 0x0000 0FFF
  .O0_BASE_ADDR       (32'h0000_0000),       
  .O0_BASE_REGION_LSB (12),
  //  * MROM      : 0x0000 1000 -- 0x0000 1FFF
  .O1_BASE_ADDR       (32'h0000_1000),       
  .O1_BASE_REGION_LSB (12),
  //  * Not used  : 0x0002 0000 -- 0x0003 FFFF
  .O2_BASE_ADDR       (32'h0002_0000),       
  .O2_BASE_REGION_LSB (17),
  //  * QSPI0-RO  : 0x2000 0000 -- 0x3FFF FFFF
  .O3_BASE_ADDR       (32'h2000_0000),       
  .O3_BASE_REGION_LSB (29),
  //  * SysMem    : 0x8000 0000 -- 0xFFFF FFFF
  //    Actually since the 0xFxxx xxxx have been occupied by FIO, 
  //    sysmem have no chance to access it
  .O4_BASE_ADDR       (32'h8000_0000),       
  .O4_BASE_REGION_LSB (31),

  /*
      // * Here is an example AXI Peripheral
  .O5_BASE_ADDR       (32'h4000_0000),       
  .O5_BASE_REGION_LSB (28),
  */
  
  .O5_BASE_ADDR       (32'h0000_0000),       
  .O5_BASE_REGION_LSB (0),
  
      // Not used
  .O6_BASE_ADDR       (32'h0000_0000),       
  .O6_BASE_REGION_LSB (0),
  
      // Not used
  .O7_BASE_ADDR       (32'h0000_0000),       
  .O7_BASE_REGION_LSB (0)

  )u_sirv_mem_fab(

    .i_icb_cmd_valid  (mem_icb_cmd_valid),
    .i_icb_cmd_ready  (mem_icb_cmd_ready),
    .i_icb_cmd_addr   (mem_icb_cmd_addr ),
    .i_icb_cmd_read   (mem_icb_cmd_read ),
    .i_icb_cmd_wdata  (mem_icb_cmd_wdata),
    .i_icb_cmd_wmask  (mem_icb_cmd_wmask),
    .i_icb_cmd_lock   (1'b0 ),
    .i_icb_cmd_excl   (1'b0 ),
    .i_icb_cmd_size   (2'b0 ),
    .i_icb_cmd_burst  (2'b0),
    .i_icb_cmd_beat   (2'b0 ),
    
    .i_icb_rsp_valid  (mem_icb_rsp_valid),
    .i_icb_rsp_ready  (mem_icb_rsp_ready),
    .i_icb_rsp_err    (mem_icb_rsp_err  ),
    .i_icb_rsp_excl_ok(),
    .i_icb_rsp_rdata  (mem_icb_rsp_rdata),
    
  //  * DM
    .o0_icb_enable     (1'b1),

    .o0_icb_cmd_valid  (dm_icb_cmd_valid),
    .o0_icb_cmd_ready  (dm_icb_cmd_ready),
    .o0_icb_cmd_addr   (dm_icb_cmd_addr ),
    .o0_icb_cmd_read   (dm_icb_cmd_read ),
    .o0_icb_cmd_wdata  (dm_icb_cmd_wdata),
    .o0_icb_cmd_wmask  (),
    .o0_icb_cmd_lock   (),
    .o0_icb_cmd_excl   (),
    .o0_icb_cmd_size   (),
    .o0_icb_cmd_burst  (),
    .o0_icb_cmd_beat   (),
    
    .o0_icb_rsp_valid  (dm_icb_rsp_valid),
    .o0_icb_rsp_ready  (dm_icb_rsp_ready),
    .o0_icb_rsp_err    (1'b0),
    .o0_icb_rsp_excl_ok(1'b0),
    .o0_icb_rsp_rdata  (dm_icb_rsp_rdata),

  //  * MROM      
    .o1_icb_enable     (1'b1),

    .o1_icb_cmd_valid  (mrom_icb_cmd_valid),
    .o1_icb_cmd_ready  (mrom_icb_cmd_ready),
    .o1_icb_cmd_addr   (mrom_icb_cmd_addr ),
    .o1_icb_cmd_read   (mrom_icb_cmd_read ),
    .o1_icb_cmd_wdata  (),
    .o1_icb_cmd_wmask  (),
    .o1_icb_cmd_lock   (),
    .o1_icb_cmd_excl   (),
    .o1_icb_cmd_size   (),
    .o1_icb_cmd_burst  (),
    .o1_icb_cmd_beat   (),
    
    .o1_icb_rsp_valid  (mrom_icb_rsp_valid),
    .o1_icb_rsp_ready  (mrom_icb_rsp_ready),
    .o1_icb_rsp_err    (mrom_icb_rsp_err),
    .o1_icb_rsp_excl_ok(1'b0  ),
    .o1_icb_rsp_rdata  (mrom_icb_rsp_rdata),

  //  * Not used    
    .o2_icb_enable     (1'b0),

    .o2_icb_cmd_valid  (),
    .o2_icb_cmd_ready  (1'b0),
    .o2_icb_cmd_addr   (),
    .o2_icb_cmd_read   (),
    .o2_icb_cmd_wdata  (),
    .o2_icb_cmd_wmask  (),
    .o2_icb_cmd_lock   (),
    .o2_icb_cmd_excl   (),
    .o2_icb_cmd_size   (),
    .o2_icb_cmd_burst  (),
    .o2_icb_cmd_beat   (),
    
    .o2_icb_rsp_valid  (1'b0),
    .o2_icb_rsp_ready  (),
    .o2_icb_rsp_err    (1'b0  ),
    .o2_icb_rsp_excl_ok(1'b0  ),
    .o2_icb_rsp_rdata  (`E203_XLEN'b0),


  //  * QSPI0-RO  
    .o3_icb_enable     (1'b1),

    .o3_icb_cmd_valid  (qspi0_ro_icb_cmd_valid),
    .o3_icb_cmd_ready  (qspi0_ro_icb_cmd_ready),
    .o3_icb_cmd_addr   (qspi0_ro_icb_cmd_addr ),
    .o3_icb_cmd_read   (qspi0_ro_icb_cmd_read ),
    .o3_icb_cmd_wdata  (qspi0_ro_icb_cmd_wdata),
    .o3_icb_cmd_wmask  (),
    .o3_icb_cmd_lock   (),
    .o3_icb_cmd_excl   (),
    .o3_icb_cmd_size   (),
    .o3_icb_cmd_burst  (),
    .o3_icb_cmd_beat   (),
    
    .o3_icb_rsp_valid  (qspi0_ro_icb_rsp_valid),
    .o3_icb_rsp_ready  (qspi0_ro_icb_rsp_ready),
    .o3_icb_rsp_err    (qspi0_ro_icb_rsp_err),
    .o3_icb_rsp_excl_ok(1'b0  ),
    .o3_icb_rsp_rdata  (qspi0_ro_icb_rsp_rdata),


  //  * SysMem
    .o4_icb_enable     (1'b1),

    .o4_icb_cmd_valid  (sysmem_icb_cmd_valid),
    .o4_icb_cmd_ready  (sysmem_icb_cmd_ready),
    .o4_icb_cmd_addr   (sysmem_icb_cmd_addr ),
    .o4_icb_cmd_read   (sysmem_icb_cmd_read ),
    .o4_icb_cmd_wdata  (sysmem_icb_cmd_wdata),
    .o4_icb_cmd_wmask  (sysmem_icb_cmd_wmask),
    .o4_icb_cmd_lock   (),
    .o4_icb_cmd_excl   (),
    .o4_icb_cmd_size   (),
    .o4_icb_cmd_burst  (),
    .o4_icb_cmd_beat   (),
    
    .o4_icb_rsp_valid  (sysmem_icb_rsp_valid),
    .o4_icb_rsp_ready  (sysmem_icb_rsp_ready),
    .o4_icb_rsp_err    (sysmem_icb_rsp_err    ),
    .o4_icb_rsp_excl_ok(1'b0),
    .o4_icb_rsp_rdata  (sysmem_icb_rsp_rdata),

    /*
   //  * Example AXI    
    .o5_icb_enable     (1'b1),

    .o5_icb_cmd_valid  (expl_axi_icb_cmd_valid),
    .o5_icb_cmd_ready  (expl_axi_icb_cmd_ready),
    .o5_icb_cmd_addr   (expl_axi_icb_cmd_addr ),
    .o5_icb_cmd_read   (expl_axi_icb_cmd_read ),
    .o5_icb_cmd_wdata  (expl_axi_icb_cmd_wdata),
    .o5_icb_cmd_wmask  (expl_axi_icb_cmd_wmask),
    .o5_icb_cmd_lock   (),
    .o5_icb_cmd_excl   (),
    .o5_icb_cmd_size   (),
    .o5_icb_cmd_burst  (),
    .o5_icb_cmd_beat   (),
    
    .o5_icb_rsp_valid  (expl_axi_icb_rsp_valid),
    .o5_icb_rsp_ready  (expl_axi_icb_rsp_ready),
    .o5_icb_rsp_err    (expl_axi_icb_rsp_err),
    .o5_icb_rsp_excl_ok(1'b0  ),
    .o5_icb_rsp_rdata  (expl_axi_icb_rsp_rdata),
    */
    
    
    .o5_icb_enable     (1'b0),

    .o5_icb_cmd_valid  (),
    .o5_icb_cmd_ready  (1'b0),
    .o5_icb_cmd_addr   ( ),
    .o5_icb_cmd_read   ( ),
    .o5_icb_cmd_wdata  (),
    .o5_icb_cmd_wmask  (),
    .o5_icb_cmd_lock   (),
    .o5_icb_cmd_excl   (),
    .o5_icb_cmd_size   (),
    .o5_icb_cmd_burst  (),
    .o5_icb_cmd_beat   (),
    
    .o5_icb_rsp_valid  (1'b0),
    .o5_icb_rsp_ready  (),
    .o5_icb_rsp_err    (1'b0),
    .o5_icb_rsp_excl_ok(1'b0  ),
    .o5_icb_rsp_rdata  (`E203_XLEN'b0),
    
        //  * Not used
    .o6_icb_enable     (1'b0),

    .o6_icb_cmd_valid  (),
    .o6_icb_cmd_ready  (1'b0),
    .o6_icb_cmd_addr   (),
    .o6_icb_cmd_read   (),
    .o6_icb_cmd_wdata  (),
    .o6_icb_cmd_wmask  (),
    .o6_icb_cmd_lock   (),
    .o6_icb_cmd_excl   (),
    .o6_icb_cmd_size   (),
    .o6_icb_cmd_burst  (),
    .o6_icb_cmd_beat   (),
    
    .o6_icb_rsp_valid  (1'b0),
    .o6_icb_rsp_ready  (),
    .o6_icb_rsp_err    (1'b0  ),
    .o6_icb_rsp_excl_ok(1'b0  ),
    .o6_icb_rsp_rdata  (`E203_XLEN'b0),

        //  * Not used
    .o7_icb_enable     (1'b0),

    .o7_icb_cmd_valid  (),
    .o7_icb_cmd_ready  (1'b0),
    .o7_icb_cmd_addr   (),
    .o7_icb_cmd_read   (),
    .o7_icb_cmd_wdata  (),
    .o7_icb_cmd_wmask  (),
    .o7_icb_cmd_lock   (),
    .o7_icb_cmd_excl   (),
    .o7_icb_cmd_size   (),
    .o7_icb_cmd_burst  (),
    .o7_icb_cmd_beat   (),
    
    .o7_icb_rsp_valid  (1'b0),
    .o7_icb_rsp_ready  (),
    .o7_icb_rsp_err    (1'b0  ),
    .o7_icb_rsp_excl_ok(1'b0  ),
    .o7_icb_rsp_rdata  (`E203_XLEN'b0),

    .clk           (clk  ),
    .rst_n         (bus_rst_n) 
  );

  sirv_mrom_top #(
    .AW(MROM_AW),
    .DW(32),
    .DP(MROM_DP)
  )u_sirv_mrom_top(

    .rom_icb_cmd_valid  (mrom_icb_cmd_valid),
    .rom_icb_cmd_ready  (mrom_icb_cmd_ready),
    .rom_icb_cmd_addr   (mrom_icb_cmd_addr [MROM_AW-1:0]),
    .rom_icb_cmd_read   (mrom_icb_cmd_read ),
    
    .rom_icb_rsp_valid  (mrom_icb_rsp_valid),
    .rom_icb_rsp_ready  (mrom_icb_rsp_ready),
    .rom_icb_rsp_err    (mrom_icb_rsp_err  ),
    .rom_icb_rsp_rdata  (mrom_icb_rsp_rdata),

    .clk           (clk  ),
    .rst_n         (rst_n) 
  );

  /*
  // * Here is an example AXI Peripheral
  wire expl_axi_arvalid;
  wire expl_axi_arready;
  wire [`E203_ADDR_SIZE-1:0] expl_axi_araddr;
  wire [3:0] expl_axi_arcache;
  wire [2:0] expl_axi_arprot;
  wire [1:0] expl_axi_arlock;
  wire [1:0] expl_axi_arburst;
  wire [7:0] expl_axi_arlen;
  wire [2:0] expl_axi_arsize;

  wire expl_axi_awvalid;
  wire expl_axi_awready;
  wire [`E203_ADDR_SIZE-1:0] expl_axi_awaddr;
  wire [3:0] expl_axi_awcache;
  wire [2:0] expl_axi_awprot;
  wire [1:0] expl_axi_awlock;
  wire [1:0] expl_axi_awburst;
  wire [7:0] expl_axi_awlen;
  wire [2:0] expl_axi_awsize;

  wire expl_axi_rvalid;
  wire expl_axi_rready;
  wire [64-1:0] expl_axi_rdata;

  wire [1:0] expl_axi_rresp;
  wire expl_axi_rlast;

  wire expl_axi_wvalid;
  wire expl_axi_wready;
  wire [64-1:0] expl_axi_wdata;
  wire [(64/8)-1:0] expl_axi_wstrb;
  wire expl_axi_wlast;

  wire expl_axi_bvalid;
  wire expl_axi_bready;
  wire [1:0] expl_axi_bresp;






sirv_gnrl_icb32_to_axi64 # (
  .AXI_FIFO_DP (0), // We just add ping-pong buffer here to avoid any potential timing loops
                    //   User can change it to 0 if dont care
  .AXI_FIFO_CUT_READY (1), // This is to cut the back-pressure signal if you set as 1
  .AW   (32),
  .FIFO_OUTS_NUM (4),// We only allow 4 oustandings at most for mem, user can configure it to any value
  .FIFO_CUT_READY(1),
  .DW   (64) 
) u_icb32_to_axi64(
    .i_icb_cmd_valid (sysmem_icb_cmd_valid),
    .i_icb_cmd_ready (sysmem_icb_cmd_ready),
    .i_icb_cmd_addr  (sysmem_icb_cmd_addr ),
    .i_icb_cmd_read  (sysmem_icb_cmd_read ),
    .i_icb_cmd_wdata (sysmem_icb_cmd_wdata),
    .i_icb_cmd_wmask (sysmem_icb_cmd_wmask),
    .i_icb_cmd_size  (),
    
    .i_icb_rsp_valid (sysmem_icb_rsp_valid),
    .i_icb_rsp_ready (sysmem_icb_rsp_ready),
    .i_icb_rsp_rdata (sysmem_icb_rsp_rdata),
    .i_icb_rsp_err   (sysmem_icb_rsp_err),

    .o_axi_arvalid   (expl_axi_arvalid),
    .o_axi_arready   (expl_axi_arready),
    .o_axi_araddr    (expl_axi_araddr ),
    .o_axi_arcache   (expl_axi_arcache),
    .o_axi_arprot    (expl_axi_arprot ),
    .o_axi_arlock    (expl_axi_arlock ),
    .o_axi_arburst   (expl_axi_arburst),
    .o_axi_arlen     (expl_axi_arlen  ),
    .o_axi_arsize    (expl_axi_arsize ),
                      
    .o_axi_awvalid   (expl_axi_awvalid),
    .o_axi_awready   (expl_axi_awready),
    .o_axi_awaddr    (expl_axi_awaddr ),
    .o_axi_awcache   (expl_axi_awcache),
    .o_axi_awprot    (expl_axi_awprot ),
    .o_axi_awlock    (expl_axi_awlock ),
    .o_axi_awburst   (expl_axi_awburst),
    .o_axi_awlen     (expl_axi_awlen  ),
    .o_axi_awsize    (expl_axi_awsize ),
                     
    .o_axi_rvalid    (expl_axi_rvalid ),
    .o_axi_rready    (expl_axi_rready ),
    .o_axi_rdata     (expl_axi_rdata  ),
    .o_axi_rresp     (expl_axi_rresp  ),
    .o_axi_rlast     (expl_axi_rlast  ),
                    
    .o_axi_wvalid    (expl_axi_wvalid ),
    .o_axi_wready    (expl_axi_wready ),
    .o_axi_wdata     (expl_axi_wdata  ),
    .o_axi_wstrb     (expl_axi_wstrb  ),
    .o_axi_wlast     (expl_axi_wlast  ),
                   
    .o_axi_bvalid    (expl_axi_bvalid ),
    .o_axi_bready    (expl_axi_bready ),
    .o_axi_bresp     (expl_axi_bresp  ),

    .clk           (clk  ),
    .rst_n         (bus_rst_n) 
  );



//wire for hdmi
wire              axi_clk_75M;
wire  [32-1:0]    hdmi_axi_araddr     ;
wire  [7:0]       hdmi_axi_arlen      ;
wire  [2:0]       hdmi_axi_arsize     ;
wire  [1:0]       hdmi_axi_arburst    ;
wire              hdmi_axi_arlock     ;
wire              hdmi_axi_arpoison   ;
wire              hdmi_axi_arurgent   ;
wire              hdmi_axi_arready    ;
wire              hdmi_axi_arvalid    ;
wire  [128-1:0]   hdmi_axi_rdata      ;
wire              hdmi_axi_rlast      ;
wire              hdmi_axi_rvalid     ;
wire              hdmi_axi_rready     ;

wire    almost_full;
wire    wr_en;

wire                pix_clk_75M;
wire    [24-1:0]    pix_data;
wire                data_req;
wire    [16-1:0]    frame_rdata;

wire          video_vs;
wire          video_de;


//hdmi读ddr3控制器模块
rw_ctrl_128bit  u_rw_ctrl_128bit
(
 .clk                 (axi_clk_75M), 
 .rst_n               (bus_rst_n        ),
 .ddr_init_done       (ddr_init_done),

 .axi_araddr          (hdmi_axi_araddr       ),
 .axi_arlen           (hdmi_axi_arlen        ),
 .axi_arsize          (hdmi_axi_arsize       ),
 .axi_arburst         (hdmi_axi_arburst      ),
 .axi_arlock          (hdmi_axi_arlock       ),
 .axi_arpoison        (hdmi_axi_arpoison     ),
 .axi_arurgent        (hdmi_axi_arurgent     ),
 .axi_arready         (hdmi_axi_arready      ),
 .axi_arvalid         (hdmi_axi_arvalid      ),
 .axi_rlast           (hdmi_axi_rlast        ),
 .axi_rvalid          (hdmi_axi_rvalid       ),
 .axi_rready          (hdmi_axi_rready       ),

  .almost_full(almost_full)
 );



//ddr3 interface
ddr3_ip u_ddr3_ip (
  .pll_refclk_in(CLK50MHZ),        // input
  .top_rst_n(bus_rst_n),                // input
  .ddrc_rst(~bus_rst_n),                  // input
  .csysreq_ddrc(1'b1),          // input
  .csysack_ddrc(),          // output
  .cactive_ddrc(),          // output
  .pll_lock(),                  // output
  .pll_aclk_0(axi_clk_75M),              // output
  .pll_aclk_1(),              // output
  .pll_aclk_2(),              // output
  .ddrphy_rst_done(),    // output
  .ddrc_init_done(ddr_init_done),      // output
  .pad_loop_in(pad_loop_in),            // input
  .pad_loop_in_h(pad_loop_in_h),        // input
  .pad_rstn_ch0(pad_rstn_ch0),          // output
  .pad_ddr_clk_w(pad_ddr_clk_w),        // output
  .pad_ddr_clkn_w(pad_ddr_clkn_w),      // output
  .pad_csn_ch0(pad_csn_ch0),            // output
  .pad_addr_ch0(pad_addr_ch0),          // output [15:0]
  .pad_dq_ch0(pad_dq_ch0),              // inout [15:0]
  .pad_dqs_ch0(pad_dqs_ch0),            // inout [1:0]
  .pad_dqsn_ch0(pad_dqsn_ch0),          // inout [1:0]
  .pad_dm_rdqs_ch0(pad_dm_rdqs_ch0),    // output [1:0]
  .pad_cke_ch0(pad_cke_ch0),            // output
  .pad_odt_ch0(pad_odt_ch0),            // output
  .pad_rasn_ch0(pad_rasn_ch0),          // output
  .pad_casn_ch0(pad_casn_ch0),          // output
  .pad_wen_ch0(pad_wen_ch0),            // output
  .pad_ba_ch0(pad_ba_ch0),              // output [2:0]
  .pad_loop_out(pad_loop_out),          // output
  .pad_loop_out_h(pad_loop_out_h),      // output


  //ports for hdmi
  .areset_0(~bus_rst_n),                  // input
  .aclk_0(axi_clk_75M),                      // input
  .awid_0(0),                      // input [7:0]
  .awaddr_0(32'b0),                  // input [31:0]
  .awlen_0(8'b0),                    // input [7:0]
  .awsize_0(3'b100),                  // input [2:0]
  .awburst_0(2'd1),                // input [1:0]
  .awlock_0(1'b0),                  // input
  .awvalid_0(1'b0),                // input
  .awready_0(),                // output
  .awurgent_0(0),              // input
  .awpoison_0(0),              // input
  .wdata_0(128'b0),                    // input [127:0]
  .wstrb_0(16'hff),                    // input [15:0]
  .wlast_0(1'b0),                    // input
  .wvalid_0(1'b0),                  // input
  .wready_0(),                  // output
  .bid_0(),                        // output [7:0]
  .bresp_0(),                    // output [1:0]
  .bvalid_0(),                  // output
  .bready_0(1'b1),                  // input

  .arid_0(0),                      // input [7:0]
  .araddr_0(hdmi_axi_araddr),                  // input [31:0]
  .arlen_0(hdmi_axi_arlen),                    // input [7:0]
  .arsize_0(hdmi_axi_arsize),                  // input [2:0]
  .arburst_0(hdmi_axi_arburst),                // input [1:0]
  .arlock_0(hdmi_axi_arlock),                  // input
  .arvalid_0(hdmi_axi_arvalid),                // input
  .arready_0(hdmi_axi_arready),                // output
  .arpoison_0(hdmi_axi_arpoison),              // input
  .rid_0(),                        // output [7:0]
  .rdata_0(hdmi_axi_rdata),                    // output [127:0]
  .rresp_0(),                    // output [1:0]
  .rlast_0(hdmi_axi_rlast),                    // output
  .rvalid_0(hdmi_axi_rvalid),                  // output
  .rready_0(hdmi_axi_rready),                  // input
  .arurgent_0(0),              // input
  .csysreq_0(1'b1),                // input
  .csysack_0(),                // output
  .cactive_0(),                // output




  //ports for cpu

  .areset_1(0),                  // input
  .aclk_1(clk),                      // input

  .awid_1(0),                      // input [7:0]
  .awaddr_1(expl_axi_awaddr),                  // input [31:0]
  .awlen_1(expl_axi_awlen),                    // input [7:0]
  .awsize_1(expl_axi_awsize),                  // input [2:0]
  .awburst_1(expl_axi_awburst),                // input [1:0]
  .awlock_1(expl_axi_awlock),                  // input
  .awvalid_1(expl_axi_awvalid),                // input
  .awready_1(expl_axi_awready),                // output
  .awurgent_1(1'b0),              // input
  .awpoison_1(1'b0),              // input
  
  .wdata_1(expl_axi_wdata),                    // input [63:0]
  .wstrb_1(expl_axi_wstrb),                    // input [7:0]
  .wlast_1(expl_axi_wlast),                    // input
  .wvalid_1(expl_axi_wvalid),                  // input
  .wready_1(expl_axi_wready),                  // output
  .bid_1(),                        // output [7:0]

  .bresp_1(expl_axi_bresp),                    // output [1:0]
  .bvalid_1(expl_axi_bvalid),                  // output
  .bready_1(expl_axi_bready),                  // input

  .arid_1(0),                      // input [7:0]
  .araddr_1(expl_axi_araddr),                  // input [31:0]
  .arlen_1(expl_axi_arlen),                    // input [7:0]
  .arsize_1(expl_axi_arsize),                  // input [2:0]
  .arburst_1(expl_axi_arburst),                // input [1:0]
  .arlock_1(expl_axi_arlock),                  // input
  .arvalid_1(expl_axi_arvalid),                // input
  .arready_1(expl_axi_arready),                // output
  .arpoison_1(1'b0),              // input

  .rid_1(),                        // output [7:0]
  .rdata_1(expl_axi_rdata),               // output [63:0]
  .rresp_1(expl_axi_rresp),                    // output [1:0]
  .rlast_1(expl_axi_rlast),                    // output
  .rvalid_1(expl_axi_rvalid),                  // output
  .rready_1(expl_axi_rready),                  // input
  .arurgent_1(1'b0),              // input

  .csysreq_1(1'b1),                // input
  .csysack_1(),                // output
  .cactive_1()                 // output
);

//wire for ethernet
wire            eth_tx_clk      ;   //以太网发送时钟
//wire            transfer_flag   ;   //图像开始传输标志,0:开始传输 1:停止传输
wire            eth_rx_clk      ;   //以太网接收时钟
wire            udp_tx_start_en ;   //以太网开始发送信号
wire   [15:0]   udp_tx_byte_num ;   //以太网发送的有效字节数
wire   [31:0]   udp_tx_data     ;   //以太网发送的数据
    
//wire            udp_rec_pkt_done;   //以太网单包数据接收完成信号
//wire            udp_rec_en      ;   //以太网接收使能信号
//wire   [31:0]   udp_rec_data    ;   //以太网接收到的数据
//wire   [15:0]   udp_rec_byte_num;   //以太网接收到的字节个数
wire            udp_tx_req      ;   //以太网发送请求数据信号
wire            udp_tx_done     ;   //以太网发送完成信号
*/



//开始传输控制模块 
/*  
start_transfer_ctrl u_start_transfer_ctrl(
    .clk                (eth_rx_clk),
    .rst_n              (bus_rst_n),
    .udp_rec_pkt_done   (udp_rec_pkt_done),
    .udp_rec_en         (udp_rec_en      ),
    .udp_rec_data       (udp_rec_data    ),
    .udp_rec_byte_num   (udp_rec_byte_num),

    .transfer_flag      (transfer_flag)      //图像开始传输标志,1:开始传输 0:停止传输
    );   
*/

/*
//图像封装模块     
img_data_pkt u_img_data_pkt(    
  .rst_n              (bus_rst_n),              

  .cam_pclk           (pix_clk_75M),
  .img_vsync          (~video_vs),
  .img_data_en        (video_de),
  .img_data           (frame_rdata),
  .transfer_flag      (transfer_flag),            
  .eth_tx_clk         (eth_tx_clk     ),
  .udp_tx_req         (udp_tx_req     ),
  .udp_tx_done        (udp_tx_done    ),
  .udp_tx_start_en    (udp_tx_start_en),
  .udp_tx_data        (udp_tx_data    ),
  .udp_tx_byte_num    (udp_tx_byte_num)
  );  

//以太网顶层模块    
eth_top  #(
    .BOARD_MAC     (BOARD_MAC),              //参数例化
    .BOARD_IP      (BOARD_IP ),          
    .DES_MAC       (DES_MAC  ),          
    .DES_IP        (DES_IP   )          
    )          
    u_eth_top(          
    .sys_rst_n       (bus_rst_n     ),           //系统复位信号，低电平有效           
    //以太网RGMII接口             
    .eth_rxc         (eth_rxc   ),           //RGMII接收数据时钟
    .eth_rx_ctl      (eth_rx_ctl),           //RGMII输入数据有效信号
    .eth_rxd         (eth_rxd   ),           //RGMII输入数据
    .eth_txc         (eth_txc   ),           //RGMII发送数据时钟    
    .eth_tx_ctl      (eth_tx_ctl),           //RGMII输出数据有效信号
    .eth_txd         (eth_txd   ),           //RGMII输出数据          
    .eth_rst_n       (eth_rst_n ),           //以太网芯片复位信号，低电平有效 

    .gmii_rx_clk     (eth_rx_clk),
    .gmii_tx_clk     (eth_tx_clk),       
    .udp_tx_start_en (udp_tx_start_en),
    .tx_data         (udp_tx_data),
    .tx_byte_num     (udp_tx_byte_num),
    .udp_tx_done     (udp_tx_done),
    .tx_req          (udp_tx_req )
    //.rec_pkt_done    (udp_rec_pkt_done),
    //.rec_en          (udp_rec_en      ),
    //.rec_data        (udp_rec_data    ),
    //.rec_byte_num    (udp_rec_byte_num)
    );





assign  wr_en = hdmi_axi_rvalid & hdmi_axi_rready;
assign  pix_data = {frame_rdata[15:11],3'b0,frame_rdata[10:5],2'b0,frame_rdata[4:0],3'b0};

hdmi_colorbar_top u_hdmi_colorbar_top(
    .sys_clk(CLK50MHZ),
    .sys_rst_n(bus_rst_n),
    
    .tmds_clk_p(tmds_clk_p),    // TMDS 时钟通道
    .tmds_clk_n(tmds_clk_n),
    .tmds_data_p(tmds_data_p),   // TMDS 数据通道
    .tmds_data_n(tmds_data_n),

    .video_vs       (video_vs),
    .video_de       (video_de),
    .almost_empty(almost_empty),
    .pixel_clk(pix_clk_75M),
    .data_req(data_req),
    .pix_data(pix_data)

);


frame_fifo u_frame_fifo (
  .wr_clk(axi_clk_75M),                // input
  .wr_rst((~bus_rst_n)),                // input
  .wr_en(wr_en),                  // input
  .wr_data(hdmi_axi_rdata),              // input [127:0]
  .almost_full(almost_full),      // output

  .rd_clk(pix_clk_75M),                // input
  .rd_rst((~bus_rst_n)),                // input
  .rd_en(data_req),                  // input
  .almost_empty(almost_empty),     // output
  .rd_data(frame_rdata)              // output [15:0]
);
*/
endmodule
