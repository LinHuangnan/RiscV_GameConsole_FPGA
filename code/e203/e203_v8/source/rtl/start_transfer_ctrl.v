//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           start_transfer_ctrl
// Last modified Date:  2020/2/18 9:20:14
// Last Version:        V1.0
// Descriptions:        图像开始传输控制模块
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2020/2/18 9:20:14
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module start_transfer_ctrl(
    input                 clk                ,   //时钟信号
    input                 rst_n              ,   //复位信号，低电平有效
    input                 udp_rec_pkt_done   ,   //GMII接收时钟 
    input                 udp_rec_en         ,   //UDP单包数据接收完成信号
    input        [31:0]   udp_rec_data       ,   //UDP接收的数据使能信号 
    input        [15:0]   udp_rec_byte_num   ,   //UDP接收的数据
                                                 //UDP接收到的字节数
    output  reg           transfer_flag          //图像开始传输标志,1:开始传输 0:停止传输
    );    
    
//parameter define
parameter  START = "1";  //开始命令
parameter  STOP  = "0";  //停止命令

//*****************************************************
//**                    main code
//*****************************************************

//解析接收到的数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        transfer_flag <= 1'b0;
    else if(udp_rec_pkt_done && udp_rec_byte_num == 1'b1) begin
        if(udp_rec_data[31:24] == START)         //开始传输
            transfer_flag <= 1'b1;
        else if(udp_rec_data[31:24] == STOP)     //停止传输
            transfer_flag <= 1'b0;
    end
end 

endmodule