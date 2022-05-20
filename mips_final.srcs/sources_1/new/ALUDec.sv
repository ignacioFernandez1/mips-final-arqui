import common::*;

module ALUDec
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
                case (func)
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