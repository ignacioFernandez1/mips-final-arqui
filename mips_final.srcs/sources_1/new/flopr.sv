

module flopr
  #(parameter N = 64)
  (input logic clk, reset, enable, clr,
   input logic [N-1:0] d,
   output logic [N-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else if (enable) q <= d;
    else if (clr) q <= 0;

endmodule
