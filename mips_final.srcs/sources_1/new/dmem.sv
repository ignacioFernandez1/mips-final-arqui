
module dmem
  (input logic clk, MemWrite, MemRead,
   input logic [31:0] memAddr, writeData,
   output logic [31:0] readData);

  // inicializacion de los Flip-Flops
  logic [31:0] dataMemory [0:255];

  always_ff @(posedge clk)
    begin
      // Write
      if (clk && MemWrite && !MemRead) dataMemory[memAddr] = writeData;
      // Read
      if (clk && MemRead && !MemWrite) readData = dataMemory[memAddr];
    end
    
 endmodule  