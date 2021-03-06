
module regfile
  (input logic clk, we3, clock_enable,
   input logic [4:0] ra1, ra2, debug_read_addr, wa3,
   input logic [31:0] wd3,
   output logic [31:0] rd1, rd2, debug_read_data);

  // inicializacion de los Flip-Flops
  logic [31:0] registers [0:31] = {
              32'h0000_0000, 32'h0000_0003, 
              32'h0000_0002, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0004, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000,
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000, 
              32'h0000_0000, 32'h0000_0000 }; 

  always_comb
    begin
      // Read primer registro
      rd1 = (we3 && wa3 == ra1) ? wd3 : registers[ra1];
      // Read segundo registro
      rd2 = (we3 && wa3 == ra2) ? wd3 : registers[ra2];

      debug_read_data = registers[debug_read_addr];
    end  

  always_ff @(posedge clk)
    begin
      // Write
      if (clk && clock_enable && we3) registers[wa3] <= wd3;
    end

endmodule
