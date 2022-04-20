
module decode 
    #(parameter N = 64)
    (input logic regWrite, clk,
    input logic [N-1:0] writeData3,
	input logic [31:0] instr,
	output logic [N-1:0] signImm_D, readData1_D, readData2_D, 
	input logic [4:0] wa3_D);		
	
	                                                       // read address rs **** read address rt
	regfile 		registers(.clk(clk), .we3(regWrite_D), .ra1(instr_D[25:21]), .ra2(instr_D[20:16]), .wa3(wa3_D), 
								 .wd3(writeData3_D), .rd1(readData1_D), .rd2(readData2_D));
									
	signext 		ext		(.a(instr_D), .y(signImm_D));	
	
endmodule