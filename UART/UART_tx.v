`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 09:36:54
// Design Name: 
// Module Name: UART_tx
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



module UART_tx(
    input        rst,
    input        clk,
    input        load,
    input  [7:0] data_in,
    output       txd_out,
    output       busy
    );
    
//
////////////////////////////////////////////////////////////////////////////////
//
   reg 		  shift;
   reg  [3:0] state;
   reg [10:0] cntr;
   reg  [7:0] TXD;
   reg        Dout;
//   
   parameter  IDLE = 0;
   parameter START = 1;
   parameter  BIT0 = 2;
   parameter  BIT1 = 3;
   parameter  BIT2 = 4;
   parameter  BIT3 = 5;
   parameter  BIT4 = 6;
   parameter  BIT5 = 7;
   parameter  BIT6 = 8;
   parameter  BIT7 = 9;
   parameter  STOP = 10;
   parameter  NXTB = 11;
//
   parameter  Dprs = 8'b11111111;
//
   parameter  Frqz = 1302;      // 50,000/38.4

   wire   wrap;
   assign wrap = (cntr == Frqz-1);

    always @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
            TXD   <= Dprs;
            cntr  <= 0;
        end
        else begin
            case(state)
                IDLE:   begin
                            if (load) begin
                                state <= START;
                                TXD <= data_in;
                            end
                            else begin
                                state <= state;
                                TXD <= Dprs;
                            end
                            cntr <= 0;                                                            
                        end
                START,                           
                BIT0,
                BIT1,
                BIT2,
                BIT3,
                BIT4,
                BIT5,
                BIT6,
                BIT7:   begin
                            if (wrap) begin
                                state <= state + 1;
                                cntr  <= 0;
                            end
                            else begin
                                state <= state;
                                cntr  <= cntr + 1;
                            end
                            TXD <= TXD;
                        end
            
                // wrap = 0, cntr = 0, state = STOP
                STOP:   begin
                            if (load) begin
                                TXD <= data_in;
                                if (wrap) begin
                                    state <= START;
                                    cntr  <= 0;
                                end
                                else begin
                                    state <= state + 1;
                                    cntr  <= cntr + 1;
                                end
                             end
                             else begin
                                TXD <= Dprs;
                                if (wrap) begin
                                    state <= IDLE;
                                    cntr  <= 0;
                                end
                                else begin
                                    state <= state;
                                     cntr <= cntr + 1;
                                end
                            end
                        end
            
                NXTB:   begin
                            if (wrap) begin
                                state <= START;
                                cntr <= 0;
                            end
                            else begin
                                state <= state;
                                cntr  <= cntr + 1;
                            end
                                TXD <= TXD;
                        end
                default: begin
                            state <= IDLE;
                             cntr <= 0;
                              TXD <= Dprs;
                         end
            endcase
        end
    end

    always @(state)
        case (state)
            IDLE: shift <= 1'b0;
           START: shift <= 1'b1;
            BIT0: shift <= 1'b1;
            BIT1: shift <= 1'b1;
            BIT2: shift <= 1'b1; 
            BIT3: shift <= 1'b1;
            BIT4: shift <= 1'b1;
            BIT5: shift <= 1'b1;
            BIT6: shift <= 1'b1;
            BIT7: shift <= 1'b1;
            STOP: shift <= 1'b0;
            NXTB: shift <= 1'b1;
         default: shift <= 1'b0;
        endcase
        
    assign busy = shift;
    
    always @(state, TXD)
        case (state)
            IDLE: Dout <= 1'b1;
           START: Dout <= 1'b0;
            BIT0: Dout <= TXD[0];
            BIT1: Dout <= TXD[1];
            BIT2: Dout <= TXD[2];
            BIT3: Dout <= TXD[3];
            BIT4: Dout <= TXD[4];
            BIT5: Dout <= TXD[5];
            BIT6: Dout <= TXD[6];
            BIT7: Dout <= TXD[7];
            STOP: Dout <= 1'b1;
            NXTB: Dout <= 1'b1;
         default: Dout <= 1'b1;
        endcase
        
    assign txd_out = Dout;
    
endmodule
