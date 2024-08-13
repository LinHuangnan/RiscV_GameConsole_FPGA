//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           eth_ctrl
// Last modified Date:  2020/2/18 9:20:14
// Last Version:        V1.0
// Descriptions:        以太网控制模块
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2020/2/18 9:20:14
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module eth_ctrl(
    input              clk       ,     //系统时钟
    input              rst_n     ,     //系统复位信号，低电平有效 
    //ARP相关端口信号                                   
    input              arp_rx_done,    //ARP接收完成信号
    input              arp_rx_type,    //ARP接收类型 0:请求  1:应答
    output  reg        arp_tx_en,      //ARP发送使能信号
    output             arp_tx_type,    //ARP发送类型 0:请求  1:应答
    input              arp_tx_done,    //ARP发送完成信号
    input              arp_gmii_tx_en, //ARP GMII输出数据有效信号 
    input     [7:0]    arp_gmii_txd,   //ARP GMII输出数据
    //UDP相关端口信号
    input              udp_tx_start_en,//UDP开始发送信号
    input              udp_tx_done,    //UDP发送完成信号
    input              udp_gmii_tx_en, //UDP GMII输出数据有效信号  
    input     [7:0]    udp_gmii_txd,   //UDP GMII输出数据   
    //GMII发送引脚                     
    output             gmii_tx_en,     //GMII输出数据有效信号 
    output    [7:0]    gmii_txd        //UDP GMII输出数据 
    );

//reg define
reg        protocol_sw; //协议切换信号
reg        udp_tx_busy; //UDP正在发送数据标志信号
reg        arp_rx_flag; //接收到ARP请求信号的标志

//*****************************************************
//**                    main code
//*****************************************************

assign arp_tx_type = 1'b1;   //ARP发送类型固定为ARP应答                                   
assign gmii_tx_en = protocol_sw ? udp_gmii_tx_en : arp_gmii_tx_en;
assign gmii_txd = protocol_sw ? udp_gmii_txd : arp_gmii_txd;

//控制UDP发送忙信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        udp_tx_busy <= 1'b0;
    else if(udp_tx_start_en)   
        udp_tx_busy <= 1'b1;
    else if(udp_tx_done)
        udp_tx_busy <= 1'b0;
end

//控制接收到ARP请求信号的标志
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        arp_rx_flag <= 1'b0;
    else if(arp_rx_done && (arp_rx_type == 1'b0))   
        arp_rx_flag <= 1'b1;
    else if(protocol_sw == 1'b0)
        arp_rx_flag <= 1'b0;
end

//控制protocol_sw和arp_tx_en信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        protocol_sw <= 1'b0;
        arp_tx_en <= 1'b0;
    end
    else begin
        arp_tx_en <= 1'b0;
        if(udp_tx_start_en)
            protocol_sw <= 1'b1;
        else if(arp_rx_flag && (udp_tx_busy == 1'b0)) begin
            protocol_sw <= 1'b0;
            arp_tx_en <= 1'b1;
        end    
    end        
end

endmodule
