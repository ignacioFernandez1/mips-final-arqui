`timescale 1ns / 1ps

module controller
    (input logic [5:0] opcode,
     output logic RegDst, ALUSrc, Mem2Reg, RegWrite, MemRead, MemWrite, Branch,
     output logic [2:0] ALUOp
    );
    logic ctl;
    controlUnit cu(opcode, func, ctl);

endmodule
