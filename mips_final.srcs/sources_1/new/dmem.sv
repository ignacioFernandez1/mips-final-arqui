
module dmem
  (input logic clk, memWrite, memRead,
   input logic [31:0] memAddr, writeData,
   output logic [31:0] readData);

  // inicializacion de los Flip-Flops
  logic [31:0] dataMemory [0:255];

  always_ff @(posedge clk)
    begin
      // Write
      if (memWrite && !memRead) dataMemory[memAddr] = writeData;
      // Read
      if (memRead && !memWrite) readData = dataMemory[memAddr];
    end
    
 endmodule  