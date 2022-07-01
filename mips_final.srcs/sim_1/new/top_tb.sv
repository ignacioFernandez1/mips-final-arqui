`timescale 1ns / 1ps

module top_tb();
   reg    clk;
   reg [7:0] data;
   integer   fd;
   integer   code;
   logic i_clock, din_ready, tx, halt_instr_signal;
   logic [7:0] din, drx;
   logic rx_top, tx_top;
   logic rx_done;
   logic du_reset;
   logic [2:0] finish;
   logic finish_flag;
   logic [1:0] i_uart;
   logic [6:0] i_pos_uart;
   logic [31:0] uart_data;

   logic [31:0] registers [0:64];

   
   // TOP I/O
   logic reset;
   top top (.clk_in(clk), .i_reset(reset), .i_clock(i_clock), .rx(rx_top), .du_reset(du_reset), .halt_instr_signal(halt_instr_signal), .tx(tx_top));
   top_uart uart(.i_clock(i_clock), .i_reset(reset), .rx_top(tx_top), .dtx_ready(din_ready),
               .dtx(din), .tx_top(rx_top), .rx_done(rx_done), .drx(drx));

   initial begin
      fd = $fopen("input.dat","rb");
      finish = 0; 
      finish_flag = 0;
      clk = 0;
      data = 0;
      code = 1;
      du_reset = 0; 
      // sending mode
      wait(i_clock);
      du_reset = 1; #100;
      du_reset = 0;
      din = 8'b0;
      din_ready = 1; #1000;
      din_ready = 0; #100000;

      // for uart receive
      i_uart = 3;
      i_pos_uart = 0;


      while (code) begin
         code = $fread(data, fd);
         $display("data = %b", data);
         if (code) begin
            din = data;
            din_ready = 1; #1000;
            din_ready = 0; #100000;
         end
         @(posedge clk);
      end
      reset = 1; #100;
      reset = 0;
      while(1)
      begin
         #50;
         if(finish_flag) begin
            $display("PC = %b", registers[0]);
            for(int i=1;i<33;i++) $display("REG %d = %b", i - 1, registers[i]);
            $finish;
         end
      end
   end
   always @(posedge rx_done) begin
      uart_data[(i_uart*8) +: 8] = drx;
      i_uart = i_uart - 1;
      if(i_uart == 3)begin
         $display("ANASHI");
         registers[i_pos_uart] = uart_data;
         i_pos_uart = i_pos_uart + 1;
         $display("IPOS %d", i_pos_uart);
         if(i_pos_uart == 33) finish_flag = 1;
         else i_uart = 3;
      end
   end 
   always #5 clk = ~clk;

endmodule
