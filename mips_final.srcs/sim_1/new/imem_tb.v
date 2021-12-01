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
          #100;
          $display("\t%h: \t%h", addr, q);
          addr++;
          //if (addr == 0) $finish;
          
      end 

    initial 
      begin
        addr = 6'b000000;
        i = 32'hf8000000;
         
        $display("ROM Memmory:");
        
      end
endmodule
 
