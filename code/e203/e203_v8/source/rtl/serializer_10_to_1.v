//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           serializer_10_to_1
// Last modified Date:  2021/4/7 9:30:00
// Last Version:        V1.1
// Descriptions:        ����ʵ��10:1����ת��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2021/4/7 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//


module serializer_10_to_1(
    input           serial_clk_5x,      // ���봮������ʱ��
    input   [9:0]   paralell_data,      // ���벢������

    output          serial_data_p,      // ������в������P
    output          serial_data_n       // ������в������N
    );
   
//reg define
reg   [2:0]  bit_cnt = 0;    
reg   [4:0]  datain_rise_shift = 0;
reg   [4:0]  datain_fall_shift = 0;
    
//wire define
wire  [4:0]  datain_rise;    
wire  [4:0]  datain_fall;
wire         ddr_data_p;      //ddrԭ���������P
wire         tristate_p;      //ddrԭ�������̬P
wire         ddr_data_n;      //ddrԭ���������n
wire         tristate_n;      //ddrԭ�������̬n
  
//*****************************************************
//**                    main code
//*****************************************************

//�����ط���Bit[8]/Bit[6]/Bit[4]/Bit[2]/Bit[0]
assign  datain_rise = {paralell_data[8],paralell_data[6],paralell_data[4],
                       paralell_data[2],paralell_data[0]};

//�½��ط���Bit[9]/Bit[7]/Bit[5]/Bit[3]/Bit[1]                       
assign  datain_fall = {paralell_data[9],paralell_data[7],paralell_data[5],
                       paralell_data[3],paralell_data[1]};

//λ��������ֵ
always @(posedge serial_clk_5x) begin
    if(bit_cnt == 3'd4)
        bit_cnt <= 1'b0;
    else
        bit_cnt <= bit_cnt + 1'b1;
end                       

//��λ��ֵ�����Ͳ������ݵ�ÿһλ
always @(posedge serial_clk_5x) begin
    if(bit_cnt == 3'd4) begin               
        datain_rise_shift <= datain_rise;
        datain_fall_shift <= datain_fall; 
    end    
    else begin
        datain_rise_shift <= datain_rise_shift[4:1];
        datain_fall_shift <= datain_fall_shift[4:1];
    end    
end  

//����DDRԭ�ʵ�ֲ���ת��
GTP_OSERDES #(
 .OSERDES_MODE("ODDR"),    //����ģʽ "ODDR","OMDDR","OGER4","OMSER4","OGER7","OGER8",OMSER8"
 .WL_EXTEND   ("FALSE"),   //Write Leveling��չ "TRUE"; "FALSE"
 .GRS_EN      ("TRUE"),    //ȫ�ָ�λʹ�� "TRUE"; "FALSE"
 .LRS_EN      ("TRUE"),    //����λʹ�� "TRUE"; "FALSE"
 .TSDDR_INIT  (1'b0)       //TQ��ʼ̬���� 1'b0;1'b1
) gtp_ogddr_p(
   .DO    (ddr_data_p),   //�������
   .TQ    (tristate_p),   //��̬�������
   .DI    ({6'd0,datain_fall_shift[0],datain_rise_shift[0]}),//��������
   .TI    (4'd0),  //��̬��������
   .RCLK  (serial_clk_5x), //����ʱ��
   .SERCLK(serial_clk_5x), //����ʱ��
   .OCLK  (1'd0), //�������ʱ��
   .RST   (1'b0)  //��λ�źţ�����Ч
); 

//��̬���ԭ��
GTP_OUTBUFT  gtp_outbuft_p
(  
    .I(ddr_data_p),    //�����ź�
    .T(tristate_p),    //��̬ʹ���źţ�����Ч
    .O(serial_data_p)  //����ź�
);

//����DDRԭ�ʵ�ֲ���ת��
GTP_OSERDES #(
 .OSERDES_MODE("ODDR"),  //����ģʽ "ODDR","OMDDR","OGER4","OMSER4","OGER7","OGER8",OMSER8"
 .WL_EXTEND   ("FALSE"), //Write Leveling��չ "TRUE"; "FALSE"
 .GRS_EN      ("TRUE"),  //ȫ�ָ�λʹ�� "TRUE"; "FALSE"
 .LRS_EN      ("TRUE"),  //����λʹ�� "TRUE"; "FALSE"
 .TSDDR_INIT  (1'b0)     //TQ��ʼ̬���� 1'b0;1'b1
) gtp_ogddr_n(
   .DO    (ddr_data_n),  //�������
   .TQ    (tristate_n),  //��̬�������
   .DI    ({6'd0,~datain_fall_shift[0],~datain_rise_shift[0]}), //��������
   .TI    (4'd0),          //��̬��������
   .RCLK  (serial_clk_5x), //����ʱ��
   .SERCLK(serial_clk_5x), //����ʱ��
   .OCLK  (1'd0),          //�������ʱ��
   .RST   (1'b0)           //��λ�źţ�����Ч
); 

//��̬���ԭ��
GTP_OUTBUFT  gtp_outbuft_n
(  
    .I(ddr_data_n),    //�����ź�
    .T(tristate_n),    //��̬ʹ���źţ�����Ч
    .O(serial_data_n)  //����ź�
);

endmodule
