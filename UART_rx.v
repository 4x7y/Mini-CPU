`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/07/09 10:33:42
// Design Name: 
// Module Name: UART_rx
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


module UART_rx(
    input rst,
    input clk,
    input rxd_in,
    input read,
    output [7:0] data_out,
    output new_data
    );
    
//
    ////////////////////////////////////////////////////////////////////////////////
    //
       reg        flag;
       reg  [3:0] state;
       reg [10:0] cntr;
       reg  [7:0] RXD;
       reg  [7:0] Dout;
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
       parameter ERROR = 12;
    //
       parameter  Dprs = 8'b11111111;
    //
       parameter  Frqz = 1302;      // 50,000/38.4
    
       wire   wrap2, wrap;
       assign wrap2 = (cntr == Frqz/2-1);
       assign wrap  = (cntr == Frqz  -1);
    //
    ////////////////////////////////////////////////////////////////////////////////
    //

    always @(posedge clk)
        if(rst) begin
            state <= IDLE;
            cntr  <= 0;
            RXD   <= Dprs; // 8'b11111111 -> RXD
        end
        else begin
            case(state)
                IDLE: begin
                        RXD  <= RXD;
                        if (rxd_in) begin
                            state <= state;
                            cntr <= 0;
                        end
                        else begin
                            state <= state + 1;
                            cntr  <=  cntr + 1;
                        end
                      end
                START: begin
                         RXD  <= RXD;
                         if(!wrap2) begin
                            state <= state;
                            cntr <= cntr + 1;
                         end
                         else begin
                             cntr <= 0;
                             if (rxd_in) state <= IDLE;
                             else state <= state + 1;
                             end
                         end
                 BIT0,   
                 BIT1,
                 BIT2,
                 BIT3,
                 BIT4,
                 BIT5,
                 BIT6,
                 BIT7:   begin
                            if (!wrap) begin
                                state <= state;
                                cntr  <= cntr + 1;
                                 RXD <= RXD;
                            end
                            else begin
                                    state <= state + 1;
                                    cntr  <= 0;
                                    RXD  <= {rxd_in, RXD[7:1]}; // rxd_in111 1111 -> RXD 
                            end
                          end
                 STOP: begin
                        RXD <= RXD;
                        if(!wrap) begin
                            state <= state;
                            cntr <= cntr + 1;
                        end
                        else begin
                                cntr <= 0;
                                if (rxd_in) state <= state + 1;
                                else        state <= ERROR;
                        end
                      end
                 NXTB: begin
                            state <= IDLE;
                            cntr  <= 0;
                              RXD <= RXD;
                       end
                 ERROR: begin
                            RXD <= RXD;
                            if(!wrap2) begin
                                state <= state;
                                cntr <= cntr + 1;
                            end
                            else begin
                                state <= IDLE;
                                 cntr <= 0;
                            end
                        end
                default:
                        begin
                            state <= IDLE;
                            cntr  <= 0;
                            RXD <= Dprs;
                        end
                endcase
           end
           
           wire   get_data;
           assign get_data = (state == NXTB); //RXTB
           
           always @(posedge clk) begin
                if (get_data) Dout <= RXD;
                else          Dout <= Dout;
           end
               
           assign data_out  = Dout;
           
           always @(posedge clk) begin
                if (rst) flag <= 1'b0;
                else begin
                    if (get_data) flag <= 1'b1;
                    else begin
                        if (read) flag <= 1'b0;
                        else      flag <= flag;
                    end
                end
           end
           
           assign new_data = flag;
           
endmodule
