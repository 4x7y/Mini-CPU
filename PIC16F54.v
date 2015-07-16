`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuechuan Xue
// 
// Create Date: 2015/07/09 14:26:01
// Design Name: 
// Module Name: PIC16F54
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

module PIC16F54(rst, clk, porta_in, portb_in, porta_out, portb_out, 
				   porta_tris, portb_tris, wdtmr, tmr0_inc, option_out);

	input        rst;
	input        clk;
	input  [3:0] porta_in;
	input  [7:0] portb_in;
	output [3:0] porta_out;
	output [7:0] portb_out;
	output [3:0] porta_tris;
	output [7:0] portb_tris;

	input        wdtmr;
	input        tmr0_inc;
	output [7:0] option_out;

	reg        PCH;
	reg  [7:0] PCL;

	wire [8:0] PC;
	assign     PC = {PCH, PCL};

	wire [8:0] PC_next;
	wire [7:0] PCL1;
	wire       PCL_wr;

	wire       push, pop;
	wire [8:0] stack_psh, stack_pop;

	wire [11:0] Instr;

	wire [4:0] f5 = Instr[4:0];
	wire [7:0] K8 = Instr[7:0];

	parameter INDF_adrs = 5'b00000000;   // vitual address

	wire [4:0] f_adrs;
	wire [7:0] f_in_data;
	wire [7:0] f_out_data;

	wire [4:0] FSR;
	wire       C;
	wire       C_new, DC_new, Z_new;

	wire [7:0] op_A_wire, op_B_wire;
	wire [7:0] ALU_out;

	reg  [7:0] W;
	wire [7:0] W_next;

	wire		SLEEP, CLRWDT;
	wire		OPTION_wr, TRISA_wr, TRISB_wr;  
	wire		MOVWF, CLR, SUBWF, RLF, SWAPF;
	wire [7:0]	bit_mask;
	wire		Bit_Op, K8A_sel, K8W_sel;
	wire [1:0]	Op_Mux_L, Op_Mux_A, ALU_out_Mux;
	wire		Z_en, DC_en, C_en;
	wire		W_wr, f_wr;


	Seqnc  Seqnc_01
	(
		.rst(rst),
		.Instr(Instr),
		.PC(PC),
		.f_in_data(f_in_data),
		.PCL_wr(PCL_wr),
		.Z(Z_new),
		.PCL1(PCL1),
		.PC_next(PC_next),
		.push(push),
		.pop(pop),
		.stack_psh(stack_psh),
		.stack_pop(stack_pop)
	);

	Stack  Stack_01
	(
		.clk(clk),
		.push(push),
		.pop(pop),
		.in(stack_psh),
		.out(stack_pop)
	);

	// not sure ...
	always @(posedge clk) {PCH, PCL} <= PC_next;

	Prog_ROM  Prog_ROM_01
	(
		.clk(clk), 
		.adrs(PC_next), 
		.data(Instr)
	);

	Decoder  Decoder_01
	(
		// Input
		.Instr(Instr),
		// Output
		.OPTION(OPTION_wr),
		.SLEEP(SLEEP),
		.CLRWDT(CLRWDT),
		.TRIS1(TRISA_wr),
		.TRIS2(TRISB_wr),
		.MOVWF(MOVWF),
		.CLR(CLR), 
		.SUBWF(SUBWF), 
		.RLF(RLF),
		.SWAPF(SWAPF),
		.BTFSS(),         //not used here anymore
		.RETLW(),         //not used here anymore
		.CALL(),         //not used here anymore
		.GOTO(),         //not used here anymore
		.bit_mask(bit_mask),
		.Bit_Op(Bit_Op), 
		.K8A_sel(K8A_sel),
		.K8W_sel(K8W_sel),
		.Op_Mux_L(Op_Mux_L),        // 0: 或 	1: 与    	2: 异或  	3: 取反
		.Op_Mux_A(Op_Mux_A),        // 0: f加W	1: f减W  	2: f增1		3: f减1
		.ALU_out_Mux(ALU_out_Mux),  // 0: Throu	1: Shift	2: Logic	3: Adder
		.FSZ(),                  	// not used here anymore
		.Z_en(Z_en), 				// -> Reg_File
		.DC_en(DC_en),				// -> Reg_File
		.C_en(C_en),				// -> Reg_File
		.STT_en(),					// not used here anymore
		.Stack_1_wr(),				// not used here anymore
		.W_wr(W_wr),				// 
		.f_wr(f_wr),
		.f_rd()         			//not used here anymore
	);

//		   f_adrs == INDF_adrs		: Indirect Addressing
//		   f_adrs == 2'h01 ~ 2'hFF	: Direct Addressing 
	assign f_adrs = (f5 == INDF_adrs) ? FSR : f5;


	Reg_File  Reg_File_01 (
		// Input
		.rst(rst),
		.clk(clk),
		.tmr0_inc(tmr0_inc),
		.C_en(C_en),
		.DC_en(DC_en),
		.Z_en(Z_en),
		.SLEEP(SLEEP),
		.CLRWDT(CLRWDT),
		.wdtmr(wdtmr),
		.f_wr(f_wr),
		.f_adrs(f_adrs),
		.C_new(C_new),
		.DC_new(DC_new),
		.Z_new(Z_new),
		.f_in_data(f_in_data),
		.PCL1(PCL1),
		.porta_in(porta_in),
		.portb_in(portb_in),
		.f_out_data(f_out_data),
		.PORTB(portb_out),
		.PORTA(porta_out),
		// Output
		.FSR(FSR),
		.C(C),
		.PCL_wr(PCL_wr)
	);

	assign op_A_wire = K8A_sel ?		K8 : f_out_data;
	assign op_B_wire = Bit_Op  ?  bit_mask : W;

	ALU8  ALU8_01
	(
		.clr(CLR),
		.swap_n_mov(SWAPF),
		.rlf_n_rrf(RLF),
		.op_mux_l(Op_Mux_L),
		.op_mux_a(Op_Mux_A),
		.sub(SUBWF),
		.out_mux(ALU_out_Mux),
		.C_in(C),
		.op_A1(f_out_data),
		.op_B1(W),
		.op_A(op_A_wire),
		.op_B(op_B_wire),
		.ALU_out(ALU_out),
		.C_new(C_new),
		.DC_new(DC_new),
		.Z_new(Z_new)
	);
	
	assign f_in_data = MOVWF  ? W  : ALU_out;
	assign W_next	 = K8W_sel? K8 : ALU_out;

	always @(posedge clk)
    	if (W_wr)		W <= W_next;
    	else			W <= W;

	Reg_Misc  Reg_Misc_01
	(
		.rst(rst),
		.clk(clk),
		.TRISA_wr(TRISA_wr),
		.TRISB_wr(TRISB_wr),
		.OPTION_wr(OPTION_wr),
		.W(W),
		.TRISA(porta_tris),
		.TRISB(portb_tris),
		.OPTION(option_out)
	);

endmodule