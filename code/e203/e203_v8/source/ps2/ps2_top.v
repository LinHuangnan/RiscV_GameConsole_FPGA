
module ps2_top(
    input   clk,
    input   rst_n,


    //spi interface
	output         spi_cs        ,//SPI从机的片选信号，低电平有效。
	output         spi_clk       ,//主从机之间的数据同步时钟。
	output         spi_mosi      ,//数据引脚，主机输出，从机输入。
	input          spi_miso      , //数据引脚，主机输入，从机输出。


    output  reg [3:0]       led,
    output  [15:0]      ps2_key


);


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        led<=4'h0;
    else begin
        case(ps2_key)
            16'b0000_0000_0000_0001 :  led<=4'b0000;
            16'b0000_0000_0000_0010 :  led<=4'b0001;
            16'b0000_0000_0000_0100 :  led<=4'b0010;
            16'b0000_0000_0000_1000 :  led<=4'b0011;
            16'b0000_0000_0001_0000 :  led<=4'b0100;
            16'b0000_0000_0010_0000 :  led<=4'b0101;
            16'b0000_0000_0100_0000 :  led<=4'b0110;
            16'b0000_0000_1000_0000 :  led<=4'b0111;
            16'b0000_0001_0000_0000 :  led<=4'b1000;
            16'b0000_0010_0000_0000 :  led<=4'b1001;
            16'b0000_0100_0000_0000 :  led<=4'b1010;
            16'b0000_1000_0000_0000 :  led<=4'b1011;
            16'b0001_0000_0000_0000 :  led<=4'b1100;
            16'b0010_0000_0000_0000 :  led<=4'b1101;
            16'b0100_0000_0000_0000 :  led<=4'b1110;
            16'b1000_0000_0000_0000 :  led<=4'b1111;
            default:                  led<=4'h0;

        endcase
    end

    
end



spi_drive u_spi_drive(

	.clk_50m(clk)      ,
	.rst_n(rst_n)     ,
	
	.ps2_key(ps2_key),

	//spi interface
	.spi_cs(spi_cs)        ,//SPI从机的片选信号，低电平有效。
	.spi_clk(spi_clk)       ,//主从机之间的数据同步时钟。
	.spi_mosi(spi_mosi)      ,//数据引脚，主机输出，从机输入。
    .spi_miso(spi_miso)       //数据引脚，主机输入，从机输出。

);

endmodule