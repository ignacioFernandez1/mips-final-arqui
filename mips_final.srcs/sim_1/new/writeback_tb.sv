`timescale 1ns / 1ps

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: %b != %b", signal, value); \
            $finish; \
        end

module writeback_tb();
    logic memtoReg;
    logic [31:0] aluResult, dmemReadData;
    logic [31:0] writeData3;
    
    writeback wb(.memtoReg(memtoReg), .aluResult(aluResult), 
                .dmemReadData(dmemReadData), .writeData3(writeData3));
    
    initial begin
        aluResult = 5; #5;
        dmemReadData = 10; #5;
        
        memtoReg = 0; #5
        `assert(writeData3, aluResult) #5;
        
        memtoReg = 1; #5
        `assert(writeData3, dmemReadData) #5;
        $finish;
    end
endmodule
