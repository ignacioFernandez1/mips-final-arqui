module execute
    #(parameter N = 32)
      (input logic AluSrc,
      input logic [3:0] AluControl,
      input logic [4:0] shamt,
      input logic [N-1:0] PC, signImm, readData1, readData2,
      output logic [N-1:0] aluResult, writeData,
      output logic zero);

  logic [N-1:0] alu_a, alu_b,
               alu_out;
  logic [3:0] alu_control;
  logic alu_zero;  

  alu ALU(alu_a, alu_b, alu_control, shamt, alu_out, alu_zero); 

  always_comb
    begin
      alu_control = AluControl;
      alu_a = readData1;
      alu_b = AluSrc ? signImm : readData2;
      aluResult = alu_out;
      zero = alu_zero;
      writeData = readData2;
    end
endmodule    

