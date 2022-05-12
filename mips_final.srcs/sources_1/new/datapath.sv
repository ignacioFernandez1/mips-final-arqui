import common::*;

`define IF_ID_WIDTH 63:0
`define IF_ID_PCPLUS4 31:0
`define IF_ID_INSTRUCTION 63:32
`define IF_ID_OPCODE 63:58
`define IF_ID_RTYPEFUNC 37:32

// DATAPATH
module datapath #(parameter N = 32)
					(input logic reset, clk,
					input logic [`WIDTH_CTL_BUS] ctl,									
					input logic [N-1:0] instruction_in,
					output logic [N-1:0] imem_addr,
                    output logic [5:0] opcode, func); // opcode and func used in control unit 				
					
    logic PCSrc;
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
	logic [N-1:0] signImm_D, readData1_D, readData2_D;
	logic zero_E;
	logic [`IF_ID_WIDTH] qIF_ID;
	logic [270:0] qID_EX;
	logic [202:0] qEX_MEM;
	logic [134:0] qMEM_WB;
	
	fetch 	FETCH 	(.PCSrc(PCSrc),
                    .clk(clk),
                    .reset(reset),
                    .PCBranch(qEX_MEM[197:134]),   // y aca que wey
                    .imem_addr_F(imem_addr));								
					
	
	flopr 	#(96)		IF_ID 	(.clk(clk),
                                .reset(reset), 
                                .d({imem_addr, instruction}),
                                .q(qIF_ID));

    assign opcode = qIF_ID[`IF_ID_OPCODE]
    assign func = qIF_ID[`IF_ID_RTYPEFUNC]
	
    // hasta aca llegamos jiji

	decode  DECODE 	(.regWrite_D(qMEM_WB[134]),
										.reg2loc_D(reg2loc), 
										.clk(clk),
										.writeData3_D(writeData3),
										.instr_D(qIF_ID[31:0]), 
										.signImm_D(signImm_D), 
										.readData1_D(readData1_D),
										.readData2_D(readData2_D),
										.wa3_D(qMEM_WB[4:0]));				
																									
									
	flopr 	#(271)	ID_EX 	(.clk(clk),
										.reset(reset), 
										.d({AluSrc, AluControl, Branch, memRead, memWrite, regWrite, memtoReg,	
											qIF_ID[95:32], signImm_D, readData1_D, readData2_D, qIF_ID[4:0]}),
										.q(qID_EX));	
	
										
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
