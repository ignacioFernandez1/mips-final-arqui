// IF-ID
`define IF_ID_SIZE 64
`define IF_ID_WIDTH 63:0
`define IF_ID_PCPLUS4 31:0
`define IF_ID_INSTRUCTION 63:32
`define IF_ID_OPCODE 63:58
`define IF_ID_RTYPEFUNC 37:32
`define IF_ID_SHAMT 42:38
`define IF_ID_RD 47:43
`define IF_ID_RT 52:48
`define IF_ID_RS 57:53
`define IF_ID_TOPPCPLUS4 31:28
`define IF_ID_INSTIMM 57:32

// ID-EX
`define ID_EX_SIZE 165
`define ID_EX_WIDTH 164:0
`define ID_EX_SHAMT 4:0
`define ID_EX_RD 9:5
`define ID_EX_RT 14:10
`define ID_EX_READDATA2 46:15
`define ID_EX_READDATA1 78:47
`define ID_EX_SIGNEXT 110:79
`define ID_EX_PCPLUS4 142:111
`define ID_EX_REGDST 144:143
`define ID_EX_MEM2REG 146:145
`define ID_EX_MEMREAD 147
`define ID_EX_MEMWRITE 148
`define ID_EX_REGWRITE 149
`define ID_EX_ALUSRC 150
`define ID_EX_ALUCTL 154:151
`define ID_EX_BRANCH 156:155
`define ID_EX_MEMWIDTH 158:157
`define ID_EX_MEMSIGN 159
`define ID_EX_RS 164:160

