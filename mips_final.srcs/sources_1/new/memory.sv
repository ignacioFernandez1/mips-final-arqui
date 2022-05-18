module memory
    (input logic  clk, branch, zero, memWrite, memRead, 
    input logic [31:0] aluResult, writeData,
    output logic PCSrc,
	output logic [31:0] readData
	);	
    
    
    dmem dataMemory(.clk(clk), .memWrite(memWrite), .memRead(memRead), .memAddr(aluResult),
                    .writeData(writeData), .readData(readData));
    
    assign PCSrc = branch & zero;
    
endmodule
