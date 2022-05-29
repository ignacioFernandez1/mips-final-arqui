import common::*;

module controlUnit
    (input logic [5: 0] opcode,
     input logic [5: 0] func, 
     output logic [`WIDTH_CTL_BUS] ctl); // DEFINIR TAMANIO DE SALIDA CONTROLER

    wire [3:0] ALUCtl;
    
    ALUDec alu_dec(opcode, func, ALUCtl);

    always @ (*)
    begin

        ctl = 0;
        ctl[`CTL_ALUCTL] = ALUCtl;
        ctl[`CTL_PCSRC] = `PCSRC_PCPLUS4;
        ctl[`CTL_BRANCH] = `BRANCH_NTAKEN_CTL;

        case (opcode)
        
            `OP_SPECIAL: 
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_REG;
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_REGDST] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_ALUOUT;

                    case (func)
                        `FUNC_JR:
                            begin
                                ctl[`CTL_REGWRITE] = 0;
                                ctl[`CTL_BRANCH] = `BRANCH_TAKEN_CTL;
                                ctl[`CTL_PCSRC] = `PCSRC_JUMPREG;
                            end

                        `FUNC_JALR:
                            begin
                                ctl[`CTL_MEM2REG] = `REGWRITE_PCPLUS4;
                                ctl[`CTL_REGDST] = `REGDST_31;
                                ctl[`CTL_BRANCH] = `BRANCH_TAKEN_CTL;
                                ctl[`CTL_PCSRC] = `PCSRC_JUMPREG;
                            end

                        default: ;

                    endcase
                end
            
            `OP_BEQ:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_REG;
                    ctl[`CTL_BRANCH] = `BRANCH_EQ_CTL;
                    ctl[`CTL_PCSRC] = `PCSRC_BRANCH;
                end
           `OP_BNE:
               begin
                   ctl[`CTL_ALUSRC] = `ALUSCR_REG;
                   ctl[`CTL_BRANCH] = `BRANCH_NEQ_CTL;
                   ctl[`CTL_PCSRC] = `PCSRC_BRANCH;
               end

            `OP_ADDI, `OP_SLTI, `OP_LUI, `OP_ANDI, `OP_ORI, `OP_XORI:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_ALUOUT;
                    ctl[`CTL_REGDST] = `REGDST_RT;
                end
            
            `OP_J:
                begin
                    ctl[`CTL_BRANCH] = `BRANCH_TAKEN_CTL;
                    ctl[`CTL_PCSRC] = `PCSRC_JUMPIMM;
                end
            
            `OP_JAL:
                begin
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_PCPLUS4;//PC + 4
                    ctl[`CTL_REGDST] = `REGDST_31;
                    
                    ctl[`CTL_BRANCH] = `BRANCH_TAKEN_CTL;
                    ctl[`CTL_PCSRC] = `PCSRC_JUMPIMM;
                end
            `OP_LB:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEMREAD] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_MEMREAD;
                    ctl[`CTL_REGDST] = `REGDST_RT;
                    
                    ctl[`CTL_MEMSIGN] = 1;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_8;
                end
            `OP_LH:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEMREAD] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_MEMREAD;
                    ctl[`CTL_REGDST] = `REGDST_RT;
                    
                    ctl[`CTL_MEMSIGN] = 1;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_16;
                end
            `OP_LW:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEMREAD] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_MEMREAD;
                    ctl[`CTL_REGDST] = `REGDST_RT;
                    
                    ctl[`CTL_MEMSIGN] = 1;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_32;
                end
            `OP_LBU:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEMREAD] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_MEMREAD;
                    ctl[`CTL_REGDST] = `REGDST_RT;
                    
                    ctl[`CTL_MEMSIGN] = 0;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_8;
                end
            `OP_LHU:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEMREAD] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_MEMREAD;
                    ctl[`CTL_REGDST] = `REGDST_RT;
                    
                    ctl[`CTL_MEMSIGN] = 0;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_16;
                end
            `OP_LWU:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_MEMREAD] = 1;
                    ctl[`CTL_MEM2REG] = `REGWRITE_MEMREAD;
                    ctl[`CTL_REGDST] = `REGDST_RT;
                    
                    ctl[`CTL_MEMSIGN] = 0;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_32;
                end

            `OP_SB:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_MEMWRITE] = 1;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_8;
                end
            `OP_SH:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_MEMWRITE] = 1;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_16;
                end
            `OP_SW:
                begin
                    ctl[`CTL_ALUSRC] = `ALUSCR_INM;
                        
                    ctl[`CTL_MEMWRITE] = 1;
                    ctl[`CTL_MEMWIDTH] = `MEMWIDTH_32;
                end
            default: ;
        endcase
    end

endmodule   