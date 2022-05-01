`timescale 1ns / 1ps


module fetch
  #(parameter N = 32)
  (input logic PCSrc, clk, reset,
   input logic [N-1:0] PCBranch,
   output logic [N-1:0] imem_addr);

  logic [N-1:0] pc_in, pc_out, adder_a, adder_b, adder_out;
  flopr #(N) PC(clk, reset, pc_in, pc_out);
  adder #(N) Add(adder_a, adder_b, adder_out);

  always_comb
    begin
      pc_in = PCSrc ? PCBranch : adder_out;
      adder_a = pc_out;
      adder_b = 4; 
      imem_addr = pc_out;
    end
endmodule