import common::*;

module datapath_tb();
    
    // Imem I/O
    logic [31:0] inst_in;
    logic op_in; // 0 = escritura de instruccion | 1 = lectura de instruccion 
    logic [31:0] inst_out;
    
    // Datapath I/O
    logic reset, clk;
    logic [`WIDTH_CTL_BUS] ctl;
    logic [31:0] imem_addr;
    logic [5:0] opcode, func;
    
    imem imem(.i(inst_in), .addr(imem_addr), .op(op_in), .q(inst_out));
    controlUnit cu(.opcode(opcode), .func(func), .ctl(ctl));
    datapath dp(.reset(reset), .clk(clk), .ctl(ctl), .instruction(inst_out), .imem_addr(imem_addr), .opcode(opcode), .func(func));
    
    initial begin
        $display("Starting test");
        reset = 0;
        #10
        // ADDU f2, f1, f0:
        op_in = 1;
        imem_addr = 0;
        inst_in = 32'b00000000001000000001000000100001;#10  
        op_in = 0;
        #10
        
        // sUWU f3, f1, f0: 
        op_in = 1;
        imem_addr = 32'd4;
        inst_in = 32'b00000000001000000001100000100011;#10  
        op_in = 0;
        #10
        
        #20
        op_in = 1;
        reset = 1;
        #10
        reset = 0;
        #10
        clk = 1;
        
        
        #240
        $finish;
    end

    
   always 
       #20 clk = ~clk;

endmodule
