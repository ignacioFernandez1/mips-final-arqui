module execute
#(parameter N = 64)
( input logic AluSrc,
                input logic [5:0] AluControl,
                input logic [N-1:0] PC_E, signImm_E, 
                            readData1_E, readData2_E,
                output logic [N-1:0] PCBranch_E, aluResult_E,
                                    writeData_E,
                output logic zero_E);

  logic [N-1:0] adder_a, adder_b, adder_out, alu_a, alu_b,
               alu_out;
  logic [3:0] alu_control;
  logic alu_zero;  

  adder #(N) Add(adder_a, adder_b, adder_out);
  alu ALU(alu_a, alu_b, alu_control, alu_out, alu_zero); 

  always_comb
    begin
      adder_a = PC_E;
      adder_b = signImm_E << 2;
      PCBranch_E = adder_out; 
      alu_control = AluControl;
      alu_a = readData1_E;
      alu_b = AluSrc ? signImm_E : readData2_E;
      aluResult_E = alu_out;
      zero_E = alu_zero;
      writeData_E = readData2_E;
    end
endmodule    


/*
Nombre del Módulo:execute
  Puertos de entrada
    AluSrc: 1 bit
    AluControl: 4 bits
    PC_E: 64 bits
    signImm_E: 64 bits
    readData1_E: 64 bits
    readData2_E: 64 bits
  Puertos de salida
    PCBranch_E: 64 bits
    aluResult_E: 64 bits
    writeData_E: 64 bits
    zero_E: 1 bit
*/
