`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuechuan Xue
// 
// Create Date: 2015/07/11 09:36:50
// Design Name: 
// Module Name: Stack
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

module Stack (
	input clk,
	input push,
	input pop,
	input [8:0] in,
	output out
	);

	//									 ---------------
	//									|	 Stack  2	| <-- 
	//									 ---------------	  ^  push
	//	in 	=	Stack_1_next 	=>		|	 Stack  1	| --> ^
	//	   push				push||pop	 ---------------
	//										   ||
	//										   out

	// PUSH:
	//			in =  Stack_1 => Stack_2
	// POP:
	//			Stack_2 => Stack_1 = out
	// OTHER:
	//			Stack_1 = out

	reg		[8:0] Stack_1, Stack_2;

	wire	[8:0] Stack_1_next = push ? in : Stack_2;

	always @(posedge clk) begin
		if (push || pop) 	Stack_1 <= Stack_1_next;
		else  				Stack_1 <= Stack_1;
	end

	always @(posedge clk) begin
		if (push)	Stack_2 <= Stack_1;
		else 		Stack_2 <= Stack_2; 
	end

	assign out = Stack_1;

endmodule