//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           udp
// Last modified Date:  2020/2/18 9:20:14
// Last Version:        V1.0
// Descriptions:        udpģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2020/2/18 9:20:14
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module udp(
    input                rst_n       , //��λ�źţ��͵�ƽ��Ч
    //GMII�ӿ�
    //input                gmii_rx_clk , //GMII��������ʱ��
    //input                gmii_rx_dv  , //GMII����������Ч�ź�
    //input        [7:0]   gmii_rxd    , //GMII��������
    input                gmii_tx_clk , //GMII��������ʱ��    
    output               gmii_tx_en  , //GMII���������Ч�ź�
    output       [7:0]   gmii_txd    , //GMII������� 
    //�û��ӿ�
    //output               rec_pkt_done, //��̫���������ݽ�������ź�
    //output               rec_en      , //��̫�����յ�����ʹ���ź�
    //output       [31:0]  rec_data    , //��̫�����յ�����
    //output       [15:0]  rec_byte_num, //��̫�����յ���Ч�ֽ��� ��λ:byte     
    input                tx_start_en , //��̫����ʼ�����ź�
    input        [31:0]  tx_data     , //��̫������������  
    input        [15:0]  tx_byte_num , //��̫�����͵���Ч�ֽ��� ��λ:byte  
    input        [47:0]  des_mac     , //���͵�Ŀ��MAC��ַ
    input        [31:0]  des_ip      , //���͵�Ŀ��IP��ַ    
    output               tx_done     , //��̫����������ź�
    output               tx_req        //�����������ź�    
    );

//parameter define
//������MAC��ַ 00-11-22-33-44-55
parameter BOARD_MAC = 48'h00_11_22_33_44_55;    
//������IP��ַ 192.168.1.10     
parameter BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};
//Ŀ��MAC��ַ ff_ff_ff_ff_ff_ff
parameter  DES_MAC  = 48'hff_ff_ff_ff_ff_ff;
//Ŀ��IP��ַ 192.168.1.102     
parameter  DES_IP   = {8'd192,8'd168,8'd1,8'd102};

//wire define
wire          crc_en  ; //CRC��ʼУ��ʹ��
wire          crc_clr ; //CRC���ݸ�λ�ź� 
wire  [7:0]   crc_d8  ; //�����У��8λ����

wire  [31:0]  crc_data; //CRCУ������
wire  [31:0]  crc_next; //CRC�´�У���������

//*****************************************************
//**                    main code
//*****************************************************

assign  crc_d8 = gmii_txd;

/*
//��̫������ģ��    
udp_rx 
   #(
    .BOARD_MAC       (BOARD_MAC),         //��������
    .BOARD_IP        (BOARD_IP )
    )
   u_udp_rx(
    .clk             (gmii_rx_clk ),        
    .rst_n           (rst_n       ),             
    .gmii_rx_dv      (gmii_rx_dv  ),                                 
    .gmii_rxd        (gmii_rxd    ),       
    .rec_pkt_done    (rec_pkt_done),      
    .rec_en          (rec_en      ),            
    .rec_data        (rec_data    ),          
    .rec_byte_num    (rec_byte_num)       
    );                                    
*/
//��̫������ģ��
udp_tx
   #(
    .BOARD_MAC       (BOARD_MAC),         //��������
    .BOARD_IP        (BOARD_IP ),
    .DES_MAC         (DES_MAC  ),
    .DES_IP          (DES_IP   )
    )
   u_udp_tx(
    .clk             (gmii_tx_clk),        
    .rst_n           (rst_n      ),             
    .tx_start_en     (tx_start_en),                   
    .tx_data         (tx_data    ),           
    .tx_byte_num     (tx_byte_num),    
    .des_mac         (des_mac    ),
    .des_ip          (des_ip     ),    
    .crc_data        (crc_data   ),          
    .crc_next        (crc_next[31:24]),
    .tx_done         (tx_done    ),           
    .tx_req          (tx_req     ),            
    .gmii_tx_en      (gmii_tx_en ),         
    .gmii_txd        (gmii_txd   ),       
    .crc_en          (crc_en     ),            
    .crc_clr         (crc_clr    )            
    );                                      

//��̫������CRCУ��ģ��
crc32_d8   u_crc32_d8(
    .clk             (gmii_tx_clk),                      
    .rst_n           (rst_n      ),                          
    .data            (crc_d8     ),            
    .crc_en          (crc_en     ),                          
    .crc_clr         (crc_clr    ),                         
    .crc_data        (crc_data   ),                        
    .crc_next        (crc_next   )                         
    );

endmodule