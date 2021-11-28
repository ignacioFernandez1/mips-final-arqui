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

    input wire i_clock,
    input wire i_reset,
    input wire rx_top,
    output wire tx_top
    
    );
    
    //Baud rate I/Os
    wire tick;

    //Rx I/Os
    wire [7:0] dout;
    wire rx_done;
    // wire rx; 
    
    //Tx I/Os
    //wire tx;
    wire [7:0] din;
    wire din_ready; 
    
    //intf I/Os
   
    wire [7:0]data0; 
    wire [7:0]data1; 
    wire [5:0]code;
    
    //ALU I/Os           
    wire [7:0]out;    


    // DUT instantiation 
    baud_rate baud_dut (.i_clock(i_clock),.tick(tick));
    
    intf intf_dut (.i_clock(i_clock),.i_reset(i_reset),.data(dout),.data_ready(rx_done),.alu_result(out),.data0(data0),.data1(data1),.code(code),.dout(din),.dout_ready(din_ready));
  
    Tx tx_dut (.i_clock(i_clock),.i_reset(i_reset),.tick(tick),.tx(tx_top),.din(din),.din_ready(din_ready));
    
    Rx rx_dut (.i_clock(i_clock),.i_reset(i_reset),.tick(tick),.rx(rx_top),.dout(dout),.rx_done(rx_done));
    
    alu #(.N_BITS(8)) alu_dut (.d0(data0), .d1(data1), .opcode(code), .out(out));
    
endmodule