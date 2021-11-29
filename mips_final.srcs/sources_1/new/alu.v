`timescale 1ns / 1ps

module alu
  #(
    parameter N_BITS = 8
  )
  (
    input wire [N_BITS-1:0]d0, 
    input wire [N_BITS-1:0]d1, 
    input wire [5:0]opcode,
    output reg [N_BITS-1:0]out
  );

  always @(*) begin
    case (opcode)
      6'b100000: out = d0 + d1; // add (+)
      6'b100010: out = d0 - d1; // sub (-)
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