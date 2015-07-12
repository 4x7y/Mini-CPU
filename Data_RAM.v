`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 09:08:31
// Design Name: 
// Module Name: Data_RAM
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


module Data_RAM(
    input clk,
    input en_A,
    input wr_A,
    input [4:0] adrs_A,
    input [7:0] data_in,
    input [4:0] adrs_B,
    output [7:0] data_out
    );
    
    reg [7:0] data_ram [31:7];
    
    always @(posedge clk) begin
        if (en_A)
            if (wr_A)
                data_ram[adrs_A] <= data_in;
    end
    
    assign data_out = data_ram[adrs_B];
    
endmodule