// EX-MEM
`define EX_MEM_SIZE 144
`define EX_MEM_WIDTH 143:0
`define EX_MEM_PCPLUS4 31:0
`define EX_MEM_WA3 36:32
`define EX_MEM_WRITEDATA 68:37
`define EX_MEM_ALURESULT 100:69
`define EX_MEM_MEMWRITE 101
`define EX_MEM_PCBRANCH 133:102
`define EX_MEM_BRANCH 135:134
`define EX_MEM_ZERO 136
`define EX_MEM_MEMREAD 137
`define EX_MEM_REGWRITE 138
`define EX_MEM_MEM2REG 140:139
`define EX_MEM_MEMWIDTH 142:141
`define EX_MEM_MEMSIGN 143

// MEM-WB
`define MEM_WB_SIZE 104
`define MEM_WB_WIDTH 103:0
`define MEM_WB_PCPLUS4 31:0
`define MEM_WB_WA3 36:32
`define MEM_WB_ALURESULT 68:37
`define MEM_WB_READDATA 100:69
`define MEM_WB_MEM2REG 102:101
`define MEM_WB_REGWRITE 103


// DATAPATH
module datapath #(parameter N = 32)
					(input logic reset, clk,
					input logic [`WIDTH_CTL_BUS] ctl,									
					input logic [N-1:0] instruction,
					output logic [N-1:0] imem_addr,
                    output logic [5:0] opcode, func); // opcode and func used in control unit 				
					
    logic PCSrc;
	logic compare;
	logic [N-1:0] PCBranch_D, aluResult_E, writeData_E, writeData3, PCTarget; 
	logic [N-1:0] signExt_D, readData1_D, readData2_D;
	logic [N-1:0] readData_M;
	logic [4:0] wa3;
	logic zero_E;
	logic [`IF_ID_WIDTH] qIF_ID;
	logic [`ID_EX_WIDTH] qID_EX;
	logic [`EX_MEM_WIDTH] qEX_MEM;
	logic [`MEM_WB_WIDTH] qMEM_WB;
	logic [`HCTL_WIDTH] hctl;
	logic [N-1:0] readData1_FW_E, readData2_FW_E;
	logic [N-1:0] readData1_FW_D, readData2_FW_D;
	//hazard
	logic memToRegE, memToRegM, branchOrJumpRegD;
	
	fetch 	FETCH 	(.PCSrc(PCSrc),
                    .clk(clk),
                    .reset(reset),
					.enable(~hctl[`HCTL_STALLF]),
                    .PCBranch(PCTarget), 
                    .imem_addr(imem_addr));								
					
	
	flopr 	#(`IF_ID_SIZE)		IF_ID 	(.clk(clk),
										.reset(reset),
										.enable(~hctl[`HCTL_STALLD]),
										.clr(hctl[`HCTL_FLUSHD]), 
										.d({instruction, imem_addr}),
										.q(qIF_ID));

    assign opcode = qIF_ID[`IF_ID_OPCODE];
    assign func = qIF_ID[`IF_ID_RTYPEFUNC];
	

	decode  DECODE 	(.clk(clk),	
					.regWrite(qMEM_WB[`MEM_WB_REGWRITE]),
					.regDst(ctl[`CTL_REGDST]),
					.PC(qIF_ID[`IF_ID_PCPLUS4]),
					.writeData3(writeData3),
					.instr(qIF_ID[`IF_ID_INSTRUCTION]),
					.wa3(qMEM_WB[`MEM_WB_WA3]), // instruccion que sale de wb flopr	
					.signExt(signExt_D), 
					.readData1(readData1_D),
					.readData2(readData2_D),
					.PCBranch(PCBranch_D));		

	// branch
	mux2 #(32) readData1Mux (.d0(readData1_D), .d1(qEX_MEM[`EX_MEM_ALURESULT]), .s(hctl[`HCTL_FORWARDAD]), .y(readData1_FW_D));
	mux2 #(32) readData2Mux (.d0(readData2_D), .d1(qEX_MEM[`EX_MEM_ALURESULT]), .s(hctl[`HCTL_FORWARDBD]), .y(readData2_FW_D));
	assign compare = readData1_FW_D == readData2_FW_D;
	mux4 #(1) pcSrcMux (.d0(0), .d1(1), .d2(~compare), .d3(compare), .s(ctl[`CTL_BRANCH]), .y(PCSrc));
	mux4 #(32) branchMux (.d0(qIF_ID[`IF_ID_PCPLUS4]), .d1(PCBranch_D), .d2({qIF_ID[`IF_ID_TOPPCPLUS4], qIF_ID[`IF_ID_INSTIMM], 2'b0}), .d3(readData1_FW_D), .s(ctl[`CTL_PCSRC]), .y(PCTarget));
		
	flopr 	#(`ID_EX_SIZE)	ID_EX 	(.clk(clk),
									.reset(reset),
									.enable(1),
									.clr(hctl[`HCTL_FLUSHE]),  
									.d({qIF_ID[`IF_ID_RS], ctl[`CTL_MEMSIGN], ctl[`CTL_MEMWIDTH], ctl[`CTL_BRANCH], 
										ctl[`CTL_ALUCTL], ctl[`CTL_ALUSRC], ctl[`CTL_REGWRITE], 
										ctl[`CTL_MEMWRITE], ctl[`CTL_MEMREAD], ctl[`CTL_MEM2REG],	ctl[`CTL_REGDST], 
										qIF_ID[`IF_ID_PCPLUS4], signExt_D, readData1_D, readData2_D, qIF_ID[`IF_ID_RT], 
										qIF_ID[`IF_ID_RD], qIF_ID[`IF_ID_SHAMT]}),
									.q(qID_EX));

	mux4 muxRD1_FW(.d0(qID_EX[`ID_EX_READDATA1]), .d1(qEX_MEM[`EX_MEM_ALURESULT]), .d2(writeData3), .d3(32'b0), .s(hctl[`HCTL_FORWARDAE]), .y(readData1_FW_E));
	mux4 muxRD2_FW(.d0(qID_EX[`ID_EX_READDATA2]), .d1(qEX_MEM[`EX_MEM_ALURESULT]), .d2(writeData3), .d3(32'b0), .s(hctl[`HCTL_FORWARDBE]), .y(readData2_FW_E));

	execute  EXECUTE 	(.AluSrc(qID_EX[`ID_EX_ALUSRC]),
						.AluControl(qID_EX[`ID_EX_ALUCTL]),
						.shamt(qID_EX[`ID_EX_SHAMT]), 
						.PC(qID_EX[`ID_EX_PCPLUS4]), 
						.signImm(qID_EX[`ID_EX_SIGNEXT]), 
						.readData1(readData1_FW_E),
						.readData2(readData2_FW_E), 
						.aluResult(aluResult_E), 
						.writeData(writeData_E), 
						.zero(zero_E));											
											
	mux4 #(5)       mux(qID_EX[`ID_EX_RT], qID_EX[`ID_EX_RD], 5'd31, 5'd0, qID_EX[`ID_EX_REGDST], wa3);


	flopr 	#(`EX_MEM_SIZE)	 EX_MEM 	(.clk(clk),
										.reset(reset),
										.enable(1),
										.clr(0),  
										.d({qID_EX[`ID_EX_MEMSIGN], qID_EX[`ID_EX_MEMWIDTH], qID_EX[`ID_EX_MEM2REG], qID_EX[`ID_EX_REGWRITE], qID_EX[`ID_EX_MEMREAD], 
											zero_E, qID_EX[`ID_EX_BRANCH], PCBranch_D, qID_EX[`ID_EX_MEMWRITE], aluResult_E, 
											writeData_E, wa3, qID_EX[`ID_EX_PCPLUS4]}),
										.q(qEX_MEM));	

										
	memory	MEMORY	(.clk(clk),
					.memWrite(qEX_MEM[`EX_MEM_MEMWRITE]),
					.memRead(qEX_MEM[`EX_MEM_MEMREAD]),
					.memSign(qEX_MEM[`EX_MEM_MEMSIGN]),
					.memWidth(qEX_MEM[`EX_MEM_MEMWIDTH]),
					.aluResult(qEX_MEM[`EX_MEM_ALURESULT]),
					.writeData(qEX_MEM[`EX_MEM_WRITEDATA]),
					.PCSrc(PCSrc),
					.readData(readData_M));
	
	flopr 	#(`MEM_WB_SIZE)	MEM_WB 	(.clk(clk),
									.reset(reset),
									.enable(1),
									.clr(0),  
									.d({qEX_MEM[`EX_MEM_REGWRITE], qEX_MEM[`EX_MEM_MEM2REG], readData_M, 
										qEX_MEM[`EX_MEM_ALURESULT], qEX_MEM[`EX_MEM_WA3], qEX_MEM[`EX_MEM_PCPLUS4]}),
									.q(qMEM_WB));
	
	
	writeback 	WRITEBACK (.aluResult(qMEM_WB[`MEM_WB_ALURESULT]), 
							.dmemReadData(qMEM_WB[`MEM_WB_READDATA]), 
							.memtoReg(qMEM_WB[`MEM_WB_MEM2REG]),
							.pcPlus4(qMEM_WB[`MEM_WB_PCPLUS4]),
							.writeData3(writeData3));

	/* Hazard Control */
    assign memToRegE = qID_EX[`ID_EX_MEM2REG] == `REGWRITE_MEMREAD;
    assign memToRegM = qEX_MEM[`EX_MEM_MEM2REG] == `REGWRITE_MEMREAD;
    assign branchOrJumpRegD = ctl[`CTL_PCSRC] == `PCSRC_BRANCH | ctl[`CTL_PCSRC] == `PCSRC_JUMPREG;

	hazardUnit HUNIT (.RsD(qIF_ID[`IF_ID_RS]),
					 .RtD(qIF_ID[`IF_ID_RT]),
					 .RsE(qID_EX[`ID_EX_RS]),
					 .RtE(qID_EX[`ID_EX_RT]),
					 .writeRegE(wa3),
					 .writeRegM(qEX_MEM[`EX_MEM_WA3]),
					 .writeRegW(qMEM_WB[`MEM_WB_WA3]),
					 .regWriteM(qEX_MEM[`EX_MEM_REGWRITE]),
					 .regWriteW(qMEM_WB[`MEM_WB_REGWRITE]),
					 .regWriteE(qID_EX[`ID_EX_REGWRITE]),
					 .memToRegE(memToRegE),
					 .memToRegM(memToRegM),
					 .branchOrJumpRegD(branchOrJumpRegD),
					 .PCSrc(PCSrc),
					 .HCTL(hctl));
		
endmodule
