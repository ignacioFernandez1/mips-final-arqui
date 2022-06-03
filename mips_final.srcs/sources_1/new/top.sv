import common::*;

module top(
  input logic clk_in, i_reset,
  output logic clk_out, o_locked
  );

  
  logic [31:0] inst_in;
  logic op_in; // 0 = escritura de instruccion | 1 = lectura de instruccion 
  logic [31:0] imem_addr;
  
  // Datapath I/O
  logic [`WIDTH_CTL_BUS] ctl;
  logic [5:0] opcode, func;
  logic [31:0] inst_out;
  
  logic i_clock;

  assign i_clock = o_locked & clk_out;

  imem imem(.i(inst_in), .addr(imem_addr), .op(op_in), .q(inst_out));
  controlUnit cu(.opcode(opcode), .func(func), .ctl(ctl));
  datapath dp(.reset(i_reset), .clk(i_clock), .ctl(ctl), .instruction(inst_out), .imem_addr(imem_addr), .opcode(opcode), .func(func));           

  clk_wiz_0 inst
  (
  // Clock out ports  
  .clk_out1(clk_out),
  // Status and control signals               
  .reset(i_reset), 
  .locked(o_locked),
  // Clock in ports
  .clk_in1(clk_in)
  );
  
  
endmodule
