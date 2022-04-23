`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2022 07:42:46 PM
// Design Name: 
// Module Name: decode_tb
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


module decode_tb();
logic regWrite, clk;
logic [31:0] wd, instr, signExt, readData1, readData2;
logic [4:0] wa3;
		
decode dec(regWrite, clk, wd, instr, signExt, 
readData1, readData2, wa3);

 initial begin
    
    end


endmodule
