`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 15:21:29
// Design Name: 
// Module Name: UART_test
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


module UART_test;

    // Inputs
	reg rst;               // Share
	reg clk;               // Share
	reg load;              // TX (load message)
	reg [7:0] data_in;     // TX (transmit data)
    //reg rxd_in;            // RX (get 1 bit new data from cable)
    reg read;              // RX (respond to the new data)
    
	// Outputs

    wire [7:0] data_out;   // TX
    wire new_data;	        // TX
	//wire txd_out;          // RX
	wire busy;             // RX
	
	wire cable;            // Share
    

	// Instantiate the Unit Under Test (UUT)
	UART_rx rx_uut (
		.rst(rst), 
		.clk(clk), 
		.rxd_in(cable), 
		.read(read), 
		.data_out(data_out), 
		.new_data(new_data)
	);
	
    // Instantiate the Unit Under Test (UUT)
    UART_tx tx_uut (
        .rst(rst), 
        .clk(clk), 
        .load(load), 
        .data_in(data_in), 
        .txd_out(cable), 
        .busy(busy)
    );
    
    parameter Frqz = 1302;            // 50,000/38.4
    parameter tp   = 10;              // clk cycle for 100 MHz
    parameter dlt  = 0.02*tp;
    
    initial begin
        // Initialize Inputs
        rst = 1;
        clk = 0;
        //rxd_in = 1;
        read = 0;
        load = 0;
    
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        #100
        rst = 0;
        
        #tp
        data_in = 8'b10111001;
        #tp
        load = 1;
        #100000
        data_in = 8'b10001110;
        
        #50000
        read = 1;    
    end

 	always #(tp/2) clk = ~clk;  // generating clk
    initial #(30000*tp) $stop;
    
endmodule
