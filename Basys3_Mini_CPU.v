`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 14:28:27
// Design Name: 
// Module Name: Basys3_Mini_CPU
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

module Basys3_Mini_CPU(

    );
    
    reg        rst;
    reg        clk;
    reg  [3:0] porta_in;
    reg  [7:0] portb_in;
    wire [3:0] porta_out;
    wire [7:0] portb_out;
    wire [3:0] porta_tris;
    wire [7:0] portb_tris;

    reg        wdtmr;
    reg        tmr0_inc;
    wire [7:0] option_out;
 
 	PIC16F54   PIC16F54_01(
    .rst(rst),
    .clk(clk),
    .porta_in(porta_in),
    .portb_in(portb_in),
    .porta_out(porta_out),
    .portb_out(portb_out), 
    .porta_tris(porta_tris),
    .portb_tris(portb_tris),
    .wdtmr(wdtmr),
    .tmr0_inc(tmr0_inc),
    .option_out(option_out)
    );
    
 	always #(tp/2) clk = ~clk;  // generating clk
    initial #(30000*tp) $stop;

    initial begin
    	rst = 1;
    	clk = 0;
    	porta_in = 4'b0000;
    	portb_in = 8'b00000000;
    	wdtmr = 0;
    	tmr0_inc = 0;

    	# 100
    	
    end
    
    


endmodule

