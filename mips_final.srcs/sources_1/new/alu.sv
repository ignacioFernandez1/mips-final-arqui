`timescale 1ns / 1ps

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

module alu
  #(
    parameter N_BITS = 32
  )
  (
    input logic [N_BITS-1:0]d0, 
    input logic [N_BITS-1:0]d1,
    input logic [3:0] ALUControl, 
    input logic [5:0] shamt, 
    output logic [N_BITS-1:0]out,
    output logic zero
  );

  always_comb 
      begin
        case (ALUControl)
          `ALU_SLL: out = d1 << shamt; // sll (<<)
          `ALU_SRL: out = d1 >> shamt; // srl (>>)
          `ALU_SRA: out = d1 >>> shamt; // sra (>>>)
          `ALU_LUI: out = {d1[15: 0], 16'b0};
          `ALU_SLLV: out = d1 << d0; //sllv
          `ALU_SRLV: out = d1 >> d0; //srlv
          `ALU_SRAV: out = d1 >>> d0; //srav
          `ALU_ADDU: out = d0 + d1; // addu (+)
          `ALU_SUBU: out = d0 - d1; // subu (-)
          `ALU_AND: out = d0 & d1; // and (&)
          `ALU_OR: out = d0 | d1; // or (|)
          `ALU_XOR: out = d0 ^ d1; // xor (^) 
          `ALU_NOR: out = ~(d0 | d1); // nor ~( | )
          `ALU_SLT: out = d0 < d1; // slt (<)
          default: out = 32'hxxxx_xxxx;
        endcase
        if (out == 0) zero = 1;
        else zero = 0;
      end
  
endmodule