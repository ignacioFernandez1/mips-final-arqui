`timescale 1ns / 1ps

module controller
    #(parameter N = 32)
    (input logic [N-1:0] instr,
     output logic RegDst, ALUSrc, Mem2Reg, RegWrite, MemRead, MemWrite, Branch,
     output logic [1:0] ALUOp
    );
    
    always_comb
        begin
            
        end
endmodule
