`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 00:00:59
// Design Name: 
// Module Name: Adder8
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


module Adder8(
    input   [7:0]   op_A,
    input   [7:0]   op_B,
    input   [1:0]   op_mux,     // 0: add , 1: sub , 2: inc , 3: dec
    input           sub,
    output  [7:0]   Sum,
    output          C,
    output          DC
    );
    
    wire [7:0] op_B_tmp;
    
    assign op_B_tmp = op_mux[1] ? ((op_mux[0]) ? 8'hff : 8'h01) : ((op_mux[1]) ? ~op_B : op_B);   // dec, inc, sub, add
    
    wire [4:0] Sum_L = {1'b0, op_A[3:0]} + {1'b0, op_B_tmp [3:0]} + sub;
    wire [8:4] Sum_H = {1'b0, op_A[7:4]} + {1'b0, op_B_tmp[7:4]} + Sum_L[4];
    
    assign Sum = {Sum_H[7:4], Sum_L[3:0]};
    assign C   =  Sum_H[8];
    assign DC  =  Sum_L[4];

endmodule
