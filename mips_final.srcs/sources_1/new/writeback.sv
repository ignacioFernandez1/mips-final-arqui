`timescale 1ns / 1ps

module writeback #(parameter N = 32)
					(input logic [N-1:0] aluResult, dmemReadData,
					input logic memtoReg,
					output logic [N-1:0] writeData3);					
	
	mux2 wbmux (.d0(aluResult), .d1(dmemReadData), .s(memtoReg), .y(writeData3));
	
endmodule

