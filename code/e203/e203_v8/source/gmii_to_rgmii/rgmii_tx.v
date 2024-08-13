//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           rgmii_tx
// Last modified Date:  2020/2/13 9:20:14
// Last Version:        V1.0
// Descriptions:        RGMII发送模块
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2020/2/13 9:20:14
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module rgmii_tx(
    input              reset,
    //GMII发送端口
    input              gmii_tx_er     ,
    input              gmii_tx_clk    , //GMII发送时钟    
    input              gmii_tx_en     , //GMII输出数据有效信号
    input       [7:0]  gmii_txd       , //GMII输出数据    
    input              gmii_tx_clk_deg,//GMII发送时钟相位偏移45度
    //RGMII发送端口
    output             rgmii_txc      , //RGMII发送数据时钟    
    output             rgmii_tx_ctl   , //RGMII输出数据有效信号
    output      [3:0]  rgmii_txd        //RGMII输出数据
    );
// registers
reg             tx_reset_d1    ;
reg             tx_reset_sync  ;
reg             rx_reset_d1    ;

reg   [ 7:0]    gmii_txd_r     ;
reg   [ 7:0]    gmii_txd_r_d1  ;

reg             gmii_tx_en_r   ;
reg             gmii_tx_en_r_d1;

reg             gmii_tx_er_r   ;

reg             rgmii_tx_ctl_r ;
reg   [ 3:0]    gmii_txd_low   ;

// wire
wire            padt1   ;
wire            padt2   ;
wire            padt3   ;
wire            padt4   ;
wire            padt5   ;
wire            padt6   ;
wire            stx_txc ;
wire            stx_ctr ;
wire  [3:0]     stxd_rgm;
//*****************************************************
//**                    main code
//*****************************************************
always @(posedge gmii_tx_clk) begin
    tx_reset_d1   <= reset;
    tx_reset_sync <= tx_reset_d1;
end

