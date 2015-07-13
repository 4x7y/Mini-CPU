`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 09:19:05
// Design Name: 
// Module Name: Reg_File.v
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

//同步写，异步读
module Reg_File(
	input tmr0_inc,
	input C_en,
	input DC_en,
	input Z_en,
	input SLEEP,
	input CLRWDT,
	input wdtmr,
	input f_wr,
	input [4:0] f_adrs,
	input C_new,
	input DC_new,
	input Z_new,
	input [7:0] f_in_data,
	input [7:0] PCL1,
	input [3:0] porta_in,
	input [7:0] portb_in,
	input  reg [7:0] f_out_data,
	input  reg [7:0] PORTB,
	input  reg [7:0] PORTA,

	output reg [4:0] FSR,
	output reg       C,
	output reg       PCL_wr
	);
	
	parameter   INDF_adrs = 5'h00;      //      |        INDF        | (Virtual Address)
	parameter   TMR0_adrs = 5'h01;      //      |        TMR0        |
	parameter    PCL_adrs = 5'h02;      //      |         PCL        |
	parameter STATUS_adrs = 5'h03;      //      |       STATUS       |
	parameter    FSR_adrs = 5'h04;      //      |         FSR        |
	parameter  PORTA_adrs = 5'h05;      //      |        PORTA       |
	parameter  PORTB_adrs = 5'h06;      //      |        PORTB       |
	
	
	wire        Data_Space = (f_adrs[4:3] != 2'b00) || (f_adrs[2:0] == 3'b111);
													   // in the range of [7:31] -> Data_Space=1
	reg  [7:0]  TMR0;
	reg  [2:0]  PAn;
	reg         T0_N, PD_N, Z, DC;
	
	wire [7:0]  STATUS     = {PAn, T0_N, PD_N, Z, DC, C};
	
	wire [7:0]  data_out_RAM;
	
	Data_RAM     Data_RAM_01 (
	.clk(clk),
	.en_A(Data_Space),              //
	.wr_A(f_wr),
	.adrs_A(f_adrs),
	.data_in(f_in_data),
	.adrs_B(f_adrs),                // Same data bus
	.data_out(data_out_RAM)
	);
	
	wire    TMR0_wr     = f_wr & (f_adrs ==   TMR0_adrs);
	assign  PCL_wr      = f_wr & (f_adrs ==    PCL_adrs);
	wire    STATUS_wr   = f_wr & (f_adrs == STATUS_adrs);
	wire    FSR_wr      = f_wr & (f_adrs ==    FSR_adrs);
	wire    PORTA_wr    = f_wr & (f_adrs ==  PORTA_adrs);
	wire    PORTB_wr    = f_wr & (f_adrs ==  PORTB_adrs);

	always @(posedge clk)
		if (PORTA_wr)	PORTA <= f_in_data[3:0];
		else			PORTA <= PORTA;

	always @(posedge clk)
		if (PORTB_wr)   PORTB <= f_in_data;
		else			PORTB <= PORTB;

   always @(posedge clk)
		if (FSR_wr)		  FSR <= f_in_data[4:0];
		else			  FSR <= FSR;

	always @(posedge clk)
		if      (rst)           TMR0 <= 0;
		else if (TMR0_wr) 		TMR0 <= f_in_data;
		else if (tmr0_inc)   	TMR0 <= TMR0 + 1;
		else                    TMR0 <= TMR0;

	wire        PAn_wr    = STATUS_wr;
	wire [2:0]  PAn_next  = f_in_data[7:5];

	wire        TO_N_wr   = CLRWDT || SLEEP || wdtmr;
	wire        TO_N_next = CLRWDT || SLEEP;

	wire 		PD_N_wr   = CLRWDT || SLEEP;
	wire 		PD_N_next = CLRWDT;

	wire 		STT_en	  =  Z_en || DC_en || C_en;
	wire 		Z_wr	  =  Z_en || (!STT_en && STATUS_wr);
	wire  		DC_wr 	  = DC_en || (!STT_en && STATUS_wr);
	wire   		C_wr 	  =  C_en || (!STT_en && STATUS_wr);

	wire    	Z_next, DC_next, C_next;
	
	assign {Z_next, DC_next, C_next} = STT_en ? {Z_new, DC_new, C_new} : f_in_data[2:0];

	always @(posedge clk) begin
		if (rst)			PAn  <= 3'b000;
		else if (PAn_wr)	PAn  <= PAn_next;
		else 				PAn  <= PAn;
		
		if (rst)			TO_N <= 1'b1;
		else if (TO_N_wr)	TO_N <= TO_N_next;   
		else 				TO_N <= TO_N;

		if (rst) 			PD_N <= 1'b1;
		else if (PD_N_wr) 	PD_N <= PD_N_next;
		else 				PD_N <= PD_N;
		
		if (Z_wr) 			   Z <= Z_next;
		else 				   Z <= Z;
		
		if (DC_wr) 			  DC <= DC_next;
		else 				  DC <= DC;
		
		if (C_wr) 			   C <= C_next;
		else				   C <= C;                                        
	end

	always @(f_adrs, TMR0, PCL1, STATUS, FSR, porta_in, portb_in, data_out_RAM) begin
		case(f_adrs)
			5'b00000: f_out_data = 8'h00;
			5'b00001: f_out_data = TMR0;
			5'b00010: f_out_data = PCL1;
			5'b00011: f_out_data = STATUS;
			5'b00100: f_out_data = {3'b111,FSR};
			5'b00101: f_out_data = {4'b0000,porta_in};
			5'b00110: f_out_data = portb_in;
			default: f_out_data = data_out_RAM;
		endcase
	end
endmodule
