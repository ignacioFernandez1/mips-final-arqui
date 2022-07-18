`timescale 1ns / 1ps
import common::*;

`define WIDTH_CTL_BUS 18:0

module top_synt(
    input logic clk_in, i_reset, du_reset, op_in,clock_enable,
    input [31:0] inst_in,
    input [31:0]  imem_addr_in,
    output logic clk_out, o_locked, halt_instr_signal,
    output [31:0]imem_addr
    );

    logic [31:0] imem_addr_dp;


  // Datapath I/O
    logic [`WIDTH_CTL_BUS] ctl;
    logic [5:0] opcode, func;
    logic [31:0] inst_out;
    logic [31:0] debug_read_data_reg;
    logic [4:0] debug_read_addr_reg;
    logic [31:0] debug_read_data_mem;
    logic [31:0] debug_read_addr_mem;

    mux2 imem_addr_in_mux(.d0(imem_addr_in), .d1(imem_addr_dp), .s(clock_enable), .y(imem_addr));
    imem imem(.i(inst_in), .addr(imem_addr), .op(op_in), .q(inst_out));
    controlUnit cu(.opcode(opcode), .func(func), .ctl(ctl));


    datapath dp(.reset(i_reset), .clk(clk_out), .clock_enable(clock_enable), .ctl(ctl), .instruction(inst_out), .imem_addr(imem_addr_dp), .opcode(opcode), .func(func),
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
