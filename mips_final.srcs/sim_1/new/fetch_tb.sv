`define CLK_TIME 100         //`CLK_TIMEps is the period of 100Mhz

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: %b != %b", signal, value); \
            $finish; \
        end

module fetch_tb();
  logic clk, reset, PCSrc;
  logic [31:0] PCBranch, imem_addr;
  
  fetch fetchi(PCSrc, clk, reset, PCBranch, imem_addr);

  always
    begin
      clk = ~clk;
      #50;
    end

  
  initial 
    begin
      $display("Starting test");
      clk = 0;
      reset = 1;
      PCSrc = 0;
      PCBranch = 32'hCCCC_DDDD;
      #(`CLK_TIME * 5);
      reset = 0;
      for(int i = 1; i < 6; i++) begin
        #`CLK_TIME;
        `assert(imem_addr, i*4)
        if(imem_addr == i*4) $display("\tGood PC added");
      end
      PCSrc = 1;
      #`CLK_TIME;
      `assert(imem_addr, PCBranch)
      if(imem_addr == PCBranch) $display("\tGood PC on branch source"); 
      $display("Test end");
      $finish;
  end
endmodule
