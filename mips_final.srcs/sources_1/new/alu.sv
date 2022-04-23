`timescale 1ns / 1ps

module alu
  #(
    parameter N_BITS = 32
  )
  (
    input logic [N_BITS-1:0]d0, 
    input logic [N_BITS-1:0]d1, 
    input logic [5:0]opcode, 
    output logic [N_BITS-1:0]out,
    output logic zero
  );

  always_comb 
      begin
        case (opcode)
          6'b100001: out = d0 + d1; // addu (+)
          6'b100011: out = d0 - d1; // sub (-)
          6'b100100: out = d0 & d1; // and (&)
          6'b100101: out = d0 | d1; // or (|)
          6'b100110: out = d0 ^ d1; // xor (^)
          6'b000011: out = d0 >>> d1; // sra (>>>)
          6'b000010: out = d0 >> d1; // srl (>>)
          6'b100111: out = ~(d0 | d1); // nor ~( | )
          default: out = {N_BITS{1'b0}};
        endcase
      end
  
endmodule