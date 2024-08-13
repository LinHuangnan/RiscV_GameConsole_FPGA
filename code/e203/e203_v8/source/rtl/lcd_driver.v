//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                               
//----------------------------------------------------------------------------------------
// File name:           lcd_driver
// Last modified Date:  2019/8/07 10:41:06
// Last Version:        V1.0
// Descriptions:        LCD����ģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/8/07 10:41:06
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module lcd_driver(
    input                lcd_pclk,    //ʱ��
    input                rst_n,       //��λ���͵�ƽ��Ч
    input                almost_full,
    input        [23:0]  pixel_data,  //��������
    input                lcd_driver_en,
    output               data_req,
    //RGB LCD�ӿ�

    output               lcd_de,      //LCD ����ʹ���ź�
    output               lcd_hs,      //LCD ��ͬ���ź�
    output               lcd_vs,      //LCD ��ͬ���ź�
    output               lcd_bl,      //LCD ��������ź�
    output               lcd_rst,     //LCD��λ
    output       [23:0]  lcd_rgb      //LCD RGB888��ɫ����
    );


parameter  H_SYNC   =  11'd76;     //��ͬ��
parameter  H_BACK   =  11'd240;    //����ʾ����
parameter  H_DISP   =  11'd1024;   //����Ч����
parameter  H_FRONT  =  11'd260;   //����ʾǰ��
parameter  H_TOTAL  =  11'd1600;   //��ɨ������
   
parameter  V_SYNC   =  11'd2;      //��ͬ��
parameter  V_BACK   =  11'd33;     //����ʾ����
parameter  V_DISP   =  11'd480;    //����Ч����
parameter  V_FRONT  =  11'd10;     //����ʾǰ��
parameter  V_TOTAL  =  11'd525;    //��ɨ������





reg  [10:0] h_cnt  ;
reg  [10:0] v_cnt  ;

//wire define    
wire        lcd_en;
wire        dispaly_en;


//*****************************************************
//**                    main code
//*****************************************************

assign  lcd_hs = 1'b1;        //LCD��ͬ���ź�
assign  lcd_vs = 1'b1;        //LCD��ͬ���ź�

assign  lcd_bl = 1'b1;        //LCD��������ź�  
assign  lcd_rst= 1'b1;        //LCD��λ
assign  lcd_de = lcd_en;      //LCD������Ч�ź�


assign  lcd_en = ((h_cnt >= H_SYNC+H_BACK) && (h_cnt < H_SYNC+H_BACK+H_DISP)
                  && (v_cnt >= V_SYNC+V_BACK) && (v_cnt < V_SYNC+V_BACK+V_DISP)) 
                  ? 1'b1 : 1'b0;

assign data_req = ((h_cnt >= H_SYNC+H_BACK-1'b1) && (h_cnt < H_SYNC+H_BACK+11'd640-1'b1)
                  && (v_cnt >= V_SYNC+V_BACK) && (v_cnt < V_SYNC+V_BACK+V_DISP)) 
                  ? 1'b1 : 1'b0;

assign dispaly_en = ((h_cnt >= H_SYNC+H_BACK) && (h_cnt < H_SYNC+H_BACK+11'd640)
                  && (v_cnt >= V_SYNC+V_BACK) && (v_cnt < V_SYNC+V_BACK+V_DISP)) 
                  ? 1'b1 : 1'b0;


assign lcd_rgb = dispaly_en ? pixel_data : 24'd0;



//�м�����������ʱ�Ӽ���
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n | (~lcd_driver_en)) 
        h_cnt <= 11'd0;
    else begin
        if(h_cnt == H_TOTAL - 1'b1)
            h_cnt <= 11'd0;
        else
            h_cnt <= h_cnt + 1'b1;           
    end
end

//�����������м���
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n | | (~lcd_driver_en)) 
        v_cnt <= 11'd0;
    else begin
        if(h_cnt == H_TOTAL - 1'b1) begin
            if(v_cnt == V_TOTAL - 1'b1)
                v_cnt <= 11'd0;
            else
                v_cnt <= v_cnt + 1'b1;    
        end
    end    
end

endmodule
