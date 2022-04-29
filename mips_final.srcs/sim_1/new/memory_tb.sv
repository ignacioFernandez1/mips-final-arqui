`define CLK_TIME 10000          //`CLK_TIMEps is the period of 100Mhz

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: %b != %b", signal, value); \
            $finish; \
        end

module memory_tb();
  logic clk = 1;
  logic branch, zero, MemWrite, MemRead, PCSrc;
  logic [31:0] aluResult, writeData, readData;
  
  memory memoryDUT(.branch(branch), .clk(clk), .zero(zero), .MemWrite(MemWrite), .MemRead(MemRead), .PCSrc(PCSrc), 
                    .aluResult(aluResult), .writeData(writeData), .readData(readData));

  
  initial 
    begin
      $display("Starting test");
      // test pcsrc = 1
      zero = 1; #5
      branch = 1; #5;
      `assert(PCSrc, 1)
      
      // test pcsrc = 0
      zero = 0; #5
      branch = 1; #5;
      `assert(PCSrc, 0)
       
      // writing data
      writeData = 32'b100; #5;
      aluResult = 32'b010; #5;
      MemRead = 0; #5;
      MemWrite = 1; #100;
      MemWrite = 0; #5;
      
      // reading data
      aluResult = 32'b010; #5;
      MemRead = 1; #100;
      `assert(readData, 32'b100)
      $display("Expected data = %b\nreadData = %b", 32'b100, readData);
      
      $finish;
  end
  
   always 
       #20 clk = ~clk;
endmodule