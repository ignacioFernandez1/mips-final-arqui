

// module flopr
//   #(parameter N = 64)
//   (input logic clk, reset, enable, clr,
//    input logic [N-1:0] d,
//    output logic [N-1:0] q);

//   always_ff @(posedge clk, posedge reset)
//     if (reset) q <= 0;
//     else if (clr) q <= 0;
//     else if (enable) q <= d;

// endmodule


module flopr
  #(parameter N = 64)
  (input logic clk, reset, enable, clr,
   input logic [N-1:0] d,
   output logic [N-1:0] q);

  reg enableDelay;
  always @ (negedge clk) begin
      enableDelay <= enable; //Keep track of the previous value
  end

  wire enableRising = enable && !enableDelay; //enableRising will be high for a single clock cycle at the rising edge of enable

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else if (clr) q <= 0;
    else if (enableDelay) q <= d;

endmodule