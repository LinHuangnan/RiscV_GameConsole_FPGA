// Created by IP Generator (Version 2022.1 build 99559)
// Instantiation Template
//
// Insert the following codes into your Verilog file.
//   * Change the_instance_name to your own instance name.
//   * Change the signal names in the port associations


ip_itcm the_instance_name (
  .wr_data(wr_data),    // input [63:0]
  .addr(addr),          // input [11:0]
  .wr_en(wr_en),        // input
  .clk(clk),            // input
  .rst(rst),            // input
  .rd_data(rd_data)     // output [63:0]
);
