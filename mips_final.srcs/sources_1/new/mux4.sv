// 4:1 MULTIPLEXOR

module mux4 #(parameter N = 32)
				(input logic [N-1:0] d0, d1, d2, d3,
				input logic [1:0] s,
				output logic [N-1:0] y);
	always_comb begin
		case(s)
			2'b0: y = d0;
			2'b1: y = d1;
			2'b10: y = d2;
			2'b11: y = d3;
			default: ;
		endcase
	end
endmodule
