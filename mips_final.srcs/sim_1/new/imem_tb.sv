`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2021 07:25:26 PM
// Design Name: 
// Module Name: imem_tb
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


module imem_tb();
    reg [31:0] i;
    reg [5:0] addr;
    reg op; 
    wire [31:0] q;
    

    imem memi(i, addr, op, q);

  
   always
      begin
          #50;
          op = 1;
          $display("\t%h: \t%h", addr, q);
          addr++;
          if (addr == 6) addr = 0;
          
      end 

    initial 
      begin
        #1
        op = 0;
        addr = 2;
        i = 32'hf8000009;       
        #1
        addr = 3;
        i = 32'hf8000001;
        #1
        addr = 4;
        i = 32'hf8000002;
        #1 
        addr = 5;
        i = 32'hf8000003;
        #1
        addr = 0;
        op = 1;  
        $display("ROM Memmory:");
        
      end
endmodule
 
