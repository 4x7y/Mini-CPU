`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/08 23:30:47
// Design Name: 
// Module Name: Shift8
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


module Shift8(
    input           C_in,
    input   [7:0]   oprd,
    input           rlf_n_rrf,      // 0: rrf , 1: rlf
    output  [7:0]   S_out,
    output          C_out
    );
    
assign {C_out, S_out} = rlf_n_rrf ? {oprd, C_in} : {oprd[0], C_in, oprd[7:1]};

endmodule
