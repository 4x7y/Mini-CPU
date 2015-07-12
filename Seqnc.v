`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/12 11:18:00
// Design Name: 
// Module Name: Seqnc
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
module Seqnc(
    input rst,
    input [11:0] Instr,
    input [8:0] PC,
    input [7:0] f_in_data,
    input PCL_wr,
    input Z,
    output [7:0] PCL1,
    output reg [8:0] PC_next,
    output reg push,
    output reg pop,
    output [8:0] stack_psh,
    input [8:0] stack_pop
    );

	parameter rst_cvt = 9'b111111111;

	wire [7:0]	K8 = Instr[7:0];
	wire [8:0]	K9 = Instr[8:0]; // 9 instant number

	wire		ONE = 1'b1;
	wire		TWO = 2'b10;
	wire [8:0]	PC_plus2, PC_plus;

	assign PC_plus2 = PC + TWO;
	assign PC_plus 	= PC + ONE;
	assign PCL1		= PC_plus [7:0];

	always @(rst, Instr, Z, K9, K8, stack_pop, PC_plus2, PCL_wr, f_in_data, PC_plus) begin
		if (rst) begin
			//reset
			{PC_next, push, pop} <= {rst_cvt, 1'b0, 1'b0};
			
		end
		else casex ({Instr[11:6], Z})
			7'b101????: {PC_next, push, pop} <=			{K9, 1'b0, 1'b0};	// GOTO:	101k kkkk kkkk 无条件跳转，可访问全部程序存储器 (2^9 = 512)
			7'b1001???: {PC_next, push, pop} <=	{{1'b0, K8}, 1'b1, 1'b0};	// CALL:	1001 kkkk kkkk 调用子程序，可访问前一般程序存储器 (2^8 = 256)
			7'b1000???: {PC_next, push, pop} <= {stack_pop,  1'b0, 1'b1};	// RETLW:	1000 kkkk kkkk 返回并将立即数传送到 W
			7'b0111??0,														// BTFSS:	0111 bbbf ffff 检测 Reg_file(f ffff) 中的 bbb 位，为 1 (Z = 0) 则跳过
			7'b0110??1,														// BTFSC:	0110 bbbf ffff 检测 Reg_file(f ffff) 中的 bbb 位，为 0 (Z = 1) 则跳过
			7'b0011111,														// INCFSZ:	0011 11df ffff f 增 1，为 0 (Z = 1) 则跳过
			7'b0010111: {PC_next, push, pop} <=	{PC_plus2,   1'b0, 1'b0};	// DECFSZ:	0010 11df ffff f 减 1，为 0 (Z = 1) 则跳过
			   default:
			   			if (PCL_wr) {PC_next, push, pop} <= {{1'b0, f_in_data}, 1'b0, 1'b0};
			   			else 		{PC_next, push, pop} <= {		   PC_plus, 1'b0, 1'b0};
		endcase
	end

    assign stack_psh = PC_plus;

endmodule