always @(posedge gmii_tx_clk) begin
    if (tx_reset_sync == 1'b1) begin
        gmii_txd_r   <= 8'h0;
        gmii_tx_en_r <= 1'b0;
        gmii_tx_er_r <= 1'b0;
    end
    else
    begin
        gmii_txd_r      <= gmii_txd;
        gmii_tx_en_r    <= gmii_tx_en;
        gmii_tx_er_r    <= gmii_tx_er;
        gmii_txd_r_d1   <= gmii_txd_r;
        gmii_tx_en_r_d1 <= gmii_tx_en_r;
    end
end

always @(posedge gmii_tx_clk)
begin
    rgmii_tx_ctl_r = gmii_tx_en_r ^ gmii_tx_er_r;
    gmii_txd_low   = gmii_txd_r[7:4];
end

//输出双沿采样寄存器 (rgmii_txd)
GTP_OSERDES #(
    .OSERDES_MODE    ("ODDR" ),  //"ODDR","OMDDR","OGSER4","OMSER4","OGSER7","OGSER8",OMSER8"
    .WL_EXTEND       ("FALSE"),  //"TRUE"; "FALSE"
    .GRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .LRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .TSDDR_INIT      (1'b0   )   //1'b0;1'b1
) gtp_ogddr6(     
    .DO              (stx_txc        ),
    .TQ              (padt6          ),
    .DI              ({7'd0,1'b1}    ),
    .TI              (4'd0           ),
    .RCLK            (gmii_tx_clk_deg),
    .SERCLK          (gmii_tx_clk_deg),
    .OCLK            (1'd0           ),
    .RST             (tx_reset_sync  )
);
GTP_OUTBUFT  gtp_outbuft6
(
    .I    (stx_txc  ),
    .T    (padt6    ),
    .O    (rgmii_txc)
);


GTP_OSERDES #(
    .OSERDES_MODE    ("ODDR" ),  //"ODDR","OMDDR","OGSER4","OMSER4","OGSER7","OGSER8",OMSER8"
    .WL_EXTEND       ("FALSE"),  //"TRUE"; "FALSE"
    .GRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .LRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .TSDDR_INIT      (1'b0   )   //1'b0;1'b1
) gtp_ogddr2(     
    .DO              (stxd_rgm[3]  ),
    .TQ              (padt2        ),
    .DI              ({6'd0,gmii_txd_low[3],gmii_txd_r_d1[3]}),
    .TI              (4'd0         ),
    .RCLK            (gmii_tx_clk  ),
    .SERCLK          (gmii_tx_clk  ),
    .OCLK            (1'd0         ),
    .RST             (tx_reset_sync)
); 
GTP_OUTBUFT  gtp_outbuft2
(
    .I    (stxd_rgm[3]),
    .T    (padt2      ),
    .O    (rgmii_txd[3])
);


GTP_OSERDES #(
    .OSERDES_MODE    ("ODDR" ),  //"ODDR","OMDDR","OGSER4","OMSER4","OGSER7","OGSER8",OMSER8"
    .WL_EXTEND       ("FALSE"),  //"TRUE"; "FALSE"
    .GRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .LRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .TSDDR_INIT      (1'b0   )   //1'b0;1'b1
) gtp_ogddr3(     
    .DO              (stxd_rgm[2]  ),
    .TQ              (padt3        ),
    .DI              ({6'd0,gmii_txd_low[2],gmii_txd_r_d1[2]}),
    .TI              (4'd0         ),
    .RCLK            (gmii_tx_clk  ),
    .SERCLK          (gmii_tx_clk  ),
    .OCLK            (1'd0         ),
    .RST             (tx_reset_sync)
); 
GTP_OUTBUFT  gtp_outbuft3
(    
    .I    (stxd_rgm[2]),
    .T    (padt3      ),
    .O    (rgmii_txd[2])
);


GTP_OSERDES #(
    .OSERDES_MODE    ("ODDR" ),  //"ODDR","OMDDR","OGSER4","OMSER4","OGSER7","OGSER8",OMSER8"
    .WL_EXTEND       ("FALSE"),  //"TRUE"; "FALSE"
    .GRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .LRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .TSDDR_INIT      (1'b0   )   //1'b0;1'b1
) gtp_ogddr4(     
    .DO              (stxd_rgm[1]  ),
    .TQ              (padt4        ),
    .DI              ({6'd0,gmii_txd_low[1],gmii_txd_r_d1[1]}),
    .TI              (4'd0         ),
    .RCLK            (gmii_tx_clk  ),
    .SERCLK          (gmii_tx_clk  ),
    .OCLK            (1'd0         ),
    .RST             (tx_reset_sync)
); 
GTP_OUTBUFT  gtp_outbuft4
(
    .I    (stxd_rgm[1]),
    .T    (padt4      ),
    .O    (rgmii_txd[1])
);


GTP_OSERDES #(
    .OSERDES_MODE    ("ODDR" ),  //"ODDR","OMDDR","OGSER4","OMSER4","OGSER7","OGSER8",OMSER8"
    .WL_EXTEND       ("FALSE"),  //"TRUE"; "FALSE"
    .GRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .LRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .TSDDR_INIT      (1'b0   )   //1'b0;1'b1
) gtp_ogddr5(     
    .DO              (stxd_rgm[0]  ),
    .TQ              (padt5        ),
    .DI              ({6'd0,gmii_txd_low[0],gmii_txd_r_d1[0]}),
    .TI              (4'd0         ),
    .RCLK            (gmii_tx_clk  ),
    .SERCLK          (gmii_tx_clk  ),
    .OCLK            (1'd0         ),
    .RST             (tx_reset_sync)
); 
GTP_OUTBUFT  gtp_outbuft5
(
    .I    (stxd_rgm[0]),
    .T    (padt5      ),
    .O    (rgmii_txd[0])
);


//输出双沿采样寄存器 (rgmii_tx_ctl)
GTP_OSERDES #( 
    .OSERDES_MODE    ("ODDR" ),  //"ODDR","OMDDR","OGSER4","OMSER4","OGSER7","OGSER8",OMSER8"
    .WL_EXTEND       ("FALSE"),  //"TRUE"; "FALSE"
    .GRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .LRS_EN          ("TRUE" ),  //"TRUE"; "FALSE"
    .TSDDR_INIT      (1'b0   )   //1'b0;1'b1
) gtp_ogddr1(     
    .DO              (stx_ctr      ),
    .TQ              (padt1        ),
    .DI              ({6'd0,rgmii_tx_ctl_r,gmii_tx_en_r_d1}),
    .TI              (4'd0         ),
    .RCLK            (gmii_tx_clk  ),
    .SERCLK          (gmii_tx_clk  ),
    .OCLK            (1'd0         ),
    .RST             (tx_reset_sync)
); 
GTP_OUTBUFT  gtp_outbuft1
(
    .I    (stx_ctr     ),
    .T    (padt1       ),
    .O    (rgmii_tx_ctl)
);

endmodule