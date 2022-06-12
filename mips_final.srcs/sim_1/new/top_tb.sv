`timescale 1ns / 1ps

module top_tb();
   reg    clk;
   reg [7:0] data;
   integer   fd;
   integer   code;
   logic i_clock, tick, din_ready, tx;
   logic [7:0] din;
   
   // TOP I/O
   logic reset;
   top top (.clk_in(clk), .i_reset(reset), .i_clock(i_clock));
   Tx txdut(.i_clock(i_clock), .i_reset(reset), .tick(tick), .din(din), .din_ready(din_ready), .tx(top.rx));
   baud_rate br(.i_clock(i_clock), .tick(tick));

   initial begin
      fd = $fopen("input.dat","rb"); 
      clk = 0;
      data = 0;
      code = 1; 
      // sending mode
      #10000;
      din = 8'b0;
      din_ready = 1; #1000;
      din_ready = 0; #100000;

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
      #6000;
      $finish;
   end 
   always #5 clk = ~clk;
endmodule
