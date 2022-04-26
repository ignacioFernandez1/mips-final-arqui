module memory
    (input logic branch, clk, zero, MemWrite, MemRead, 
    input logic [31:0] aluResult, writeData,
    output logic PCSrc,
	output logic [31:0] readData
	);	
    
    
    dmem dataMemory(.clk(clk), .MemWrite(MemWrite), .MemRead(MemRead), .memAddr(aluResult),
                    .writeData(writeData), .readData(readData));
    
    assign PCSrc = branch & zero;
    
endmodule
