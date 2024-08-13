`include "e203_defines.v"



module system
(
  //output almost_empty,
  //output [31:0]     expl_axi_rdata,

  input wire CLK50MHZ,//GCLK-W19

  input wire fpga_rst_n,//FPGA_RESET  active low

  //input wire key0,
  //input wire key1,
  input wire key2,
  input wire key3,

  input wire rcv_in,    //红外接收信号


  // Dedicated QSPI interface
  output wire qspi0_cs,
  output wire qspi0_sck,
  inout wire [3:0] qspi0_dq,

  // JD (used for JTAG connection)
  /*
  inout wire mcu_TDO,//MCU_TDO-N17
  inout wire mcu_TCK,//MCU_TCK-P15 
  inout wire mcu_TDI,//MCU_TDI-T18
  inout wire mcu_TMS,//MCU_TMS-P17
  */

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


  //hdmi interface
  output       tmds_clk_p,    // TMDS 时钟通道
  output       tmds_clk_n,
  output [2:0] tmds_data_p,   // TMDS 数据通道
  output [2:0] tmds_data_n,

  output           sd_ncs,      //chip select
  output           sd_dclk,     //sd card clock
  output           sd_mosi,     //sd card CMD
  input            sd_miso,     //sd card  data

  //以太网接口
  input              eth_rxc     , //RGMII接收数据时钟
  input              eth_rx_ctl  , //RGMII输入数据有效信号
  input       [3:0]  eth_rxd     , //RGMII输入数据
  output             eth_txc     , //RGMII发送数据时钟    
  output             eth_tx_ctl  , //RGMII输出数据有效信号
  output      [3:0]  eth_txd     , //RGMII输出数据          
  output             eth_rst_n   , //以太网芯片复位信号，低电平有效 

  //LCD interface
  output               lcd_de,      //LCD ����ʹ���ź�
  output               lcd_hs,      //LCD ��ͬ���ź�
  output               lcd_vs,      //LCD ��ͬ���ź�
  output               lcd_bl,      //LCD ��������ź�
  output               lcd_clk,     //LCD ����ʱ��
  output       reg     lcd_rst,     //LCD ��λ
  output        [23:0] lcd_rgb,      //LCD RGB888��ɫ����

  //ps2 spi interface
	output         ps2_spi_cs        ,//SPI从机的片选信号，低电平有效。
	output         ps2_spi_clk       ,//主从机之间的数据同步时钟。
	output         ps2_spi_mosi      ,//数据引脚，主机输出，从机输入。
	input          ps2_spi_miso      , //数据引脚，主机输入，从机输出。


  //
  output  [3:0] led,

  //gpioA
  inout wire [23:16] gpioA//GPIOA00~GPIOA31
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



  //clk
  wire clk_8388;
  wire cpu_clk;
  wire CLK32768HZ;

  //gpioA
  wire [32-1:0] dut_io_pads_gpioA_i_ival;
  wire [32-1:0] dut_io_pads_gpioA_o_oval;
  wire [32-1:0] dut_io_pads_gpioA_o_oe;
  
  //qspi
  wire dut_io_pads_qspi0_sck_o_oval;
  wire dut_io_pads_qspi0_cs_0_o_oval;
  wire dut_io_pads_qspi0_dq_0_i_ival;
  wire dut_io_pads_qspi0_dq_0_o_oval;
  wire dut_io_pads_qspi0_dq_0_o_oe;
  wire dut_io_pads_qspi0_dq_1_i_ival;
  wire dut_io_pads_qspi0_dq_1_o_oval;
  wire dut_io_pads_qspi0_dq_1_o_oe;
  wire dut_io_pads_qspi0_dq_2_i_ival;
  wire dut_io_pads_qspi0_dq_2_o_oval;
  wire dut_io_pads_qspi0_dq_2_o_oe;
  wire dut_io_pads_qspi0_dq_3_i_ival;
  wire dut_io_pads_qspi0_dq_3_o_oval;
  wire dut_io_pads_qspi0_dq_3_o_oe;


  //key
  //wire key0_neg;
  //wire key1_neg;
  wire key2_neg;
  wire key3_neg;

  //remote infrared
  wire rcv_data_en;
  wire [7:0] rcv_data;
  wire  repeat_en;

  //
  wire  [15:0]  ps2_key; 
  //jtag
  //wire jtag_TDI;
  //wire jtag_TDO;
  //wire jtag_TCK;
  //wire jtag_TMS;


  //key debounce
  ax_debounce  
  #(
      .FREQ(8)
  )
  u_key2
  (
    .clk(clk_8388), 
    .rst(~fpga_rst_n), 
    .button_in(key2),
    .button_posedge(),
    .button_negedge(key2_neg),
    .button_out()
  );

  
  ax_debounce 
  #(
      .FREQ(8)
  )
  u_key3
  (
    .clk(clk_8388), 
    .rst(~fpga_rst_n), 
    .button_in(key3),
    .button_posedge(),
    .button_negedge(key3_neg),
    .button_out()
  );
  

  //remote infrared top module
  rcv_top u_rc(

    .sys_clk(CLK50MHZ),
    .sys_rst_n(fpga_rst_n),
    
    //.transfer_flag(transfer_flag),
    .remote_in(rcv_in),
    //.repeat_en(repeat_en),
    .data_en(rcv_data_en), 
    .data(rcv_data)
  );







  assign  cpu_clk = CLK50MHZ;
  assign  lcd_clk = CLK50MHZ;

  pll_clk ip_mmcm (
  .pll_rst(~fpga_rst_n),      // input active high
  .clkin1(CLK50MHZ),        // input
  //.pll_lock(mmcm_locked),    // output
  //.clkout0(cpu_clk),      // output 50M
  .clkout1(clk_8388)       // output  8.388M
  );

  divider #(
    .cfactor(256)
  )
  clkDivder(
    .clk_in(clk_8388),
    .resetn(fpga_rst_n),
    .clk_out(CLK32768HZ)
  );


  //=================================================
  // IOBUF instantiation for GPIOs

  GTP_IOBUF#(
  .IOSTANDARD ("DEFAULT"),
  .SLEW_RATE ("SLOW"),
  .DRIVE_STRENGTH ("12"),
  .TERM_DDR("ON")
  )
  gpioA_iobuf[23:16] (
  .I (dut_io_pads_gpioA_o_oval[23:16]),
  .T (~dut_io_pads_gpioA_o_oe[23:16]),
  .IO (gpioA[23:16]),
  .O (dut_io_pads_gpioA_i_ival[23:16]) 
  );




  assign dut_io_pads_gpioA_i_ival[0]=(rcv_data_en && rcv_data==`RCV_VOL_P);
  assign dut_io_pads_gpioA_i_ival[1]=(rcv_data_en && rcv_data==`RCV_VOL_N);
  assign dut_io_pads_gpioA_i_ival[2]=(rcv_data_en && rcv_data==`RCV_PLAY);
  assign dut_io_pads_gpioA_i_ival[3]=(rcv_data_en && rcv_data==`RCV_BACK);
  assign dut_io_pads_gpioA_i_ival[4] = (rcv_data_en && rcv_data==`RCV_UP);
  assign dut_io_pads_gpioA_i_ival[5] = (rcv_data_en && rcv_data==`RCV_DOWN);
  assign dut_io_pads_gpioA_i_ival[6] = (rcv_data_en && rcv_data==`RCV_LEFT);
  assign dut_io_pads_gpioA_i_ival[7] = (rcv_data_en && rcv_data==`RCV_RIGHT);



  assign dut_io_pads_gpioA_i_ival[15:8]=ps2_key[7:0];
  assign dut_io_pads_gpioA_i_ival[31:24]=ps2_key[15:8];









  //=================================================
  // SPI0 Interface

  wire [3:0] qspi0_ui_dq_o; 
  wire [3:0] qspi0_ui_dq_oe;
  wire [3:0] qspi0_ui_dq_i;


  GTP_IOBUF  qspi0_iobuf[3:0] (
  .IO (qspi0_dq),
  .O (qspi0_ui_dq_i),
  .I (qspi0_ui_dq_o),
  .T (~qspi0_ui_dq_oe)
  );

  assign qspi0_sck = dut_io_pads_qspi0_sck_o_oval;
  assign qspi0_cs  = dut_io_pads_qspi0_cs_0_o_oval;
  assign qspi0_ui_dq_o = {
    dut_io_pads_qspi0_dq_3_o_oval,
    dut_io_pads_qspi0_dq_2_o_oval,
    dut_io_pads_qspi0_dq_1_o_oval,
    dut_io_pads_qspi0_dq_0_o_oval
  };
  assign qspi0_ui_dq_oe = {
    dut_io_pads_qspi0_dq_3_o_oe,
    dut_io_pads_qspi0_dq_2_o_oe,
    dut_io_pads_qspi0_dq_1_o_oe,
    dut_io_pads_qspi0_dq_0_o_oe
  };
  assign dut_io_pads_qspi0_dq_0_i_ival = qspi0_ui_dq_i[0];
  assign dut_io_pads_qspi0_dq_1_i_ival = qspi0_ui_dq_i[1];
  assign dut_io_pads_qspi0_dq_2_i_ival = qspi0_ui_dq_i[2];
  assign dut_io_pads_qspi0_dq_3_i_ival = qspi0_ui_dq_i[3];



  //=================================================
  // JTAG IOBUFs

  /*
  wire dut_io_pads_jtag_TCK_i_ival;
  wire dut_io_pads_jtag_TMS_i_ival;
  wire dut_io_pads_jtag_TMS_o_oval;
  wire dut_io_pads_jtag_TMS_o_oe;
  wire dut_io_pads_jtag_TMS_o_ie;
  wire dut_io_pads_jtag_TMS_o_pue;
  wire dut_io_pads_jtag_TMS_o_ds;
  wire dut_io_pads_jtag_TDI_i_ival;
  wire dut_io_pads_jtag_TDO_o_oval;
  wire dut_io_pads_jtag_TDO_o_oe;

  
  wire iobuf_jtag_TCK_o;
  GTP_IOBUF#(
  .IOSTANDARD ("DEFAULT"),
  .SLEW_RATE ("SLOW"),
  .DRIVE_STRENGTH ("12"),
  .TERM_DDR("ON")
  )
  IOBUF_jtag_TCK (
  .I (1'b0),
  .T (1'b1),
  .IO (mcu_TCK),
  .O (iobuf_jtag_TCK_o) 
  );

  assign dut_io_pads_jtag_TCK_i_ival = iobuf_jtag_TCK_o ;
  
  wire iobuf_jtag_TMS_o;
  GTP_IOBUF#(
  .IOSTANDARD ("DEFAULT"),
  .SLEW_RATE ("SLOW"),
  .DRIVE_STRENGTH ("12"),
  .TERM_DDR("ON")
  )
  IOBUF_jtag_TMS (
  .I (1'b0),
  .T (1'b1),
  .IO (mcu_TMS),
  .O (iobuf_jtag_TMS_o) 
  );

  assign dut_io_pads_jtag_TMS_i_ival = iobuf_jtag_TMS_o;

  
  wire iobuf_jtag_TDI_o;
  GTP_IOBUF#(
  .IOSTANDARD ("DEFAULT"),
  .SLEW_RATE ("SLOW"),
  .DRIVE_STRENGTH ("12"),
  .TERM_DDR("ON")
  )
  IOBUF_jtag_TDI (
  .I (1'b0),
  .T (1'b1),
  .IO (mcu_TDI),
  .O (iobuf_jtag_TDI_o) 
  );

  assign dut_io_pads_jtag_TDI_i_ival = iobuf_jtag_TDI_o;

  
  wire iobuf_jtag_TDO_o;
  GTP_IOBUF#(
  .IOSTANDARD ("DEFAULT"),
  .SLEW_RATE ("SLOW"),
  .DRIVE_STRENGTH ("12"),
  .TERM_DDR("ON")
  )
  IOBUF_jtag_TDO (
  .I (dut_io_pads_jtag_TDO_o_oval),
  .T (~dut_io_pads_jtag_TDO_o_oe),
  .IO (mcu_TDO),
  .O (iobuf_jtag_TDO_o) 
  );
  */
  
  wire                         sysmem_icb_cmd_valid;
  wire                         sysmem_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   sysmem_icb_cmd_addr;
  wire                         sysmem_icb_cmd_read;
  wire [`E203_XLEN-1:0]        sysmem_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      sysmem_icb_cmd_wmask;

  wire                          sysmem_icb_rsp_valid;
  wire                          sysmem_icb_rsp_ready;
  wire                          sysmem_icb_rsp_err;
  wire  [`E203_XLEN-1:0]        sysmem_icb_rsp_rdata;

  wire    main_rst_n;

  e203_soc_top dut
  (
    //.almost_empty(almost_empty),
    //.expl_axi_rdata(expl_axi_rdata),

    //.CLK50MHZ(CLK50MHZ),//GCLK-W19
    .hfextclk(cpu_clk),
    .hfxoscen(),

    .lfextclk(CLK32768HZ), 
    .lfxoscen(),

    .main_rst_n(main_rst_n),  //output

    // Note: this is the real SoC top AON domain slow clock
    //.io_pads_jtag_TCK_i_ival(jtag_TCK),
    //.io_pads_jtag_TMS_i_ival(jtag_TMS),
    //.io_pads_jtag_TDI_i_ival(jtag_TDI),
    //.io_pads_jtag_TDO_o_oval(jtag_TDO),
    //.io_pads_jtag_TDO_o_oe  (),

    .io_pads_gpioA_i_ival(dut_io_pads_gpioA_i_ival),
    .io_pads_gpioA_o_oval(dut_io_pads_gpioA_o_oval),
    .io_pads_gpioA_o_oe  (dut_io_pads_gpioA_o_oe),

    //.io_pads_gpioB_i_ival(),
    //.io_pads_gpioB_o_oval(),
    //.io_pads_gpioB_o_oe  (),

    .io_pads_qspi0_sck_o_oval (dut_io_pads_qspi0_sck_o_oval),
    .io_pads_qspi0_cs_0_o_oval(dut_io_pads_qspi0_cs_0_o_oval),

    .io_pads_qspi0_dq_0_i_ival(dut_io_pads_qspi0_dq_0_i_ival),
    .io_pads_qspi0_dq_0_o_oval(dut_io_pads_qspi0_dq_0_o_oval),
    .io_pads_qspi0_dq_0_o_oe  (dut_io_pads_qspi0_dq_0_o_oe),
    .io_pads_qspi0_dq_1_i_ival(dut_io_pads_qspi0_dq_1_i_ival),
    .io_pads_qspi0_dq_1_o_oval(dut_io_pads_qspi0_dq_1_o_oval),
    .io_pads_qspi0_dq_1_o_oe  (dut_io_pads_qspi0_dq_1_o_oe),
    .io_pads_qspi0_dq_2_i_ival(dut_io_pads_qspi0_dq_2_i_ival),
    .io_pads_qspi0_dq_2_o_oval(dut_io_pads_qspi0_dq_2_o_oval),
    .io_pads_qspi0_dq_2_o_oe  (dut_io_pads_qspi0_dq_2_o_oe),
    .io_pads_qspi0_dq_3_i_ival(dut_io_pads_qspi0_dq_3_i_ival),
    .io_pads_qspi0_dq_3_o_oval(dut_io_pads_qspi0_dq_3_o_oval),
    .io_pads_qspi0_dq_3_o_oe  (dut_io_pads_qspi0_dq_3_o_oe),


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
    //.ddr_init_done(ddr_init_done),      // output
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

    .eth_rxc         (eth_rxc   ),           //RGMII接收数据时钟
    .eth_rx_ctl      (eth_rx_ctl),           //RGMII输入数据有效信号
    .eth_rxd         (eth_rxd   ),           //RGMII输入数据
    .eth_txc         (eth_txc   ),           //RGMII发送数据时钟    
    .eth_tx_ctl      (eth_tx_ctl),           //RGMII输出数据有效信号
    .eth_txd         (eth_txd   ),           //RGMII输出数据          
    .eth_rst_n       (eth_rst_n ),           //以太网芯片复位信号，低电平有效 
    .transfer_flag(transfer_flag),
    */

    // Note: this is the real SoC top level reset signal
    .io_pads_aon_erst_n_i_ival(fpga_rst_n),     //acvtive low
    .io_pads_aon_pmu_dwakeup_n_i_ival(),
    .io_pads_aon_pmu_vddpaden_o_oval(),
    .io_pads_aon_pmu_padrst_o_oval    ( ),


    .io_pads_bootrom_n_i_ival       (1'b1),
    .io_pads_dbgmode0_n_i_ival       (1'b1),
    .io_pads_dbgmode1_n_i_ival       (1'b1),
    .io_pads_dbgmode2_n_i_ival       (1'b1) 
  );



  /////////////////////////////////////////////////////////
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
  .AXI_FIFO_DP (0), 
  .AXI_FIFO_CUT_READY (1),
  .AW   (32),
  .FIFO_OUTS_NUM (4),
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

    .clk           (cpu_clk  ),
    .rst_n         (main_rst_n) 
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


  //wire for ethernet
  wire            eth_tx_clk      ;   //以太网发送时钟
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
  reg  transfer_flag;

  //
  wire    almost_empty;
  wire    almost_full;
  wire    wr_en;

  wire                pix_clk_75M;
  wire    [24-1:0]    pix_data;
  wire                data_req;
  wire    [16-1:0]    frame_rdata;

  wire          video_vs;
  wire          video_de;

  wire          ddr_init_done;


//hdmi读ddr3控制器模块
rw_ctrl_128bit  u_rw_ctrl_128bit
(
 .clk                 (axi_clk_75M), 
 .rst_n               (main_rst_n        ),
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
    .top_rst_n(main_rst_n),                // input
    .ddrc_rst(~main_rst_n),                  // input
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
    .areset_0(~main_rst_n),                  // input
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
    .aclk_1(cpu_clk),                      // input

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

  //图像封装模块     
  img_data_pkt u_img_data_pkt(    
    .rst_n              (main_rst_n),              

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
    .sys_rst_n       (main_rst_n     ),           //系统复位信号，低电平有效           
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

  

  wire [23:0] lcd_data;
  wire [15:0] lcd_fifo_rd_data;
  wire      lcd_data_req;
  wire      lcd_driver_en;
  wire      audio_clk;
  wire  [7:0] sd_fifo_read_data;



  assign  wr_en = hdmi_axi_rvalid & hdmi_axi_rready;
  assign  pix_data = {frame_rdata[15:11],3'b0,frame_rdata[10:5],2'b0,frame_rdata[4:0],3'b0};
  assign  lcd_data = {lcd_fifo_rd_data[15:11],3'b0,lcd_fifo_rd_data[10:5],2'b0,lcd_fifo_rd_data[4:0],3'b0};

  hdmi_colorbar_top u_hdmi_colorbar_top(
      .sys_clk(CLK50MHZ),
      .sys_rst_n(main_rst_n),
      
      .tmds_clk_p(tmds_clk_p),    // TMDS 时钟通道
      .tmds_clk_n(tmds_clk_n),
      .tmds_data_p(tmds_data_p),   // TMDS 数据通道
      .tmds_data_n(tmds_data_n),

      .lcd_driver_en(lcd_driver_en),
      .video_vs       (video_vs),
      .video_de       (video_de),
      .almost_empty(almost_empty),
      .pixel_clk(pix_clk_75M),
      .audio_clk(audio_clk),
      .audio_word(sd_fifo_read_data),
      .data_req(data_req),
      .pix_data(pix_data)

  );

wire sysmem_icb_cmd_valid_r;
sirv_gnrl_dfflrs #(.DW(1)) sysmem_icb_cmd_valid_dfflrs(1'b1,sysmem_icb_cmd_valid,sysmem_icb_cmd_valid_r,CLK50MHZ,main_rst_n);

wire sysmem_icb_cmd_read_r;
sirv_gnrl_dfflrs #(.DW(1)) sysmem_icb_cmd_read_dfflrs(1'b1,sysmem_icb_cmd_read,sysmem_icb_cmd_read_r,CLK50MHZ,main_rst_n);

wire [31:0] sysmem_icb_cmd_addr_r;
sirv_gnrl_dfflrs #(.DW(32)) sysmem_icb_cmd_addr_dfflrs(1'b1,sysmem_icb_cmd_addr,sysmem_icb_cmd_addr_r,CLK50MHZ,main_rst_n);

wire [31:0] sysmem_icb_cmd_wdata_r;
sirv_gnrl_dfflrs #(.DW(32)) sysmem_icb_cmd_wdata_dfflrs(1'b1,sysmem_icb_cmd_wdata,sysmem_icb_cmd_wdata_r,CLK50MHZ,main_rst_n);


sd_card_user_top u_sd_card_user_top(

    .clk(CLK50MHZ),
	  .rst_n(main_rst_n),
    .audio_clk(audio_clk),   

    .sd_ncs(sd_ncs),      //chip select
    .sd_dclk(sd_dclk),     //sd card clock
    .sd_mosi(sd_mosi),     //sd card CMD
    .sd_miso(sd_miso),     //sd card  data

    .sd_icb_cmd_valid (sysmem_icb_cmd_valid_r),
    .sd_icb_cmd_addr  (sysmem_icb_cmd_addr_r ),
    .sd_icb_cmd_read  (sysmem_icb_cmd_read_r ),
    .sd_icb_cmd_wdata (sysmem_icb_cmd_wdata_r),

    .sd_fifo_read_data(sd_fifo_read_data)
);


  frame_fifo u_frame_fifo (
    .wr_clk(axi_clk_75M),                // input
    .wr_rst((~main_rst_n)),                // input
    .wr_en(wr_en),                  // input
    .wr_data(hdmi_axi_rdata),              // input [127:0]
    .almost_full(almost_full),      // output

    .rd_clk(pix_clk_75M),                // input
    .rd_rst((~main_rst_n)),                // input
    .rd_en(data_req),                  // input
    .almost_empty(almost_empty),     // output
    .rd_data(frame_rdata)              // output [15:0]
  );



wire lcd_fifo_almost_full;
lcd_fifo u_lcd_fifo (
  .wr_clk(pix_clk_75M),                // input
  .wr_rst((~main_rst_n)|(~video_vs)),                // input
  .wr_en(video_de),                  // input
  .wr_data(frame_rdata),              // input [15:0]
  .wr_full(),              // output
  .almost_full(lcd_fifo_almost_full),      // output
  .rd_clk(CLK50MHZ),                // input
  .rd_rst((~main_rst_n)|(~video_vs)),                // input
  .rd_en(lcd_data_req),                  // input
  .rd_data(lcd_fifo_rd_data),              // output [15:0]
  .rd_empty(),            // output
  .almost_empty()     // output
);


always @(posedge clk_8388 or negedge fpga_rst_n) begin
  if(~fpga_rst_n) begin
    lcd_rst<=1'b0;
    transfer_flag <=1'b0;
  end else if(key2_neg) begin
    lcd_rst <= ~lcd_rst;
  end else if(key3_neg )begin
    transfer_flag <=~transfer_flag;
  end

end





lcd_driver u_lcd_driver(
    .lcd_pclk      (CLK50MHZ  ),
    .rst_n         (main_rst_n ),
    .almost_full(lcd_fifo_almost_full),
    .pixel_data    (lcd_data),
    .lcd_driver_en(lcd_driver_en),
    .data_req       (lcd_data_req),
    .lcd_de        (lcd_de    ),
    .lcd_hs        (lcd_hs    ),
    .lcd_vs        (lcd_vs    ),
    .lcd_bl        (lcd_bl    ),
    //.lcd_rst       (),
    .lcd_rgb       (lcd_rgb )
  );



  
ps2_top u_ps2_top(
  .clk(CLK50MHZ),
  .rst_n(fpga_rst_n),


  //spi interface
	.spi_cs(ps2_spi_cs)        ,//SPI从机的片选信号，低电平有效。
	.spi_clk(ps2_spi_clk)       ,//主从机之间的数据同步时钟。
	.spi_mosi(ps2_spi_mosi)      ,//数据引脚，主机输出，从机输入。
	.spi_miso(ps2_spi_miso)      , //数据引脚，主机输入，从机输出。

  .led(led),
  .ps2_key(ps2_key)


);



endmodule


