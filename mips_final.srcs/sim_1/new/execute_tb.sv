import common::*;

module execute_tb();

    logic AluSrc;
    logic [3:0] AluControl;
    logic [31:0] signImm_E, PC_E, readData1_E,
    readData2_E, PCBranch_E, aluResult_E, writeData_E;
    logic [4:0] shamt;
    logic zero_E;
    
    execute exec(AluSrc, AluControl, shamt, PC_E, signImm_E, 
    readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E, zero_E);
     
     initial begin
            //PCBranch_E
            $display("Starting test...");
            
            PC_E = 32'b0010; #5;
            signImm_E = 16'h1; #5;
            $display("Salida esperada, PCBranch_E = 16'h6");
            
            
            PC_E = 16'hFEBF; #5;
            signImm_E = 16'hBF; #5;
            $display("Salida esperada, PCBranch_E = 16'101BB");
            
            PC_E = 32'b0;
            signImm_E = 32'b0;
            
            // -----------------------------------------------------------
            // TESTS DE ALGUNAS OPERACIONES DE ALU
            // -----------------------------------------------------------
            
            // SLL
            AluSrc = 0; #5;
            AluControl = `ALU_SLL; #5;
            readData2_E = 32'b0001; #5;
            shamt = 5'b0010; #5;
            $display("Salida esperada, AluResult = 4");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 4)
            
            // SRL
            AluSrc = 0; #5;
            AluControl = `ALU_SRL; #5;
            readData2_E = 32'b1100; #5;
            shamt = 5'b0010; #5;
            $display("Salida esperada, AluResult = 3");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 3)
            
            // SRA
            AluSrc = 0; #5;
            AluControl = `ALU_SRA; #5;
            readData2_E = 32'b1100; #5;
            shamt = 5'b0010; #5;
            $display("Salida esperada, AluResult = 3");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 3)
            
            // SLLV Y SRLV ver AluControl (?)
            
            // ADDU
            AluSrc = 0; #5;
            AluControl = `ALU_ADDU; #5;
            readData1_E = 32'b0001; #5;
            readData2_E = 32'b0001; #5;
            $display("Salida esperada, AluResult = 2");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 2)
            
            // SUBU
            AluSrc = 0; #5;
            AluControl = `ALU_SUBU; #5;
            readData1_E = 32'b0011; #5;
            readData2_E = 32'b0010; #5;
            $display("Salida esperada, AluResult = 1");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 1)
            
            // OR
            AluSrc = 0; #5;
            AluControl = `ALU_OR; #5;
            readData1_E = 32'b0101; #5;
            readData2_E = 32'b0010; #5;
            $display("Salida esperada, AluResult = 7");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 7)
            
            // SLT true
            AluSrc = 0; #5;
            AluControl = `ALU_SLT; #5;
            readData1_E = 32'b0001; #5;
            readData2_E = 32'b0011; #5;
            $display("Salida esperada, AluResult = 1");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 1)
            
            // SLT false
            AluSrc = 0; #5;
            AluControl = `ALU_SLT; #5;
            readData1_E = 32'b0101; #5;
            readData2_E = 32'b0011; #5;
            $display("Salida esperada, AluResult = 0");
            $display("AluResult = %0d", aluResult_E);
            `assert(aluResult_E, 0)
            
            // zero signal = true
            AluSrc = 0; #5;
            AluControl = `ALU_SUBU; #5;
            readData1_E = 32'b0010; #5;
            readData2_E = 32'b0010; #5;
            $display("Salida esperada, zero = 1");
            $display("zero = %0d", zero_E);
            `assert(zero_E, 1)
            
            // zero signal = false
            AluSrc = 0; #5;
            AluControl = `ALU_SUBU; #5;
            readData1_E = 32'b0010; #5;
            readData2_E = 32'b0011; #5;
            $display("Salida esperada, zero = 0");
            $display("zero = %0d", zero_E);
            `assert(zero_E, 0)
            
    //		AluSrc = 0; #5;
    //		AluControl = 6'b100000; #5; // add
    //		readData1_E = 32'b0001; #5;
    //		readData2_E = 32'b0001; #5;
    //		$display("Salida esperada, AluResult = 16'h0 y writeData_E = 16'h3");
    //		$display("AluResult = %b", aluResult_E);
    //		`assert(aluResult_E, 2)
            
    //		readData1_E = 32'b0;
     
    //		AluSrc = 1; #5;
    //		AluControl = 4'b0000; #5;
    //		signImm_E = 32'b0111; #5;
    //		readData1_E = 32'b0111; #5;
    //		$display("Salida esperada, AluResult = 16'h3' y PCBranch_E = 16'h1C");
            
    //		AluSrc = 1; #5;
    //		AluControl = 4'b0000; #5;
    //		signImm_E = 32'b0111; #5;
    //		readData1_E = 32'b0111; #5;
    //		$display("Salida esperada, AluResult = 3232b0111' y PCBranch_E = 16'h1C");
            
            
    //		AluSrc = 1; #5;
    //		AluControl = 4'b1100; #5;
    //		signImm_E =   64'b00110111; #5;
    //		readData1_E = 32'b10010011; #5;
    //		$display("Salida esperada, AluResult = 32b10100100' y PCBranch_E = 16'-");
        end
endmodule
