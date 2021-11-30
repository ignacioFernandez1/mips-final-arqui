
module adder
  #(parameter N = 64)
  ( input logic [N-1:0] a, b, 
    output logic [N-1:0] out);
  
  assign out = a + b;

endmodule

