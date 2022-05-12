
// falta multiplexor para wa3

module decode 
    #(parameter N = 32)
    (input logic regWrite, clk,
    input logic [1:0] regDst,
    input logic [N-1:0] writeData3, instr,
	output logic [N-1:0] signExt, readData1, readData2 
	);		
	
	logic [4:0] wa3;
				         // rt          // rd          // jalr default
	mux4 #(5)       mux(instr[20:16], instr[15:11], 5'd31, 0, regDst, wa3);
	                                                       // read address rs **** read address rt
	regfile 		registers(.clk(clk), .we3(regWrite), .ra1(instr[25:21]), .ra2(instr[20:16]), .wa3(wa3), 
								 .wd3(writeData3), .rd1(readData1), .rd2(readData2));
									
	signext 		ext		(.a(instr[15:0]), .result(signExt));	
	
endmodule