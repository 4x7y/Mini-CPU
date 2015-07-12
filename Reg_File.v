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

//Í¬²½Ð´£¬Òì²½¶Á
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
    input [7:0] PCLl,
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
    wire    PCL_wr      = f_wr & (f_adrs ==    PCL_adrs);
    wire    STATUS_wr   = f_wr & (f_adrs == STATUS_adrs);
    wire    FSR_wr      = f_wr & (f_adrs ==    FSR_adrs);
    wire    PORTA_wr    = f_wr & (f_adrs ==  PORTA_adrs);
    wire    PORTB_wr    = f_wr & (f_adrs ==  PORTB_adrs);

    
    
    
endmodule
