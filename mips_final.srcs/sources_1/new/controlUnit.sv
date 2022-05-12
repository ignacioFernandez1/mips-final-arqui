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

        case (opcode)
        
            `OP_SPECIAL: 
                begin
                    ctl[`CTL_ALUSRC] = 0;
                    ctl[`CTL_REGWRITE] = 1;
                    ctl[`CTL_REGDST] = 1;

                    case (func)
                        `FUNC_JR:
                            begin
                                ctl[`CTL_REGWRITE] = 0;
                                ctl[`CTL_BRANCH] = 1;
                            end

                        `FUNC_JALR:
                            begin
                                ctl[`CTL_MEM2REG] = `REGWRITE_PCPLUS4;
                                ctl[`CTL_REGDST] = `REGDST_31;
                                ctl[`CTL_BRANCH] = 1;
                            end

                        default: ;

                    endcase
                end
            
            // `OP_BEQ:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_RT;
            //         ctl[`CTL_BRANCH] = `BRANCH_BEQ;
            //         ctl[`CTL_PCSRC] = `PCSRC_BRANCH;
            //     end
            // `OP_BNE:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_RT;
            //         ctl[`CTL_BRANCH] = `BRANCH_BNE;
            //         ctl[`CTL_PCSRC] = `PCSRC_BRANCH;
            //     end
            // `OP_BLEZ:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_RT;
            //         ctl[`CTL_BRANCH] = `BRANCH_BLEZ;
            //         ctl[`CTL_PCSRC] = `PCSRC_BRANCH;
            //     end
            // `OP_BGTZ:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_RT;
            //         ctl[`CTL_BRANCH] = `BRANCH_BGTZ;
            //         ctl[`CTL_PCSRC] = `PCSRC_BRANCH;
            //     end

            // `OP_ADDI, `OP_ADDIU, `OP_SLTI, `OP_SLTIU, `OP_LUI:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_ALU;
            //         ctl[`CTL_REGDST] = `REGDST_ITYPE;
            //     end

            // `OP_ANDI, `OP_ORI, `OP_XORI: 
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMMU;
                        
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_ALU;
            //         ctl[`CTL_REGDST] = `REGDST_ITYPE;
            //     end
            
            // `OP_MUL:
            //     begin
            //         if (Func == `FUNC_MUL)//MUL
            //         begin
            //             ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //             ctl[`CTL_ALUSRCB] = `ALUSRCB_RT;
                        
            //             ctl[`CTL_REGWRITE] = 1;
            //             ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_ALU;
            //             ctl[`CTL_REGDST] = `REGDST_RTYPE;
            //         end
            //     end
            
            // `OP_LB:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_MEMORY;
            //         ctl[`CTL_REGDST] = `REGDST_ITYPE;
                    
            //         ctl[`CTL_MEMSIGNED] = 1;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_8;
            //     end
            // `OP_LH:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_MEMORY;
            //         ctl[`CTL_REGDST] = `REGDST_ITYPE;
                    
            //         ctl[`CTL_MEMSIGNED] = 1;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_16;
            //     end
            // `OP_LW:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_MEMORY;
            //         ctl[`CTL_REGDST] = `REGDST_ITYPE;

            //         ctl[`CTL_MEMSIGNED] = 1;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_32;
            //     end
            // `OP_LBU:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_MEMORY;
            //         ctl[`CTL_REGDST] = `REGDST_ITYPE;
                    
            //         ctl[`CTL_MEMSIGNED] = 0;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_8;
                        
            //     end
            // `OP_LHU:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_MEMORY;
            //         ctl[`CTL_REGDST] = `REGDST_ITYPE;
                    
            //         ctl[`CTL_MEMSIGNED] = 0;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_16;
                        
            //         ctl[`CTL_PCSRC] = `PCSRC_PCPLUS4;
            //     end

            // `OP_SB:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_MEMWRITE] = 1;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_8;
            //     end
            // `OP_SH:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_MEMWRITE] = 1;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_16;
            //     end
            // `OP_SW:
            //     begin
            //         ctl[`CTL_ALUSRCA] = `ALUSRCA_RS;
            //         ctl[`CTL_ALUSRCB] = `ALUSRCB_IMM;
                        
            //         ctl[`CTL_MEMWRITE] = 1;
            //         ctl[`CTL_MEMWIDTH] = `MEMWIDTH_32;
            //     end
            // `OP_J:
            //     begin
            //         ctl[`CTL_PCSRC] = `PCSRC_JUMPIMM;
            //     end
            
            // `OP_JAL:
            //     begin
            //         ctl[`CTL_REGWRITE] = 1;
            //         ctl[`CTL_REGWRITE_DATA] = `REGWRITE_DATA_FROM_PCPLUS4;//PC + 4
            //         ctl[`CTL_REGDST] = `REGDST_RA;
                    
            //         ctl[`CTL_PCSRC] = `PCSRC_JUMPIMM;
            //     end
            default: ;
        endcase
    end

endmodule   