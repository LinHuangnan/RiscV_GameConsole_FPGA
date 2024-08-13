//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           ddr3_rw_top
// Last modified Date:  2020/05/04 9:19:08
// Last Version:        V1.0
// Descriptions:        ddr3��д���Զ���ģ��
//                      
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/05/04 9:19:08
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ddr3_hdmi_top(
    input             sys_clk          , //ϵͳʱ��50M
    input             sys_rst_n        , //ϵͳ��λ
    output            ddr_init_done, //ddr3��ʼ�����led��

    //DDR3�ӿ�
    input             pad_loop_in      , //��λ�¶Ȳ�������
    input             pad_loop_in_h    , //��λ�¶Ȳ�������
    output            pad_rstn_ch0     , //Memory��λ
    output            pad_ddr_clk_w    , //Memory���ʱ������
    output            pad_ddr_clkn_w   , //Memory���ʱ�Ӹ���
    output            pad_csn_ch0      , //MemoryƬѡ
    output [15:0]     pad_addr_ch0     , //Memory��ַ����
    inout  [16-1:0]   pad_dq_ch0       , //��������
    inout  [16/8-1:0] pad_dqs_ch0      , //����ʱ������
    inout  [16/8-1:0] pad_dqsn_ch0     , //����ʱ�Ӹ���
    output [16/8-1:0] pad_dm_rdqs_ch0  , //����Mask
    output            pad_cke_ch0      , //Memory���ʱ��ʹ��
    output            pad_odt_ch0      , //On Die Termination
    output            pad_rasn_ch0     , //�е�ַstrobe
    output            pad_casn_ch0     , //�е�ַstrobe
    output            pad_wen_ch0      , //дʹ��
    output [2:0]      pad_ba_ch0       , //Bank��ַ����
    output            pad_loop_out     , //��λ�¶Ȳ������
    output            pad_loop_out_h   ,  //��λ�¶Ȳ������    

    output       tmds_clk_p,    // TMDS ʱ��ͨ��
    output       tmds_clk_n,
    output [2:0] tmds_data_p,   // TMDS ����ͨ��
    output [2:0] tmds_data_n
   );

wire [127:0]    axi_rdata;
wire            axi_rlast;
wire            axi_rready;
wire            axi_rvalid;
wire            axi_clk_75M;
wire            dispaly_en;
//wire            frame_fifo_wr_en;

wire    wr_full;
wire    almost_full;
wire    [8:0] wr_water_level;
wire    wr_en;

wire    rd_empty;
wire    almost_empty;
wire    [11:0]  rd_water_level;

wire            pix_clk_75M;
wire    [24-1:0]    pix_data;
wire                frame_rst;
wire                data_req;
wire    [16-1:0]    frame_rdata;



////*****************************************************
////**                    main code
////***************************************************** 
//ddr3����������ģ��
ddr3_top u_ddr3_top(
    .refclk_in             (sys_clk         ),
    .rst_n                 (sys_rst_n       ),
    .ddr_init_done         (ddr_init_done   ),
    //DDR3�ӿ�
    .pad_loop_in           (pad_loop_in     ),
    .pad_loop_in_h         (pad_loop_in_h   ),
    .pad_rstn_ch0          (pad_rstn_ch0    ),
    .pad_ddr_clk_w         (pad_ddr_clk_w   ),
    .pad_ddr_clkn_w        (pad_ddr_clkn_w  ),
    .pad_csn_ch0           (pad_csn_ch0     ),
    .pad_addr_ch0          (pad_addr_ch0    ),
    .pad_dq_ch0            (pad_dq_ch0      ),
    .pad_dqs_ch0           (pad_dqs_ch0     ),
    .pad_dqsn_ch0          (pad_dqsn_ch0    ),
    .pad_dm_rdqs_ch0       (pad_dm_rdqs_ch0 ),
    .pad_cke_ch0           (pad_cke_ch0     ),
    .pad_odt_ch0           (pad_odt_ch0     ),
    .pad_rasn_ch0          (pad_rasn_ch0    ),
    .pad_casn_ch0          (pad_casn_ch0    ),
    .pad_wen_ch0           (pad_wen_ch0     ),
    .pad_ba_ch0            (pad_ba_ch0      ),
    .pad_loop_out          (pad_loop_out    ),
    .pad_loop_out_h        (pad_loop_out_h  ),


    .dispaly_en(dispaly_en),
    .almost_full(almost_full),
    //.frame_fifo_wr_en(frame_fifo_wr_en),
    .axi_clk_75M(axi_clk_75M),
    .axi_rdata(axi_rdata)      ,
    .axi_rlast(axi_rlast)      ,
    .axi_rvalid(axi_rvalid)     ,
    .axi_rready(axi_rready)          
 );  







assign  wr_en = axi_rvalid & axi_rready;
assign  pix_data = {frame_rdata[15:11],3'b0,frame_rdata[10:5],2'b0,frame_rdata[4:0],3'b0};

hdmi_colorbar_top u_hdmi_colorbar_top(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    
    .tmds_clk_p(tmds_clk_p),    // TMDS ʱ��ͨ��
    .tmds_clk_n(tmds_clk_n),
    .tmds_data_p(tmds_data_p),   // TMDS ����ͨ��
    .tmds_data_n(tmds_data_n),

    //.frame_fifo_wr_en(frame_fifo_wr_en),
    .dispaly_en(dispaly_en),
    .pixel_clk(pix_clk_75M),
    .frame_rst(frame_rst),
    .data_req(data_req),
    .pix_data(pix_data)

);


frame_fifo u_frame_fifo (
  .wr_clk(axi_clk_75M),                // input
  .wr_rst((~sys_rst_n)),                // input
  .wr_en(wr_en),                  // input
  .wr_data(axi_rdata),              // input [127:0]
  .wr_full(wr_full),              // output
  .almost_full(almost_full),      // output
  .wr_water_level(wr_water_level),    // output [8:0]

  .rd_clk(pix_clk_75M),                // input
  .rd_rst((~sys_rst_n)),                // input
  .rd_en(data_req),                  // input
  .rd_data(frame_rdata),              // output [15:0]
  .rd_empty(rd_empty),            // output
  .rd_water_level(rd_water_level),    // output [11:0]
  .almost_empty(almost_empty)     // output
);









endmodule