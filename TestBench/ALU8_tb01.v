`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/13 14:15:45
// Design Name: 
// Module Name: ALU8_tb01
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


module ALU8_tb01;

	wire clr;
	wire swap_n_mov;
	wire rlf_n_rrf;
	wire [1:0] op_mux_l;
	wire [1:0] op_mux_a;
	wire sub;
	wire [1:0] out_mux;
	wire C_in;
	wire [7:0] op_A1;
	wire [7:0] op_B1;
	wire [7:0] op_A;
	wire [7:0] op_B;
	wire C_new;
	wire DC_new;
	wire Z_new;

	ALU8 ALU8_01(
		.clr(clr),					//         1: clr
		.swap_n_mov(swap_n_mov),	// 0: mov, 1: swap
		.rlf_n_rrf(rlf_n_rrf),		// 0: rrf, 1: rlf
		.op_mux_l(op_mux_l),		// 0: ior, 1: and, 2: xor, 3: comp  [Logic]
		.op_mux_a(op_mux_a),		// 0: add, 1: sub, 2: inc, 3: dec   [Adder]
		.sub(sub),
		.out_mux(op_mux),
		.C_in(C_in),
		.op_A1(op_A1),
		.op_B1(op_B1),
		.op_A(op_A),				//to the Logic8, Adder8 sub module
		.op_B(op_B),				//to the Logic8, Adder8 sub module
		
		.C_new(C_new),
		.DC_new(DC_new),
		.Z_new(Z_new)
	);

endmodule
