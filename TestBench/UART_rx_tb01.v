`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 14:21:37
// Design Name: 
// Module Name: UART_rx_tb01
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


module UART_rx_tb01;

	// Inputs
	reg rst;
	reg clk;
	reg rxd_in;
	reg read;

	// Outputs
	wire [7:0] data_out;
	wire new_data;

	// Instantiate the Unit Under Test (UUT)
	UART_rx uut (
		.rst(rst), 
		.clk(clk), 
		.rxd_in(rxd_in), 
		.read(read), 
		.data_out(data_out), 
		.new_data(new_data)
	);


   parameter  Frqz = 1302;      // 50,000/38.4

   parameter tp = 10;                // clk cycle for 100 MHz
   parameter dlt = 0.02*tp;

	initial begin
		// Initialize Inputs
		rst = 1;
		clk = 0;
		rxd_in = 1;
		read = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        #(0.5*tp);
        #dlt;
        rst = 0;

        #(10*tp);
		rxd_in = 0;
		
        #(600*tp);
        rxd_in = 1;

        #(100*tp);
        rxd_in = 0;
        
        #(Frqz*8.5*tp);
        rxd_in = 1;

        #((Frqz/2+10)*tp);
        read = 1;
        #tp;
        read = 0;
	end


 	always
		#(tp/2) clk = ~clk;  // generating clk

    initial #(30000*tp) $stop;

endmodule
