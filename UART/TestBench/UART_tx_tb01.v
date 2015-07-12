`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 14:14:37
// Design Name: 
// Module Name: UART_tx_tb01
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_tx_tb01;

    // Inputs
	reg rst;
	reg clk;
	reg load;
	reg [7:0] data_in;

	// Outputs
	wire txd_out;
	wire busy;

	// Instantiate the Unit Under Test (UUT)
	UART_tx uut (
		.rst(rst), 
		.clk(clk), 
		.load(load), 
		.data_in(data_in), 
		.txd_out(txd_out), 
		.busy(busy)
	);

   parameter tp = 10;                // clk cycle for 100 MHz
   parameter dlt = 0.02*tp;

	initial begin
		// Initialize Inputs
		rst = 1;
//		rst = 0;
		clk = 0;
		load = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
      #(0.5*tp);
      #dlt;
		rst = 0;
      #(10*tp);
//
      load = 1;
      data_in = 8'h55;
      #tp;
      load = 0;
//
      #(1302*9*tp);
      load = 1;
      data_in = 8'hcc;
      #tp;
      load = 0;
	end

 	always  #(tp/2) clk = ~clk;  // generating clk

    initial #(3200*tp) $stop; // Stop Simulate
    
endmodule
