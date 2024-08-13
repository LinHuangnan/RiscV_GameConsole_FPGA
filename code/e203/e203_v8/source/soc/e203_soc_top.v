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
                                                                         
`include "../src/e203_defines.v"                                                                          
                                                                         
module e203_soc_top(

  //output almost_empty,

  //output [31:0]     expl_axi_rdata,

  input CLK50MHZ,
    // This clock should comes from the crystal pad generated high speed clock (16MHz)
  input  hfextclk,
  output hfxoscen,// The signal to enable the crystal pad generated clock

  // This clock should comes from the crystal pad generated low speed clock (32.768KHz)
  input  lfextclk,
  output lfxoscen,// The signal to enable the crystal pad generated clock

  /*
  // The JTAG TCK is input, need to be pull-up
  input   io_pads_jtag_TCK_i_ival,

  // The JTAG TMS is input, need to be pull-up
  input   io_pads_jtag_TMS_i_ival,

  // The JTAG TDI is input, need to be pull-up
  input   io_pads_jtag_TDI_i_ival,

  // The JTAG TDO is output have enable
  output  io_pads_jtag_TDO_o_oval,
  output  io_pads_jtag_TDO_o_oe,
  */
  // The GPIO are all bidir pad have enables
  input  [32-1:0] io_pads_gpioA_i_ival,
  output [32-1:0] io_pads_gpioA_o_oval,
  output [32-1:0] io_pads_gpioA_o_oe,

  //input  [32-1:0] io_pads_gpioB_i_ival,
  //output [32-1:0] io_pads_gpioB_o_oval,
  //output [32-1:0] io_pads_gpioB_o_oe,

  //QSPI0 SCK and CS is output without enable
  output  io_pads_qspi0_sck_o_oval,
  output  io_pads_qspi0_cs_0_o_oval,

  
  output                         sysmem_icb_cmd_valid,
  input                          sysmem_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   sysmem_icb_cmd_addr, 
  output                         sysmem_icb_cmd_read, 
  output [`E203_XLEN-1:0]        sysmem_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      sysmem_icb_cmd_wmask,

  input                          sysmem_icb_rsp_valid,
  output                         sysmem_icb_rsp_ready,
  input                          sysmem_icb_rsp_err,
  input  [`E203_XLEN-1:0]        sysmem_icb_rsp_rdata,
  output main_rst_n,
  //output hfclk,
  
  /*
  ///////////////////////////////////////
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
  input             transfer_flag,
  */

  //QSPI0 DQ is bidir I/O with enable, and need pull-up enable
  input   io_pads_qspi0_dq_0_i_ival,
  output  io_pads_qspi0_dq_0_o_oval,
  output  io_pads_qspi0_dq_0_o_oe,
  input   io_pads_qspi0_dq_1_i_ival,
  output  io_pads_qspi0_dq_1_o_oval,
  output  io_pads_qspi0_dq_1_o_oe,
  input   io_pads_qspi0_dq_2_i_ival,
  output  io_pads_qspi0_dq_2_o_oval,
  output  io_pads_qspi0_dq_2_o_oe,
  input   io_pads_qspi0_dq_3_i_ival,
  output  io_pads_qspi0_dq_3_o_oval,
  output  io_pads_qspi0_dq_3_o_oe,
  
  // Erst is input need to be pull-up by default
  input   io_pads_aon_erst_n_i_ival,

  // dbgmode are inputs need to be pull-up by default
  input  io_pads_dbgmode0_n_i_ival,
  input  io_pads_dbgmode1_n_i_ival,
  input  io_pads_dbgmode2_n_i_ival,

  // BootRom is input need to be pull-up by default
  input  io_pads_bootrom_n_i_ival,


  // dwakeup is input need to be pull-up by default
  input  io_pads_aon_pmu_dwakeup_n_i_ival,

      // PMU output is just output without enable
  output io_pads_aon_pmu_padrst_o_oval,
  output io_pads_aon_pmu_vddpaden_o_oval 
);


  // The JTAG TCK is input, need to be pull-up
  wire   io_pads_jtag_TCK_i_ival;

  // The JTAG TMS is input, need to be pull-up
  wire   io_pads_jtag_TMS_i_ival;

  // The JTAG TDI is input, need to be pull-up
  wire   io_pads_jtag_TDI_i_ival;

  // The JTAG TDO is output have enable
  wire  io_pads_jtag_TDO_o_oval;
  wire  io_pads_jtag_TDO_o_oe;


 
 wire sysper_icb_cmd_valid;
 wire sysper_icb_cmd_ready;

 wire sysfio_icb_cmd_valid;
 wire sysfio_icb_cmd_ready;

 e203_subsys_top u_e203_subsys_top(

    //.almost_empty(almost_empty),

    //.expl_axi_rdata(expl_axi_rdata),

    .CLK50MHZ(CLK50MHZ),
    .core_mhartid      (1'b0),
    .main_rst_n(main_rst_n),//output


  `ifdef E203_HAS_ITCM_EXTITF //{
    .ext2itcm_icb_cmd_valid  (1'b0),
    .ext2itcm_icb_cmd_ready  (),
    .ext2itcm_icb_cmd_addr   (`E203_ITCM_ADDR_WIDTH'b0 ),
    .ext2itcm_icb_cmd_read   (1'b0 ),
    .ext2itcm_icb_cmd_wdata  (32'b0),
    .ext2itcm_icb_cmd_wmask  (4'b0),
    
    .ext2itcm_icb_rsp_valid  (),
    .ext2itcm_icb_rsp_ready  (1'b0),
    .ext2itcm_icb_rsp_err    (),
    .ext2itcm_icb_rsp_rdata  (),
  `endif//}

  `ifdef E203_HAS_DTCM_EXTITF //{
    .ext2dtcm_icb_cmd_valid  (1'b0),
    .ext2dtcm_icb_cmd_ready  (),
    .ext2dtcm_icb_cmd_addr   (`E203_DTCM_ADDR_WIDTH'b0 ),
    .ext2dtcm_icb_cmd_read   (1'b0 ),
    .ext2dtcm_icb_cmd_wdata  (32'b0),
    .ext2dtcm_icb_cmd_wmask  (4'b0),
    
    .ext2dtcm_icb_rsp_valid  (),
    .ext2dtcm_icb_rsp_ready  (1'b0),
    .ext2dtcm_icb_rsp_err    (),
    .ext2dtcm_icb_rsp_rdata  (),
  `endif//}

  .sysper_icb_cmd_valid (sysper_icb_cmd_valid),
  .sysper_icb_cmd_ready (sysper_icb_cmd_ready),
  .sysper_icb_cmd_read  (), 
  .sysper_icb_cmd_addr  (), 
  .sysper_icb_cmd_wdata (), 
  .sysper_icb_cmd_wmask (), 
  
  .sysper_icb_rsp_valid (sysper_icb_cmd_valid),
  .sysper_icb_rsp_ready (sysper_icb_cmd_ready),
  .sysper_icb_rsp_err   (1'b0  ),
  .sysper_icb_rsp_rdata (32'b0),


  .sysfio_icb_cmd_valid(sysfio_icb_cmd_valid),
  .sysfio_icb_cmd_ready(sysfio_icb_cmd_ready),
  .sysfio_icb_cmd_read (), 
  .sysfio_icb_cmd_addr (), 
  .sysfio_icb_cmd_wdata(), 
  .sysfio_icb_cmd_wmask(), 
   
  .sysfio_icb_rsp_valid(sysfio_icb_cmd_valid),
  .sysfio_icb_rsp_ready(sysfio_icb_cmd_ready),
  .sysfio_icb_rsp_err  (1'b0  ),
  .sysfio_icb_rsp_rdata(32'b0),

  .sysmem_icb_cmd_valid  (sysmem_icb_cmd_valid),
  .sysmem_icb_cmd_ready  (sysmem_icb_cmd_ready),
  .sysmem_icb_cmd_addr   (sysmem_icb_cmd_addr ),
  .sysmem_icb_cmd_read   (sysmem_icb_cmd_read ),
  .sysmem_icb_cmd_wdata  (sysmem_icb_cmd_wdata),
  .sysmem_icb_cmd_wmask  (sysmem_icb_cmd_wmask),
  
  .sysmem_icb_rsp_valid  (sysmem_icb_rsp_valid),
  .sysmem_icb_rsp_ready  (sysmem_icb_rsp_ready),
  .sysmem_icb_rsp_err    (sysmem_icb_rsp_err  ),
  .sysmem_icb_rsp_rdata  (sysmem_icb_rsp_rdata),


  /*
  .ddr_init_done(ddr_init_done),      // output
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


  .tmds_clk_p(tmds_clk_p),    // TMDS 时钟通道
  .tmds_clk_n(tmds_clk_n),
  .tmds_data_p(tmds_data_p),   // TMDS 数据通道
  .tmds_data_n(tmds_data_n),
  .transfer_flag(transfer_flag),

  .eth_rxc         (eth_rxc   ),           //RGMII接收数据时钟
  .eth_rx_ctl      (eth_rx_ctl),           //RGMII输入数据有效信号
  .eth_rxd         (eth_rxd   ),           //RGMII输入数据
  .eth_txc         (eth_txc   ),           //RGMII发送数据时钟    
  .eth_tx_ctl      (eth_tx_ctl),           //RGMII输出数据有效信号
  .eth_txd         (eth_txd   ),           //RGMII输出数据          
  .eth_rst_n       (eth_rst_n ),           //以太网芯片复位信号，低电平有效 
  */
  /*
  .io_pads_jtag_TCK_i_ival    (io_pads_jtag_TCK_i_ival    ),
  .io_pads_jtag_TCK_o_oval    (),
  .io_pads_jtag_TCK_o_oe      (),
  .io_pads_jtag_TCK_o_ie      (),
  .io_pads_jtag_TCK_o_pue     (),
  .io_pads_jtag_TCK_o_ds      (),

  .io_pads_jtag_TMS_i_ival    (io_pads_jtag_TMS_i_ival    ),
  .io_pads_jtag_TMS_o_oval    (),
  .io_pads_jtag_TMS_o_oe      (),
  .io_pads_jtag_TMS_o_ie      (),
  .io_pads_jtag_TMS_o_pue     (),
  .io_pads_jtag_TMS_o_ds      (),

  .io_pads_jtag_TDI_i_ival    (io_pads_jtag_TDI_i_ival    ),
  .io_pads_jtag_TDI_o_oval    (),
  .io_pads_jtag_TDI_o_oe      (),
  .io_pads_jtag_TDI_o_ie      (),
  .io_pads_jtag_TDI_o_pue     (),
  .io_pads_jtag_TDI_o_ds      (),

  .io_pads_jtag_TDO_i_ival    (1'b1    ),
  .io_pads_jtag_TDO_o_oval    (io_pads_jtag_TDO_o_oval    ),
  .io_pads_jtag_TDO_o_oe      (io_pads_jtag_TDO_o_oe      ),
  .io_pads_jtag_TDO_o_ie      (),
  .io_pads_jtag_TDO_o_pue     (),
  .io_pads_jtag_TDO_o_ds      (),

  .io_pads_jtag_TRST_n_i_ival (1'b1 ),
  .io_pads_jtag_TRST_n_o_oval (),
  .io_pads_jtag_TRST_n_o_oe   (),
  .io_pads_jtag_TRST_n_o_ie   (),
  .io_pads_jtag_TRST_n_o_pue  (),
  .io_pads_jtag_TRST_n_o_ds   (),
  */

  .test_mode(1'b0),
  .test_iso_override(1'b0),

  .io_pads_gpioA_i_ival       (io_pads_gpioA_i_ival),
  .io_pads_gpioA_o_oval       (io_pads_gpioA_o_oval),
  .io_pads_gpioA_o_oe         (io_pads_gpioA_o_oe), 

  //.io_pads_gpioB_i_ival       (io_pads_gpioB_i_ival),
  //.io_pads_gpioB_o_oval       (io_pads_gpioB_o_oval),
  //.io_pads_gpioB_o_oe         (io_pads_gpioB_o_oe), 

  .io_pads_qspi0_sck_i_ival   (1'b1),
  .io_pads_qspi0_sck_o_oval   (io_pads_qspi0_sck_o_oval),
  .io_pads_qspi0_sck_o_oe     (),
  .io_pads_qspi0_dq_0_i_ival  (io_pads_qspi0_dq_0_i_ival),
  .io_pads_qspi0_dq_0_o_oval  (io_pads_qspi0_dq_0_o_oval),
  .io_pads_qspi0_dq_0_o_oe    (io_pads_qspi0_dq_0_o_oe),
  .io_pads_qspi0_dq_1_i_ival  (io_pads_qspi0_dq_1_i_ival),
  .io_pads_qspi0_dq_1_o_oval  (io_pads_qspi0_dq_1_o_oval),
  .io_pads_qspi0_dq_1_o_oe    (io_pads_qspi0_dq_1_o_oe),
  .io_pads_qspi0_dq_2_i_ival  (io_pads_qspi0_dq_2_i_ival),
  .io_pads_qspi0_dq_2_o_oval  (io_pads_qspi0_dq_2_o_oval),
  .io_pads_qspi0_dq_2_o_oe    (io_pads_qspi0_dq_2_o_oe),
  .io_pads_qspi0_dq_3_i_ival  (io_pads_qspi0_dq_3_i_ival),
  .io_pads_qspi0_dq_3_o_oval  (io_pads_qspi0_dq_3_o_oval),
  .io_pads_qspi0_dq_3_o_oe    (io_pads_qspi0_dq_3_o_oe),
  .io_pads_qspi0_cs_0_i_ival  (1'b1),
  .io_pads_qspi0_cs_0_o_oval  (io_pads_qspi0_cs_0_o_oval),
  .io_pads_qspi0_cs_0_o_oe    (), 

    .hfextclk        (hfextclk),
    .hfxoscen        (hfxoscen),
    .lfextclk        (lfextclk),
    .lfxoscen        (lfxoscen),

  .io_pads_aon_erst_n_i_ival        (io_pads_aon_erst_n_i_ival       ), 
  .io_pads_aon_erst_n_o_oval        (),
  .io_pads_aon_erst_n_o_oe          (),
  .io_pads_aon_erst_n_o_ie          (),
  .io_pads_aon_erst_n_o_pue         (),
  .io_pads_aon_erst_n_o_ds          (),
  .io_pads_aon_pmu_dwakeup_n_i_ival (io_pads_aon_pmu_dwakeup_n_i_ival),
  .io_pads_aon_pmu_dwakeup_n_o_oval (),
  .io_pads_aon_pmu_dwakeup_n_o_oe   (),
  .io_pads_aon_pmu_dwakeup_n_o_ie   (),
  .io_pads_aon_pmu_dwakeup_n_o_pue  (),
  .io_pads_aon_pmu_dwakeup_n_o_ds   (),
  .io_pads_aon_pmu_vddpaden_i_ival  (1'b1 ),
  .io_pads_aon_pmu_vddpaden_o_oval  (io_pads_aon_pmu_vddpaden_o_oval ),
  .io_pads_aon_pmu_vddpaden_o_oe    (),
  .io_pads_aon_pmu_vddpaden_o_ie    (),
  .io_pads_aon_pmu_vddpaden_o_pue   (),
  .io_pads_aon_pmu_vddpaden_o_ds    (),

  
    .io_pads_aon_pmu_padrst_i_ival    (1'b1 ),
    .io_pads_aon_pmu_padrst_o_oval    (io_pads_aon_pmu_padrst_o_oval ),
    .io_pads_aon_pmu_padrst_o_oe      (),
    .io_pads_aon_pmu_padrst_o_ie      (),
    .io_pads_aon_pmu_padrst_o_pue     (),
    .io_pads_aon_pmu_padrst_o_ds      (),

    .io_pads_bootrom_n_i_ival       (io_pads_bootrom_n_i_ival),
    .io_pads_bootrom_n_o_oval       (),
    .io_pads_bootrom_n_o_oe         (),
    .io_pads_bootrom_n_o_ie         (),
    .io_pads_bootrom_n_o_pue        (),
    .io_pads_bootrom_n_o_ds         (),

    .io_pads_dbgmode0_n_i_ival       (io_pads_dbgmode0_n_i_ival),

    .io_pads_dbgmode1_n_i_ival       (io_pads_dbgmode1_n_i_ival),

    .io_pads_dbgmode2_n_i_ival       (io_pads_dbgmode2_n_i_ival) 


  );


endmodule
