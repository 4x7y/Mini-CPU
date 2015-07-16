`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:31:40 02/21/2012
// Design Name:   Decoder
// Module Name:   Decoder_tb01.v
// Project Name:  PIC18F97J60
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Decoder_tb01_v;

	// Inputs
	reg [11:0] Instr;

	// Outputs
	wire OPTION;
	wire SLEEP;
	wire CLRWDT;
	wire TRIS1;
	wire TRIS2;
	wire MOVWF;
	wire CLR;
	wire SUBWF;
	wire RLF;
	wire SWAPF;
	wire BTFSS;
	wire RETLW;
	wire CALL;
	wire GOTO;
	wire [7:0] bit_mask;
	wire Bit_Op;
	wire K8A_sel;
	wire K8W_sel;
	wire [1:0] Op_Mux_L;
	wire [1:0] Op_Mux_A;
	wire [1:0] ALU_out_Mux;
	wire FSZ;
	wire Z_en;
	wire DC_en;
	wire C_en;
	wire STT_en;
	wire Stack_1_wr;
	wire W_wr;
	wire f_wr;
	wire f_rd;

	// Instantiate the Unit Under Test (UUT)
	Decoder uut (
		.Instr(Instr), 
		.OPTION(OPTION), 
		.SLEEP(SLEEP), 
		.CLRWDT(CLRWDT), 
		.TRIS1(TRIS1), 
		.TRIS2(TRIS2), 
		.MOVWF(MOVWF), 
		.CLR(CLR), 
		.SUBWF(SUBWF), 
		.RLF(RLF), 
		.SWAPF(SWAPF), 
		.BTFSS(BTFSS), 
		.RETLW(RETLW), 
		.CALL(CALL), 
		.GOTO(GOTO), 
		.bit_mask(bit_mask), 
		.Bit_Op(Bit_Op), 
		.K8A_sel(K8A_sel), 
		.K8W_sel(K8W_sel), 
		.Op_Mux_L(Op_Mux_L), 
		.Op_Mux_A(Op_Mux_A), 
		.ALU_out_Mux(ALU_out_Mux), 
		.FSZ(FSZ), 
		.Z_en(Z_en), 
		.DC_en(DC_en), 
		.C_en(C_en), 
		.STT_en(STT_en), 
		.Stack_1_wr(Stack_1_wr), 
		.W_wr(W_wr), 
		.f_wr(f_wr), 
		.f_rd(f_rd)
	);


   parameter tp = 10;                // clk cycle for 100 MHz
   parameter dlt = 0.01*tp;

	initial begin
		// Initialize Inputs
		Instr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
////////

   reg clk = 0;
 	always
		#(tp/2) clk = ~clk;  // generating clk

   always @(posedge clk)
      Instr <= Instr + 1;
///
///
initial #(5000*tp) $stop;
      
endmodule

