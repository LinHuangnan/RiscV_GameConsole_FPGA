module divider #(
	parameter cfactor=16'd256
)
(
	input clk_in,
	input resetn,
	
	output clk_out
);
    reg [8:0] cnt;
	reg 	clk_loc;


assign clk_out = clk_loc;
always@(posedge clk_in or negedge resetn)
	if(resetn==1'b0)
		cnt <= 'h0;
	else if(cnt < cfactor - 1)
		cnt <= cnt + 1'b1;
	else
		cnt <= 'h0;
	
always@(posedge clk_in or negedge resetn)
	if(resetn==1'b0)
		clk_loc <= 1'b1;
	else if(cnt == cfactor/2 -1)
		clk_loc <= 1'b0;
	else if(cnt == cfactor -1)		
		clk_loc <= 1'b1;
    
endmodule
