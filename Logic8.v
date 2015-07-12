`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/08 23:50:09
// Design Name: 
// Module Name: Logic8
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


module Logic8(
    input   [7:0]   op_A,
    input   [7:0]   op_B,
    input   [1:0]   op_mux,     // 0: ior , 1: and , 2: xor , 3: comp
    output  [7:0]   Func
    );
    
    wire    [7:0]  Func_ior     = op_A | op_B;
    wire    [7:0]  Func_and     = op_A & op_B;
    wire    [7:0]  Func_xor     = op_A ^ op_B;
    wire    [7:0]  Func_comp    = -op_A;
    
    assign   Func = (op_mux[1]) ? (op_mux[0] ? Func_comp : Func_xor) : (op_mux[0] ? Func_and : Func_ior) ;
    
endmodule
