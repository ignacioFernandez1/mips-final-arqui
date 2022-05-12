package common;
 
`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end
 
// INSTRUCTIONS
`define OPCODE 31:26
`define R_TYPE_FUNC 5:0

 // R-type opcode
`define OP_SPECIAL 6'b0

//I-Type
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_ADDI 6'b001000
`define OP_SLTI 6'b001010
`define OP_ANDI 6'b001100
`define OP_ORI 6'b001101
`define OP_XORI 6'b001110
`define OP_LUI 6'b001111
`define OP_LB 6'b100000
`define OP_LH 6'b100001
`define OP_LW 6'b100011
`define OP_LBU 6'b100100
`define OP_LHU 6'b100101
`define OP_LWU 6'b100111
`define OP_SB 6'b101000
`define OP_SH 6'b101001
`define OP_SW 6'b101011

//J-Type
`define OP_J 6'b000010
`define OP_JAL 6'b000011

//ALU Control Signal
`define ALU_SLL 4'b0000
`define ALU_SRL 4'b0001
`define ALU_SRA 4'b0010


`define ALU_LUI 4'b0011
`define ALU_SLLV 4'b0100
`define ALU_SRLV 4'b0110
`define ALU_SRAV 4'b0111
`define ALU_ADDU 4'b1000
`define ALU_SUBU 4'b1001
`define ALU_AND 4'b1010
`define ALU_OR 4'b1011
`define ALU_XOR 4'b1100
`define ALU_NOR 4'b1101

`define ALU_SLT 4'b1110
`define ALU_SLTU 4'b1111

// Opcode of instructions
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010
`define FUNC_SRA 6'b000011
`define FUNC_SLLV 6'b000100
`define FUNC_SRLV 6'b000110
`define FUNC_SRAV 6'b000111
`define FUNC_JR 6'b001000
`define FUNC_JALR 6'b001001
`define FUNC_ADDU 6'b100001
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_NOR 6'b100111
`define FUNC_SLT 6'b101010

// ctl unit
`define WIDTH_CTL_BUS 12:0

`define CTL_ALUCTL 3:0
`define CTL_ALUSRC 4
`define CTL_REGWRITE 5
`define CTL_MEMWRITE 6
`define CTL_MEMREAD 7
`define CTL_BRANCH 8
`define CTL_MEM2REG 10:9
`define CTL_REGDST 12:11

// decode write address mux
`define REGDST_RT 2'b00
`define REGDST_RD 2'b01
`define REGDST_31 2'b10

// writeback mux
`define REGWRITE_MEMREAD 2'b00
`define REGWRITE_ALUOUT 2'b01
`define REGWRITE_PCPLUS4 2'b10

endpackage