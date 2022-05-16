import common::*;

// IF-ID
`define IF_ID_WIDTH 63:0
`define IF_ID_PCPLUS4 31:0
`define IF_ID_INSTRUCTION 63:32
`define IF_ID_OPCODE 63:58
`define IF_ID_RTYPEFUNC 37:32
`define IF_ID_SHAMT 42:38
`define IF_ID_RD 47:43
`define IF_ID_RT 52:48

// ID-EX
`define ID_EX_WIDTH 155:0
`define ID_EX_SHAMT 4:0
`define ID_EX_RD 9:5
`define ID_EX_RT 14:10
`define ID_EX_READDATA2 46:15
`define ID_EX_READDATA1 78:47
`define ID_EX_READDATA1 110:79
`define ID_EX_PCPLUS4 142:111
`define ID_EX_REGDST 144:143
`define ID_EX_MEM2REG 146:145
`define ID_EX_MEMREAD 147
`define ID_EX_MEMWRITE 148
`define ID_EX_REGWRITE 149
`define ID_EX_ALUSRC 150
`define ID_EX_ALUCTL 154:151
`define ID_EX_BRANCH 155

// MEM-WB
`define MEM_WB_WIDTH nose
`define MEM_WB_WA3 4:0



// DATAPATH
module datapath #(parameter N = 32)
					(input logic reset, clk,
					input logic [`WIDTH_CTL_BUS] ctl,									
					input logic [N-1:0] instruction,
					output logic [N-1:0] imem_addr,
                    output logic [5:0] opcode, func); // opcode and func used in control unit 				
					
    logic PCSrc;
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
	logic [N-1:0] signExt_D, readData1_D, readData2_D;
	logic [4:0] wa3;
	logic zero_E;
	logic [`IF_ID_WIDTH] qIF_ID;
	logic [`ID_EX_WIDTH] qID_EX;
	logic [202:0] qEX_MEM;
	logic [134:0] qMEM_WB;
	
	fetch 	FETCH 	(.PCSrc(PCSrc),
                    .clk(clk),
                    .reset(reset),
                    .PCBranch(qEX_MEM[197:134]),   // TODO: y aca que wey
                    .imem_addr(imem_addr));								
					
	
	flopr 	#(64)		IF_ID 	(.clk(clk),
                                .reset(reset), 
                                .d({instruction, imem_addr}),
                                .q(qIF_ID));

    assign opcode = qIF_ID[`IF_ID_OPCODE]
    assign func = qIF_ID[`IF_ID_RTYPEFUNC]
	

	decode  DECODE 	(.clk(clk),	
					.regWrite(qMEM_WB[134]),  // TODO: regWrite salida de wb
					.regDst(ctl[`CTL_REGDST]),
					.writeData3(writeData3),
					.instr(qIF_ID[`IF_ID_INSTRUCTION]),
					.wa3(qMEM_WB[`MEM_WB_WA3]), // instruccion que sale de wb flopr	
					.signExt(signExt_D), 
					.readData1(readData1_D),
					.readData2(readData2_D));		
																									
									
	flopr 	#(271)	ID_EX 	(.clk(clk),
							.reset(reset), 
							.d({ctl[`CTL_BRANCH], ctl[`CTL_ALUCTL], ctl[`CTL_ALUSRC], ctl[`CTL_REGWRITE], ctl[`CTL_MEMWRITE], 
								ctl[`CTL_MEMREAD], ctl[`CTL_MEM2REG],	ctl[`CTL_REGDST], 
								qIF_ID[`IF_ID_PCPLUS4], signExt_D, readData1_D, readData2_D, qIF_ID[`IF_ID_RT], 
								qIF_ID[`IF_ID_RD], qIF_ID[`IF_ID_SHAMT]}),
							.q(qID_EX));
	
	// hasta aca								
	execute  EXECUTE 	(.AluSrc(qID_EX[270]),
										.AluControl(qID_EX[269:266]),
										.PC_E(qID_EX[260:197]), 
										.signImm_E(qID_EX[196:133]), 
										.readData1_E(qID_EX[132:69]), 
										.readData2_E(qID_EX[68:5]), 
										.PCBranch_E(PCBranch_E), 
										.aluResult_E(aluResult_E), 
										.writeData_E(writeData_E), 
										.zero_E(zero_E));											
											
	mux4 #(5)       mux(qID_EX[`ID_EX_RT], qID_EX[`ID_EX_RD], 5'd31, 0, qID_EX[`ID_EX_REGDST], wa3);
									
	flopr 	#(203)	EX_MEM 	(.clk(clk),
										.reset(reset), 
										.d({qID_EX[265:261], PCBranch_E, zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
										.q(qEX_MEM));	

										
	memory				MEMORY	(.Branch_W(qEX_MEM[202]), 
										.zero_W(qEX_MEM[133]), 
										.PCSrc_W(PCSrc));
			
	
	// Salida de señales a Data Memory
	assign DM_writeData = qEX_MEM[68:5];
	assign DM_addr = qEX_MEM[132:69];
	
	// Salida de señales de control:
	assign DM_writeEnable = qEX_MEM[200];
	assign DM_readEnable = qEX_MEM[201];
	
	flopr 	#(135)	MEM_WB 	(.clk(clk),
										.reset(reset), 
										.d({qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, qEX_MEM[4:0]}),
										.q(qMEM_WB));
	
	
	writeback #(64) 	WRITEBACK (.aluResult_W(qMEM_WB[132:69]), 
										.DM_readData_W(qMEM_WB[68:5]), 
										.memtoReg(qMEM_WB[133]), 
										.writeData3_W(writeData3));		
		
endmodule
