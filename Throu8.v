`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/08 23:41:55
// Design Name: 
// Module Name: Throu8
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


module Throu8(
    input   [7:0]   oprd,
    input           clr,                // 0x00 ->  T_ou
    input           swap_n_mov,         // 0: oprd -> T_out ; 1: {oprd[3:0], oprd[7:4]} -> T_out
    output  [7:0]   T_out
    );
    
    assign T_out = clr ? 8'h00: (swap_n_mov ? {oprd[3:0], oprd[7:4]} : oprd);
    
endmodule
