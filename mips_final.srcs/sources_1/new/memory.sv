module memory
    (input logic  clk, memWrite, memRead, memSign,
    input logic [1:0] memWidth,
    input logic [31:0] aluResult, writeData,
    input logic [31:0] debug_read_addr,
    output logic [31:0] debug_read_data,
    output logic PCSrc,
	output logic [31:0] readData
	);	
    
    
    dmem dataMemory(.clk(clk), .memWrite(memWrite), .memRead(memRead), .memSign(memSign),
                    .memWidth(memWidth),.memAddr(aluResult), .writeData(writeData), .readData(readData),
                    .debug_read_addr(debug_read_addr), .debug_read_data(debug_read_data));
    
endmodule
