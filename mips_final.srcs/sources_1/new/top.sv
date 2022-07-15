import common::*;

 module top(
  input logic clk_in, i_reset, rx, du_reset,
  output logic clk_out, o_locked, halt_instr_signal, tx
  );

  
  logic [31:0] inst_in;
  logic op_in; // 0 = escritura de instruccion | 1 = lectura de instruccion 
  logic [31:0] dp_imem_addr, imem_addr;

  // Datapath I/O
  logic [`WIDTH_CTL_BUS] ctl;
  logic [5:0] opcode, func;
  logic [31:0] inst_out;
  logic [31:0] debug_read_data_reg;
	logic [4:0] debug_read_addr_reg;
  logic [31:0] debug_read_data_mem;
	logic [31:0] debug_read_addr_mem;
  
  // debug unit
  logic du_imem_op, imem_addr_select, clock_enable;
  logic [31:0] du_imem_address, du_instr;
  
  mux2 imem_addr_in(.d0(du_imem_address), .d1(dp_imem_addr), .s(imem_addr_select), .y(imem_addr));
  debugUnit du(.i_clock(clk_out), .i_reset(du_reset), .rx(rx),
               .tx(tx), .clock_enable(clock_enable), .du_imem_address(du_imem_address), 
               .du_imem_op(du_imem_op), .imem_addr_select(imem_addr_select), .du_instr(du_instr),
               .debug_read_data_reg(debug_read_data_reg), .debug_read_addr_reg(debug_read_addr_reg),
               .debug_read_data_mem(debug_read_data_mem), .debug_read_addr_mem(debug_read_addr_mem),
               .debug_pc(dp_imem_addr), .halt_instr_signal(halt_instr_signal));

  imem imem(.i(du_instr), .addr(imem_addr), .op(du_imem_op), .q(inst_out));
  controlUnit cu(.opcode(opcode), .func(func), .ctl(ctl));
  datapath dp(.reset(i_reset), .clk(clk_out), .clock_enable(clock_enable), .ctl(ctl), .instruction(inst_out), .imem_addr(dp_imem_addr), .opcode(opcode), .func(func),
              .halt_instr_signal(halt_instr_signal),
              .debug_read_data_reg(debug_read_data_reg), .debug_read_addr_reg(debug_read_addr_reg),
              .debug_read_data_mem(debug_read_data_mem), .debug_read_addr_mem(debug_read_addr_mem));            

  clk_wiz_0 inst
  (
  // Clock out ports  
  .clk_out1(clk_out),
  // Status and control signals               
  .reset(0),
  .locked(o_locked),
  // Clock in ports
  .clk_in1(clk_in)
  );
  
  
endmodule
