//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���?
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           eth_top
// Last modified Date:  2020/2/18 9:20:14
// Last Version:        V1.0
// Descriptions:        ��̫��ͨ��UDPͨ�Ż��ض���ģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2020/2/18 9:20:14
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module eth_top(
    input              sys_rst_n      ,  //ϵͳ��λ�źţ��͵�ƽ��Ч 
    //��̫��RGMII�ӿ�            
    input              eth_rxc        ,  //RGMII��������ʱ��
    input              eth_rx_ctl     ,  //RGMII����������Ч�ź�
    input  [3:0]       eth_rxd        ,  //RGMII��������
    output             eth_txc        ,  //RGMII��������ʱ��    
    output             eth_tx_ctl     ,  //RGMII���������Ч�ź�?
    output [3:0]       eth_txd        ,  //RGMII�������?          
    output             eth_rst_n      ,  //��̫��оƬ��λ�źţ��͵�ƽ��Ч 
    
    output             gmii_tx_clk    ,  //GMII����ʱ��
    input              udp_tx_start_en,  //��̫����ʼ�����ź�   
    input  [31:0]      tx_data        ,  //��̫������������     
    input  [15:0]      tx_byte_num    ,  //��̫�����͵���Ч�ֽ��� ��λ:byte 
    output             udp_tx_done    ,  //UDP��������ź�?  
    output             tx_req         ,  //�����������ź�    
           
    output             gmii_rx_clk      //GMII����ʱ�� 
    //output             rec_pkt_done   ,  //UDP�������ݽ�������ź�? 
    //output             rec_en         ,  //UDP���յ�����ʹ���ź�          
    //output [31:0]      rec_data       ,  //UDP���յ�����
    //output [15:0]      rec_byte_num      //UDP���յ����ֽ���
);

//parameter define
//������MAC��ַ 00-11-22-33-44-55
parameter  BOARD_MAC = 48'h00_11_22_33_44_55;     
//������IP��ַ 192.168.1.10
parameter  BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};  
//Ŀ��MAC��ַ ff_ff_ff_ff_ff_ff
parameter  DES_MAC   = 48'hff_ff_ff_ff_ff_ff;    
//Ŀ��IP��ַ 192.168.1.102     
parameter  DES_IP    = {8'd192,8'd168,8'd1,8'd102};  

//wire define           
wire          gmii_rx_dv ; //GMII����������Ч�ź�
wire  [7:0]   gmii_rxd   ; //GMII��������
wire          gmii_tx_en ; //GMII��������ʹ���ź�
wire  [7:0]   gmii_txd   ; //GMII��������     
wire          arp_gmii_tx_en; //ARP GMII���������Ч�ź�? 
wire  [7:0]   arp_gmii_txd  ; //ARP GMII�������?
wire          arp_rx_done   ; //ARP��������ź�?
wire          arp_rx_type   ; //ARP�������� 0:����  1:Ӧ��
wire  [47:0]  src_mac       ; //���յ�Ŀ��MAC��ַ
wire  [31:0]  src_ip        ; //���յ�Ŀ��IP��ַ    
wire          arp_tx_en     ; //ARP����ʹ���ź�
wire          arp_tx_type   ; //ARP�������� 0:����  1:Ӧ��
wire  [47:0]  des_mac       ; //���͵�Ŀ��MAC��ַ
wire  [31:0]  des_ip        ; //���͵�Ŀ��IP��ַ   
wire          arp_tx_done   ; //ARP��������ź�?
wire          udp_gmii_tx_en; //UDP GMII���������Ч�ź�? 
wire  [7:0]   udp_gmii_txd  ; //UDP GMII�������?

//*****************************************************
//**                    main code
//*****************************************************

assign des_mac = DES_MAC;
assign des_ip = DES_IP;
assign eth_rst_n = sys_rst_n;


assign gmii_tx_en = udp_gmii_tx_en ;
assign gmii_txd = udp_gmii_txd ;



