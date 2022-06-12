import common::*;

 module top(
  input logic clk_in, i_reset,
  output logic i_clock, o_locked
  );

  
  logic [31:0] inst_in;
  logic op_in; // 0 = escritura de instruccion | 1 = lectura de instruccion 
  logic [31:0] dp_imem_addr, imem_addr;

  // Datapath I/O
  logic [`WIDTH_CTL_BUS] ctl;
  logic [5:0] opcode, func;
  logic [31:0] inst_out;
  
  // debug unit
  logic rx, tx, du_clock, du_imem_op, imem_addr_select;
  logic [31:0] du_imem_address, du_instr;


  assign i_clock = o_locked & clk_out;
  
  mux2 imem_addr_in(.d0(du_imem_address), .d1(dp_imem_addr), .s(imem_addr_select), .y(imem_addr));
  debugUnit du(.i_clock(i_clock), .i_reset(i_reset), .rx(rx),
               .tx(tx), .du_clock(du_clock), .du_imem_address(du_imem_address), 
               .du_imem_op(du_imem_op), .imem_addr_select(imem_addr_select), .du_instr(du_instr));

  imem imem(.i(du_instr), .addr(imem_addr), .op(du_imem_op), .q(inst_out));
  controlUnit cu(.opcode(opcode), .func(func), .ctl(ctl));
  datapath dp(.reset(i_reset), .clk(du_clock), .ctl(ctl), .instruction(inst_out), .imem_addr(dp_imem_addr), .opcode(opcode), .func(func));           

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
