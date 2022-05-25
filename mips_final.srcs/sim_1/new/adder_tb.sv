import common::*;
`timescale 1ns / 1ps

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module adder_tb(
    );

    logic [31:0] a,b,out;

    adder add(.a(a), .b(b), .out(out));
    
    initial begin
        a = 32'd8; #5;
        b = 32'b11111111111111111111111111111110 << 2; #5;
        
        $display("a = %b", a);
        $display("b = %b", b);
        $display("out = %b", out);
        `assert(out, 0) #5;

        $finish;
    end

endmodule
