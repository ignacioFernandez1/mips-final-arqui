`timescale 1ns / 1ps

module writeback #(parameter N = 32)
					(input logic [N-1:0] aluResult, dmemReadData,
					input logic [1:0] memtoReg,
					input [N-1:0] pcPlus4,
					output logic [N-1:0] writeData3);					
	
	mux4 #(N) wbmux (.d0(aluResult), .d1(dmemReadData), .d2(pcPlus4), .d3(32'b0), .s(memtoReg), .y(writeData3));
	
endmodule

