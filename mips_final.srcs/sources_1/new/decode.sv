
// falta multiplexor para wa3

module decode 
    #(parameter N = 32)
    (input logic regWrite, clk,
    input logic [1:0] regDst,
	input logic [4:0] wa3,
	input logic [4:0] debug_read_addr,
    input logic [N-1:0] PC, writeData3, instr,
	output logic [N-1:0] signExt, readData1, readData2, PCBranch,
    output logic [31:0] debug_read_data
	);		
	
	logic [N-1:0] adder_a, adder_b;

	                                                       // read address rs **** read address rt
	regfile 		registers(.clk(clk), .we3(regWrite), .ra1(instr[25:21]), .ra2(instr[20:16]), .wa3(wa3), 
								.wd3(writeData3), .rd1(readData1), .rd2(readData2),
								.debug_read_addr(debug_read_addr), .debug_read_data(debug_read_data));
									
	signext 		ext		(.a(instr[15:0]), .result(signExt));	
	
	adder #(N) Add(adder_a, adder_b, PCBranch);

	always_comb
    begin
      adder_a = PC;
      adder_b = signExt << 2;
	end

endmodule