module memory
    (input logic  clk, memWrite, memRead, memSign,
    input logic [1:0] memWidth,
    input logic [31:0] aluResult, writeData,
    output logic PCSrc,
	output logic [31:0] readData
	);	
    
    
    dmem dataMemory(.clk(clk), .memWrite(memWrite), .memRead(memRead), .memSign(memSign),
                    .memWidth(memWidth),.memAddr(aluResult), .writeData(writeData), .readData(readData));
    
endmodule
