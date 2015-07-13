`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuechuan Xue
// 
// Create Date: 2015/07/13 01:45:24
// Design Name: 
// Module Name: Reg_Misc
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


module Reg_Misc(
    input        rst,
    input        clk,
    input        TRISA_wr,
    input        TRISB_wr,
    input        OPTION_wr,
    input  [7:0] W,
    output reg [3:0] TRISA,
    output reg [7:0] TRISB,
    output reg [7:0] OPTION
    );
//
//////////////////////////////////////////////////////////////////////////////////
//
  always @(posedge clk)
     if (rst) TRISA <= 4'b1111;
     else begin
        if (TRISA_wr)	TRISA <= W[3:0];
        else	        TRISA <= TRISA;
     end

  always @(posedge clk)
     if (rst) TRISB <= 8'b11111111;
     else begin
        if (TRISB_wr)	TRISB <= W;
        else	        TRISB <= TRISB;
     end
//
  always @(posedge clk)
     if (rst) OPTION <= 8'b11111111;
     else begin
        if (OPTION_wr)	OPTION <= W;
        else	        OPTION <= OPTION;
     end

//////////////////////////////////////////////////////////////////////////////////
//
endmodule

