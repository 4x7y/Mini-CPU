`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/11 10:53:46
// Design Name: 
// Module Name: Basys3_IO_Test
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


module Basys3_IO_Test(
    input clk,
    input btnC,
    input btnL,
    input btnR,
    input [11:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [0:6] seg,
    output dp,
    output RsTx,
    input RsRx
    );
// 
//////////////////////////////////////////////////////////////////////////////////
//
   wire clk_in1 = clk;
   wire clk_out1;

  clk_wiz_0 inst
  (
 // Clock in ports
  .clk_in1(clk_in1),
  // Clock out ports  clk_wiz_0
  .clk_out1(clk_out1),
  // Status and control signals               
  .reset(1'b0), 
  .locked()            
  );
//
//////////////////////////////////////////////////////////////////////////////////
//
   wire reset_asyn_N = !btnC;
   wire clock        = clk_out1;
//
//////////////////////////////////////////////////////////////////////////////////
//
   reg           reset1, reset2;

always @(posedge clock or negedge reset_asyn_N)
   if (!reset_asyn_N) begin
      reset1 <= 1'b1;
   end else begin
      reset1 <= 1'b0;
   end

always @(posedge clock or negedge reset_asyn_N)
   if (!reset_asyn_N) begin
      reset2 <= 1'b1;
   end else begin
      reset2 <= reset1;
   end
//
//////////////////////////////////////////////////////////////////////////////////
//
   wire       new_data_wire;
   wire [4:0] testing_wire;
   wire [7:0] data_out_wire;
//
   wire busy_wire;
   wire read_n_load;
   assign read_n_load = !busy_wire && new_data_wire;
//
UART_rx  UART_rx_01
(
.rst(reset2),
.clk(clock),
.rxd_in(RsRx),
.read(read_n_load),
.testing(testing_wire),
.data_out(data_out_wire),
.new_data(new_data_wire)
);
//
//////////////////////////////////////////////////////////////////////////////////
//
UART_tx  UART_tx_01
(
.rst(reset2),
.clk(clock),
.load(read_n_load),
.data_in(data_out_wire),
.txd_out(RsTx),
.busy(busy_wire)
);
//
//////////////////////////////////////////////////////////////////////////////////
//
//   reg [7:0] data_ser;
//always @(posedge clock) data_ser <= {RsRx, data_ser[7:1]};
//   assign led = {RsRx, !RsRx, data_ser || data_out_wire};


   assign led = {RsRx, !RsRx, new_data_wire, testing_wire, data_out_wire};
//
   assign {seg, dp} = sw[7:0];
   assign an        = sw[11:8];

endmodule