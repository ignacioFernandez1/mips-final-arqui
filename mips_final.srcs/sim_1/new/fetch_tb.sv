`define CLK_TIME 10000          //`CLK_TIMEps is the period of 100Mhz

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module fetch_tb();
  logic clk, reset, PCSrc;
  logic [63:0] PCBranch, imem_addr;
  
  fetch fetchi(PCSrc, clk, reset, PCBranch, imem_addr);

  always
    begin
      clk = ~clk;
      #5000;
    end

  
  initial 
    begin
      $display("Starting test");
      clk = 0;
      reset = 1;
      PCSrc = 0;
      PCBranch = 64'hAAAA_BBBB_CCCC_DDDD;
      #(`CLK_TIME * 5);
      reset = 0;
      for(int i = 1; i < 6; i++) begin
        #`CLK_TIME;
        if(imem_addr != i*4) $display("\tBad PC added");
      end
      PCSrc = 1;
      #`CLK_TIME;
      if(imem_addr != PCBranch) $display("\tBad PC on branch source"); 
      $display("Test end");
      $finish;
  end
endmodule
