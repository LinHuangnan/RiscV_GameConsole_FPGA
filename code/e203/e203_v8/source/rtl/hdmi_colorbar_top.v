//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���?
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           hdmi_colorbar_top
// Last modified Date:  2019/7/1 9:30:00
// Last Version:        V1.1
// Descriptions:        HDMI������ʾʵ�鶥��ģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/7/1 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module  hdmi_colorbar_top(
    input        sys_clk,
    input        sys_rst_n,
    
    output       tmds_clk_p,    // TMDS ʱ��ͨ��
    output       tmds_clk_n,
    output [2:0] tmds_data_p,   // TMDS ����ͨ��
    output [2:0] tmds_data_n,

    output      lcd_driver_en,
    output      video_vs,
    output      video_de,
    input       almost_empty,
    output      pixel_clk,

    output		audio_clk,
    input	[7:0] audio_word,

    output      data_req,
    input  [24-1:0]   pix_data
);


wire          pixel_clk_5x;
wire          clk_locked;
wire            clk_24M;
wire [15:0]  audio_sample_word[1:0];

assign audio_sample_word[0] = {4'b0,audio_word,4'b0};
assign audio_sample_word[1] = {4'b0,audio_word,4'b0};


pll_hdmi  u_pll_clk(
	.pll_rst        (~sys_rst_n),
	.clkin1         (sys_clk),
	.clkout0        (pixel_clk),      
	.clkout1        (pixel_clk_5x),
    .clkout2        (clk_24M),
	.pll_lock       (clk_locked)
);

divider #(
    .cfactor(500)
)
audio_clk_divider(
    .clk_in(clk_24M),
    .resetn(sys_rst_n),
    .clk_out(audio_clk)
);


video_driver u_video_driver(
    .pixel_clk      (pixel_clk),
    .pixel_clk_5x   (pixel_clk_5x),
    .clk_audio      (audio_clk),
    .sys_rst_n      (sys_rst_n),
    .audio_sample_word(audio_sample_word),

    .video_hs       (),
    .video_vs       (video_vs),
    .video_de       (video_de),
    .video_rgb      (),

    .tmds_clk_p     (tmds_clk_p),
    .tmds_clk_n     (tmds_clk_n),
    .tmds_data_p    (tmds_data_p),
    .tmds_data_n    (tmds_data_n),

    .lcd_driver_en(lcd_driver_en),
    .almost_empty(almost_empty),
    .data_req       (data_req),
    .pixel_data     (pix_data)
    );


/*
dvi_transmitter_top u_rgb2dvi_0(
    .pclk           (pixel_clk),
    .pclk_x5        (pixel_clk_5x),
    .reset_n        (sys_rst_n & clk_locked),
                
    .video_din      (video_rgb),
    .video_hsync    (video_hs), 
    .video_vsync    (video_vs),
    .video_de       (video_de),
                
    .tmds_clk_p     (tmds_clk_p),
    .tmds_clk_n     (tmds_clk_n),
    .tmds_data_p    (tmds_data_p),
    .tmds_data_n    (tmds_data_n)
    );
*/
endmodule 