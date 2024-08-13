

`timescale 1ns/1ps


module tb();

reg clk;
reg rst_n;


wire    spi_cs;
wire    spi_clk;
wire    spi_mosi;

wire  [15:0]    ps2_key;

initial begin
    clk<=1'b1;
    rst_n<=1'b0;
    #120 rst_n<=1'b1;
end


always #10 clk<=~clk;

spi_drive u_spi_drive(

	.clk_50m(clk)      ,
	.rst_n(rst_n)     ,
	
	.ps2_key(ps2_key),

	//spi interface
	.spi_cs(spi_cs)        ,//SPI从机的片选信号，低电平有效。
	.spi_clk(spi_clk)       ,//主从机之间的数据同步时钟。
	.spi_mosi(spi_mosi)      ,//数据引脚，主机输出，从机输入。
    .spi_miso(1'b0)       //数据引脚，主机输入，从机输出。

);






endmodule