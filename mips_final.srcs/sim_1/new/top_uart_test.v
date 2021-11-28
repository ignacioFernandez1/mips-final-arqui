`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2021 05:44:10 PM
// Design Name: 
// Module Name: top_uart_test
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


module top_uart_test;

    //Baud rate I/Os
    reg i_clock = 1;
    reg i_reset = 0;
    wire tick;

    //Tx I/Os
    wire tx;
    reg [7:0] din;
    reg din_ready;
    
    //Rx I/Os
    wire [7:0] dout;
    wire rx_done;
    //wire rx; 
    
    wire tx_top;     

    // DUT instantiation 
    baud_rate baud_dut (.i_clock(i_clock),.tick(tick)); 
    Tx tx_dut (.i_clock(i_clock),.i_reset(i_reset),.tick(tick),.tx(tx),.din(din),.din_ready(din_ready));
    Rx rx_dut (.i_clock(i_clock),.i_reset(i_reset),.tick(tick),.rx(tx_top),.dout(dout),.rx_done(rx_done));
        
    top_uart top_dut (.i_clock(i_clock),.i_reset(i_reset),.tx_top(tx_top),.rx_top(tx));
    
    initial begin
        // SUMA
        #1000;
        din = 8'b00000001;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000
        din = 8'b00000010;
        din_ready = 1;
        #1000;
        din_ready = 0;
        #200000
        din = 8'b00100000;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000   
        
        
        // RESTA
        din = 15;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000
        din = 10;
        din_ready = 1;
        #1000;
        din_ready = 0;
        #200000
        din = 8'b00100010;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000   
        
        // NOR
        din = 8'b11110000;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000
        din = 8'b11001100;
        din_ready = 1;
        #1000;
        din_ready = 0;
        #200000
        din = 8'b00100111;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000   
        
        // AND
        din = 8'b00010111;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000
        din = 8'b11111011;
        din_ready = 1;
        #1000;
        din_ready = 0;
        #200000
        din = 8'b00100100;
        din_ready = 1;            
        #1000;
        din_ready = 0;
        #200000   
        $finish;
    end        


    always 
        #50 i_clock = ~i_clock;    

endmodule