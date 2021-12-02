`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2021 05:10:18 PM
// Design Name: 
// Module Name: io_file
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


module io_file();
   reg    clk;
   reg [8*32:0] data;
   integer   fd;
   integer   code, dummy;
   reg [8*32:0] str;
   
   initial begin
      fd = $fopen("input.dat","r"); 
      clk = 0;
      data = 0;
      code = 1;
      $monitor("data = %x", data);
      while (code) begin
         code = $fgets(str, fd);
         dummy = $sscanf(str, "%x", data);
         @(posedge clk);
      end
      $finish;
   end // initial begin
   always #5 clk = ~clk;
endmodule