gmii_to_rgmii  u_gmii_to_rgmii(
    .gmii_rx_clk   (gmii_rx_clk ),
    .gmii_rx_dv    (gmii_rx_dv  ),
    .gmii_rxd      (gmii_rxd    ),
    .gmii_tx_clk   (gmii_tx_clk ),
    .gmii_tx_en    (gmii_tx_en  ),
    .gmii_txd      (gmii_txd    ),
    
    .rgmii_rxc     (eth_rxc     ),
    .rgmii_rx_ctl  (eth_rx_ctl  ),
    .rgmii_rxd     (eth_rxd     ),
    .rgmii_txc     (eth_txc     ),
    .rgmii_tx_ctl  (eth_tx_ctl  ),
    .rgmii_txd     (eth_txd     )
    );

/*
arp                                             
   #(
    .BOARD_MAC     (BOARD_MAC),
    .BOARD_IP      (BOARD_IP ),
    .DES_MAC       (DES_MAC  ),
    .DES_IP        (DES_IP   )
    )
   u_arp(
    .rst_n         (sys_rst_n  ),
                    
    .gmii_rx_clk   (gmii_rx_clk),
    .gmii_rx_dv    (gmii_rx_dv ),
    .gmii_rxd      (gmii_rxd   ),
    .gmii_tx_clk   (gmii_tx_clk),
    .gmii_tx_en    (arp_gmii_tx_en ),
    .gmii_txd      (arp_gmii_txd),
                    
    .arp_rx_done   (arp_rx_done),
    .arp_rx_type   (arp_rx_type),
    .src_mac       (src_mac    ),
    .src_ip        (src_ip     ),
    .arp_tx_en     (arp_tx_en  ),
    .arp_tx_type   (arp_tx_type),
    .des_mac       (des_mac    ),
    .des_ip        (des_ip     ),
    .tx_done       (arp_tx_done)
    );
*/


//
udp                                             
   #(
    .BOARD_MAC     (BOARD_MAC),      //��������
    .BOARD_IP      (BOARD_IP ),
    .DES_MAC       (DES_MAC  ),
    .DES_IP        (DES_IP   )
    )
   u_udp(
    .rst_n         (sys_rst_n   ),  
    
    //.gmii_rx_clk   (gmii_rx_clk ),           
    //.gmii_rx_dv    (gmii_rx_dv  ),         
    //.gmii_rxd      (gmii_rxd    ),                   
    .gmii_tx_clk   (gmii_tx_clk ), 
    .gmii_tx_en    (udp_gmii_tx_en),         
    .gmii_txd      (udp_gmii_txd),  

    //.rec_pkt_done  (rec_pkt_done),    
    //.rec_en        (rec_en      ),     
    //.rec_data      (rec_data    ),         
    //.rec_byte_num  (rec_byte_num),      
    .tx_start_en   (udp_tx_start_en ),        
    .tx_data       (tx_data     ),         
    .tx_byte_num   (tx_byte_num ),  
    .des_mac       (des_mac     ),
    .des_ip        (des_ip      ),    
    .tx_done       (udp_tx_done ),        
    .tx_req        (tx_req      )           
    ); 
    
/*
eth_ctrl u_eth_ctrl(
    .clk            (gmii_rx_clk),
    .rst_n          (sys_rst_n),

    .arp_rx_done    (arp_rx_done   ),
    .arp_rx_type    (arp_rx_type   ),
    .arp_tx_en      (arp_tx_en     ),
    .arp_tx_type    (arp_tx_type   ),
    .arp_tx_done    (arp_tx_done   ),
    .arp_gmii_tx_en (arp_gmii_tx_en),
    .arp_gmii_txd   (arp_gmii_txd  ),
    
    .udp_tx_start_en(udp_tx_start_en),
    .udp_tx_done    (udp_tx_done   ),    
    .udp_gmii_tx_en (udp_gmii_tx_en),
    .udp_gmii_txd   (udp_gmii_txd  ),
                     
    .gmii_tx_en     (gmii_tx_en    ),
    .gmii_txd       (gmii_txd      )
    );
*/

endmodule