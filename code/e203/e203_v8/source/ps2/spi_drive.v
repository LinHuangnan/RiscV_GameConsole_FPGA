
module spi_drive(

	input             clk_50m      ,
	input             rst_n     ,
	
	output	reg [15:0]		ps2_key,

	//spi interface
	output reg        spi_cs        ,//SPI从机的片选信号，低电平有效。
	output reg        spi_clk       ,//主从机之间的数据同步时钟。
	output reg        spi_mosi      ,//数据引脚，主机输出，从机输入。
	input             spi_miso       //数据引脚，主机输入，从机输出。

);

//状态机
parameter IDLE         =2'd0;//空闲状态
parameter CMD          =2'd1;//发送命令
parameter READ         =2'd2;//读数据

localparam clk_cnt0_max = 32'd999999;
localparam clk_cnt1_max = 16'd599;
localparam clk_cnt2_max = 16'd1199;

//指令集
parameter CMD0      =8'h01;
parameter CMD1      =8'h42;
;

//wire define
wire		read_valid_pos;
wire		spi_start;
wire		clk_cnt1_half;
wire		clk_cnt1_full;
wire		read_valid;

//reg define
reg [31:0] 	clk_cnt0;
reg [15:0]	clk_cnt1;
reg [15:0]	clk_cnt2;

reg [3:0]	byte_cnt;
reg [3:0]	bit_cnt;


reg			read_valid_d0;
reg			read_valid_d1;

reg	[1:0]	current_state;
reg [1:0]	next_state;

reg [15:0]	cmd_buffer;

reg [15:0]	key_data;
reg [7:0]	pre_data;

//*****************************************************
//**                    main code
//*****************************************************

assign 	read_valid_pos = read_valid_d0 & (~read_valid_d1);
assign	spi_start = clk_cnt0 ==(clk_cnt0_max-16'd100);
assign	clk_cnt1_half = clk_cnt1==(clk_cnt1_max>>1);
assign	clk_cnt1_full = clk_cnt1==clk_cnt1_max;

assign	read_valid = (byte_cnt==4'd9) && (pre_data==8'h5a) && (bit_cnt==4'd8);
//assign	read_valid = (byte_cnt==4'd9) && (bit_cnt==4'd8);

always @(posedge clk_50m or negedge rst_n )begin
	if(!rst_n)
		current_state<=IDLE;
	else
		current_state<=next_state;
end


//三段式状态机
always @(posedge clk_50m or negedge rst_n )begin
	if(!rst_n)
		ps2_key<=16'd0;
	else if(read_valid_pos)
		ps2_key<=~key_data;
end


always @(*)begin
	case(current_state)
	   	IDLE: begin
	          if(spi_start)
				next_state=CMD;
			  else
	            next_state=IDLE;
			end
		CMD: begin
			  if(byte_cnt==2 && clk_cnt1_half && bit_cnt==4'd8)
				   next_state=READ;
			  else
		           next_state=CMD;
			  end
			 
		READ: begin
				if(byte_cnt>=4'd9 && clk_cnt1_half && bit_cnt==4'd8)
					next_state=IDLE;
				else
					next_state=READ;
				end
	default: next_state=IDLE;			
	endcase				
end

always @(posedge clk_50m or negedge rst_n )begin
	if(!rst_n)begin
		read_valid_d0<=1'b0;
		read_valid_d1<=1'b0;
	end else begin
		read_valid_d0<=read_valid;
		read_valid_d1<=read_valid_d0;
	end
end

always @(posedge clk_50m or negedge rst_n )begin
	if(!rst_n)
		clk_cnt0<=32'd0;
	else if(clk_cnt0<clk_cnt0_max)
		clk_cnt0<=clk_cnt0+1'd1;
	else
		clk_cnt0<=32'd0;
end

always @(posedge clk_50m or negedge rst_n )begin
	if(!rst_n)
		clk_cnt1<=16'd0;
	else if(spi_cs==1'b0)begin
		if(clk_cnt1<clk_cnt1_max)
			clk_cnt1<=clk_cnt1+1'b1;
		else
			clk_cnt1<=16'd0;
	end 
	else
		clk_cnt1<=16'd0;
end


always @(posedge clk_50m or negedge rst_n )begin
	if(!rst_n)
		byte_cnt<=4'd0;
	else if(spi_cs==1'b0)begin
		if(clk_cnt1_half && bit_cnt==4'd7)
			byte_cnt<=byte_cnt+1'b1;
		else
			byte_cnt<=byte_cnt;
	end 
	else
		byte_cnt<=4'd0;
end

									
always @(posedge clk_50m or negedge rst_n )begin
	if(!rst_n) begin
		spi_cs<=1'b1;
		spi_clk<=1'b1;
		spi_mosi<=1'b0;
		cmd_buffer<={CMD1,CMD0};
		bit_cnt<=4'd0;
		key_data<=16'hffff;
		pre_data<=8'd0;
	end
	else begin
		case(current_state)
			IDLE: begin
				spi_cs<=1'b1;
				spi_clk<=1'b1;
				spi_mosi<=1'b0;
				cmd_buffer<={CMD1,CMD0};
				bit_cnt<=4'd0;
				key_data<=16'hffff;	
				pre_data<=8'd0;	
			end
			CMD: begin
				spi_cs<=1'b0;
				spi_mosi<=cmd_buffer[0];
				if(clk_cnt1_half) begin						
					if(bit_cnt==4'd8) begin
						bit_cnt<=4'd0;
					end else begin
						bit_cnt<=bit_cnt+1'b1;
						spi_clk<=1'b0;
					end
				end
				else if(clk_cnt1_full && bit_cnt>4'd0)begin
					spi_clk<=1'b1;											
					cmd_buffer<=cmd_buffer>>1;
				end
			end
			READ: begin
				spi_cs<=1'b0;
				spi_mosi<=1'b0;
				if(clk_cnt1_half) begin						
					if(bit_cnt==4'd8) begin
						bit_cnt<=4'd0;
					end else begin
						bit_cnt<=bit_cnt+1'b1;
						spi_clk<=1'b0;
						if(byte_cnt==4'd2)begin
							pre_data<={spi_miso,pre_data[7:1]};
						end
						else if(byte_cnt==4'd3 | byte_cnt==4'd4)begin
							key_data<={spi_miso,key_data[15:1]};
						end
					end
				end
				else if(clk_cnt1_full && bit_cnt>4'd0)begin
					spi_clk<=1'b1;											
				end
				end
             default: begin
			    spi_cs<=1'b1;
				spi_clk<=1'b1;
				spi_mosi<=1'b0;
				cmd_buffer<={CMD1,CMD0};
				bit_cnt<=4'd0;
				key_data<=16'hffff;	
				pre_data<=8'd0;	
			end
         endcase
	end
end

endmodule


