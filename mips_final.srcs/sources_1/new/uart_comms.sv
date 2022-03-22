`timescale 1ns / 1ps

module uart_comms
  (input logic clk,
   input logic reset,
   input logic rx, // cable rx
   output logic [7:0]dout); // info para imem
   
   logic tick;
   logic rx_done;
   
   baud_rate baud_dut (.i_clock(clk),.tick(tick));
   Rx rx_dut (.i_clock(clk),.i_reset(reset),.tick(tick),.rx(rx),.dout(dout),.rx_done(rx_done));
   
endmodule