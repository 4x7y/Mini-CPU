`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:24:10 02/17/2012
// Design Name:   PIC16F54
// Module Name:   PIC16F54_tb01.v
// Project Name:  PIC18F97J60
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PIC16F54
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PIC16F54_tb01_v;

    // Inputs
    reg rst;
    reg clk;
    reg [3:0] porta_in;
    reg [7:0] portb_in;
//  reg [15:0] test_in;
   reg       wdtmr;
   reg       tmr0_inc;

    // Outputs
    wire [3:0] porta_out;
    wire [7:0] portb_out;
    wire [4:0] porta_tris;
    wire [7:0] portb_tris;
    wire [7:0] option_out;

    // Instantiate the Unit Under Test (UUT)
    PIC16F54 uut (
        .rst(rst), 
        .clk(clk), 
        .porta_in(porta_in), 
        .portb_in(portb_in), 
        .porta_out(porta_out), 
        .portb_out(portb_out), 
        .porta_tris(porta_tris), 
        .portb_tris(portb_tris), 
//      .test_in(test_in), 
        .wdtmr(wdtmr), 
        .tmr0_inc(tmr0_inc), 
        .option_out(option_out)
    );


   parameter tp = 10;                // clk cycle for 100 MHz
   parameter dlt = 0.01*tp;

    initial begin
        // Initialize Inputs
        rst = 1;
//      rst = 0;
        clk = 0;
        porta_in = 0;
        portb_in = 0;
//      test_in = 0;
        wdtmr = 0;
        tmr0_inc = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
      #dlt;
        rst = 0;
      #(0.5*tp);

    end

////////

    always
        #(tp/2) clk = ~clk;  // generating clk
///
///
initial #(10000*tp) $stop;
      
endmodule