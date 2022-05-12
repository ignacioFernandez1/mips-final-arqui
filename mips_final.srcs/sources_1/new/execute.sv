module execute
    #(parameter N = 32)
      (input logic AluSrc,
      input logic [3:0] AluControl,
      input logic [4:0] shamt,
      input logic [N-1:0] PC, signImm, readData1, readData2,
      output logic [N-1:0] PCBranch, aluResult, writeData,
      output logic zero);

  logic [N-1:0] adder_a, adder_b, adder_out, alu_a, alu_b,
               alu_out;
  logic [5:0] alu_control;
  logic alu_zero;  

  adder #(N) Add(adder_a, adder_b, adder_out);
  alu ALU(alu_a, alu_b, alu_control, shamt, alu_out, alu_zero); 

  always_comb
    begin
      adder_a = PC;
      adder_b = signImm << 2;
      PCBranch = adder_out; 
      alu_control = AluControl;
      alu_a = readData1;
      alu_b = AluSrc ? signImm : readData2;
      aluResult = alu_out;
      zero = alu_zero;
      writeData = readData2;
    end
endmodule    

