`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module execute_tb();
logic AluSrc;
logic [5:0] AluControl;
logic [63:0] signImm_E, PC_E, readData1_E, 
readData2_E, PCBranch_E, aluResult_E, writeData_E;
logic zero_E;

execute exec(AluSrc, AluControl, PC_E, signImm_E, 
readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E, zero_E);
 
 initial begin
		//PCBranch_E
		$display("Starting test...");
		
		PC_E = 64'b0010; #5;
		signImm_E = 16'h1; #5;
		$display("Salida esperada, PCBranch_E = 16'h6");
		
		
		PC_E = 16'hFEBF; #5;
		signImm_E = 16'hBF; #5;
		$display("Salida esperada, PCBranch_E = 16'101BB");
		
		PC_E = 64'b0;
		signImm_E = 64'b0;
 
		AluSrc = 0; #5;
		AluControl = 6'b100000; #5;
		readData1_E = 64'b0001; #5;
		readData2_E = 64'b0001; #5;
		$display("Salida esperada, AluResult = 16'h0 y writeData_E = 16'h3");
		$display("AluResult = %b", aluResult_E);
		`assert(aluResult_E, 2)
		
		AluSrc = 0; #5;
		AluControl = 4'b0001; #5;
		readData1_E = 64'b11010100; #5;
		readData2_E = 64'b00101011; #5;
		$display("Salida esperada, AluResult = 16'hFF y writeData_E = 16'h2b");
		
		readData1_E = 64'b0;
 
		AluSrc = 1; #5;
		AluControl = 4'b0000; #5;
		signImm_E = 64'b0111; #5;
		readData1_E = 64'b0111; #5;
		$display("Salida esperada, AluResult = 16'h3' y PCBranch_E = 16'h1C");
		
		AluSrc = 1; #5;
		AluControl = 4'b0000; #5;
		signImm_E = 64'b0111; #5;
		readData1_E = 64'b0111; #5;
		$display("Salida esperada, AluResult = 64b0111' y PCBranch_E = 16'h1C");
		
		
		AluSrc = 1; #5;
		AluControl = 4'b1100; #5;
		signImm_E =   64'b00110111; #5;
		readData1_E = 64'b10010011; #5;
		$display("Salida esperada, AluResult = 64b10100100' y PCBranch_E = 16'-");
	end
endmodule
