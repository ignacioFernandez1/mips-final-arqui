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

module ControlUnit 
    (input logic [5: 0] opcode,
     input logic [5: 0] func, 
     output logic [3:0] ALUCtl); // DEFINIR TAMANIO DE SALIDA CONTROLER

    reg [3:0] ctl;
    assign ALUCtl = ctl;

    always @ (*)
    begin
        ctl = `ALU_ADDU;
        case (opcode)
            `OP_SPECIAL: // R-type
                case (Func)
                    `FUNC_SLL: ctl = `ALU_SLL;
                    `FUNC_SRL: ctl = `ALU_SRL;
                    `FUNC_SRA: ctl = `ALU_SRA;
                    `FUNC_SLLV: ctl = `ALU_SLLV;
                    `FUNC_SRLV: ctl = `ALU_SRLV;
                    `FUNC_SRAV: ctl = `ALU_SRAV;
                    `FUNC_JR: ctl = `ALU_ADDU;
                    `FUNC_JALR: ctl = `ALU_ADDU;
                    `FUNC_ADDU: ctl = `ALU_ADDU;
                    `FUNC_SUBU: ctl = `ALU_SUBU;
                    `FUNC_AND: ctl = `ALU_AND;
                    `FUNC_OR: ctl = `ALU_OR;
                    `FUNC_XOR: ctl = `ALU_XOR;
                    `FUNC_NOR: ctl = `ALU_NOR;
                    `FUNC_SLT: ctl = `ALU_SLT;
                endcase

            `OP_BEQ, `OP_BNE: ctl = `ALU_SUBU;
            `OP_ADDI: ctl = `ALU_ADDU;
            `OP_SLTI: ctl = `ALU_SLT;
            `OP_ANDI: ctl = `ALU_AND;
            `OP_ORI: ctl = `ALU_OR;
            `OP_XORI: ctl = `ALU_XOR;
            `OP_LUI: ctl = `ALU_LUI;

            default: ctl = `ALU_ADDU;
        endcase
    end
endmodule