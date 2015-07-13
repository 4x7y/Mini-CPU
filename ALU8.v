`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/08 22:42:23
// Design Name: 
// Module Name: ALU8
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


module ALU8(
    input   clr,                //         1: clr
    input   swap_n_mov,         // 0: mov, 1: swap
    input   rlf_n_rrf,          // 0: rrf, 1: rlf
    input   [1:0] op_mux_l,     // 0: ior, 1: and, 2: xor, 3: comp  [Logic]
    input   [1:0] op_mux_a,     // 0: add, 1: sub, 2: inc, 3: dec   [Adder]
    input   sub,
    input   [1:0] out_mux,
    input   C_in,
    input   [7:0] op_A1,
    input   [7:0] op_B1,
    input   [7:0] op_A,         //to the Logic8 sub module only
    input   [7:0] op_B,         //to the Logic8 sub module only
    output  C_new,
    output  DC_new,
    output  Z_new
    );
    
    wire [7:0] T_out, S_out, Func, Sum;
    wire       C_out, C_wire;
    wire [7:0] ALU_out_buf;
    
    Throu8      Throu8_01(
    .oprd(op_A1),
    .clr(clr),                  // 0x00 ->  T_out
    .swap_n_mov(swap_n_mov),    // 0: oprd -> T_out ; 1: {oprd[3:0], oprd[7:4]} -> T_out
    .T_out(T_out)
    );
    
    
    Shift8      Shift8_01(
    .C_in(C_in),
    .oprd(op_A1),
    .rlf_n_rrf(rlf_n_rrf),      // 0: rrf , 1: rlf
    // Output
    .S_out(S_out),
    .C_out(C_out)
    ); 
    
    Logic8      Logic8_01(
    .op_A(op_A),
    .op_B(op_B),
    .op_mux(op_mux_l),     // 0: ior , 1: and , 2: xor , 3: comp
    .Func(Func)
    );
    
    
    Adder8      Adder8_01(
    .op_A(op_A),
    .op_B(op_B),
    .op_mux(op_mux_a),     // 0: add , 1: sub , 2: inc , 3: dec
    .sub(sub),
    .Sum(Sum),
    .C(C_wire),
    .DC(DC_new)
    );
    
    assign         C_new =   out_mux[1] ? C_wire : C_out;
    assign   ALU_out_buf =   out_mux[1] ? (out_mux[0] ? Sum : Func) : (out_mux[0] ? S_out : T_out);
    assign       ALU_out =   ALU_out_buf;
    assign         Z_new = ~|ALU_out_buf;
 
endmodule
