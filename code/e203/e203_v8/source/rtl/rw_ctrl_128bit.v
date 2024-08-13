`include "./hdmi_define.v"


module rw_ctrl_128bit 
 (
   input                   clk             ,
   input                   rst_n           ,
   input                   ddr_init_done   , 

   output      [32-1:0 ]   axi_araddr      , 
   output      [7:0    ]   axi_arlen       ,
   output wire [2:0    ]   axi_arsize      ,
   output wire [1:0    ]   axi_arburst     ,
   output wire             axi_arlock      ,
   output wire             axi_arpoison    ,
   output wire             axi_arurgent    ,
   input                   axi_arready     ,
   output reg              axi_arvalid     ,
   input                   axi_rlast       ,
   input                   axi_rvalid      ,
   output wire             axi_rready      ,

   input                    almost_full
);

//localparam define 
localparam IDLE        = 4'd1 ;
localparam DDR3_DONE   = 4'd2 ;
localparam READ_ADDR   = 4'd3 ;
localparam READ_DATA   = 4'd4 ;


//for 1280*720@(60Hz)


`ifdef hdmi_1280_720
    localparam start_addr = 32'h00200000;
    localparam lenth_cnt_rd_max = 32'd1800;
    localparam rd_len_addr_inc = 11'd1024;
    localparam app_addr_rd_max = (lenth_cnt_rd_max-32'd1)*rd_len_addr_inc + start_addr;
`endif

//for 640*480@(60Hz)
`ifdef hdmi_640_480
    localparam start_addr = 32'h00200000;
    localparam lenth_cnt_rd_max = 32'd600;
    localparam rd_len_addr_inc = 11'd1024;
    localparam app_addr_rd_max = (lenth_cnt_rd_max-32'd1)*rd_len_addr_inc + start_addr;
`endif




reg       init_start   ;
reg [7:0] init_addr    ;
reg [31:0] axi_araddr_n ;
reg [3:0]   state_rd_cnt;
reg [15:0 ] lenth_cnt    ;



assign  axi_arlock   = 1'b0      ;
assign  axi_arurgent = 1'b0      ;
assign  axi_arpoison = 1'b0      ;
assign  axi_arsize   = 3'b100    ;
assign  axi_arburst  = 2'd1      ;
assign  axi_rready   = 1'b1      ;
assign  axi_araddr = axi_araddr_n;



always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        init_start <= 1'b0;
    else if (ddr_init_done)
        init_start <= ddr_init_done;
    else
        init_start <= init_start;
end



assign axi_arlen = 8'd63;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_araddr_n <= start_addr;
      axi_arvalid  <= 1'b0;
    end
    else if(init_start) begin
        if (axi_araddr_n <= app_addr_rd_max) begin
            if (axi_arready && axi_arvalid) begin
                axi_arvalid  <= 1'b0;
                axi_araddr_n <= axi_araddr_n + rd_len_addr_inc;
            end
            else if(axi_arready && state_rd_cnt == READ_ADDR && (!almost_full) )
                axi_arvalid  <= 1'b1;
        end  
        else begin
            axi_arvalid <= 1'b0;
            axi_araddr_n   <= start_addr;
        end
    end
    else begin  
            axi_araddr_n   <= start_addr;
            axi_arvalid    <= 1'b0;
    end     
end 


always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin 
        state_rd_cnt <= IDLE;
    end
    else begin
        case(state_rd_cnt)
            IDLE:begin
                if(init_start)
                    state_rd_cnt <= DDR3_DONE ;
                else
                    state_rd_cnt <= IDLE;
            end
            DDR3_DONE:begin
                if(axi_araddr_n <= app_addr_rd_max)
                    state_rd_cnt <= READ_ADDR;          
                else 
                    state_rd_cnt <= state_rd_cnt; 
            end             
            READ_ADDR:begin
                if(axi_arvalid && axi_arready)
                    state_rd_cnt <= READ_DATA;        
                else
                    state_rd_cnt <= state_rd_cnt;        
            end
            READ_DATA:begin
                if(axi_rlast)                     
                    state_rd_cnt <= DDR3_DONE;     
                else
                    state_rd_cnt <= state_rd_cnt;        
            end
            default:begin
                state_rd_cnt <= IDLE;
            end
        endcase
    end
end


endmodule