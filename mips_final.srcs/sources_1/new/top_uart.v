`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2021 05:34:05 PM
// Design Name: 
// Module Name: top_uart
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


module top_uart(

    input i_clock, i_reset, rx_top, dtx_ready,
    input [7:0] dtx,
    output tx_top, rx_done,
    output [7:0] drx
    );
    
    //Baud rate I/Os
    wire tick;

    // DUT instantiation 
    baud_rate baud_dut (.i_clock(i_clock),.tick(tick));
    Tx tx_dut (.i_clock(i_clock),.i_reset(i_reset),.tick(tick),.tx(tx_top),.din(dtx),.din_ready(dtx_ready));
    Rx rx_dut (.i_clock(i_clock),.i_reset(i_reset),.tick(tick),.rx(rx_top),.dout(drx),.rx_done(rx_done));
    
endmodule