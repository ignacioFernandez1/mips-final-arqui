`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: %b != %b",signal, value ); \
            $finish; \
        end

module decode_tb();
logic regWrite, clk = 1;
logic [31:0] writeData3, instr, signExt, readData1, readData2;
logic [4:0] wa3;
		
decode dec(.regWrite(regWrite),.clk(clk),.wa3(wa3),.writeData3(writeData3),.instr(instr),
.signExt(signExt), .readData1(readData1),.readData2(readData2));
	
 initial begin
		$display("Starting test...");
		
		wa3 = 5'b00000; #5;
		writeData3 = 32'b0011; #5;
		regWrite = 1; #40;
        regWrite = 0; #5;
        
 		wa3 = 5'b00001; #5;
		writeData3 = 32'b1100; #5;
		regWrite = 1; #40;
		regWrite = 0; #5;
        instr = 32'b0000_0000_0000_0001_0000_0000_0000_0000; #5;
        
		`assert(readData1, 32'b0011)
		`assert(readData2, 32'b1100)
		
		instr = 32'b0000_0000_0000_0001_1000_0000_1111_0000; #5;
		
		`assert(signExt, 32'b1111_1111_1111_1111_1000_0000_1111_0000)
		
		instr = 32'b0010_0000_1111_0100_0000_0000_1111_0000; #5;
		
		`assert(signExt, 32'b1111_0000)
		
		$display("TEST PASSED SUCCESFULLY");
		$finish;
    end

    always 
       #20 clk = ~clk;
   
endmodule
