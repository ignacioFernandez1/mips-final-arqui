import common::*;

module datapath_tb();
    
    reg    clk;
    reg [7:0] data;
    integer   fd;
    integer   code;
    logic i_clock, halt_instr_signal;
    logic [2:0] finish;
    logic finish_flag;


    // TOP I/O
    logic op_in, clock_enable;
    logic [31:0] inst_in;
    logic [31:0]  imem_addr;
    logic reset;
    
    top_synt top (.clk_in(clk), .op_in(op_in), .imem_addr_in(imem_addr), 
            .inst_in(inst_in), .i_reset(reset), .o_locked(o_locked), .clock_enable(clock_enable),
            .halt_instr_signal(halt_instr_signal));

    initial begin
        $display("Starting test");
        reset = 0;
        clock_enable = 0;
        clk = 1;
        #200
        // ADDI f2, f1, 10: 8
        op_in = 1;
        #100
        imem_addr = 0;
        inst_in = 32'b00000000001000100010100000100001;
        #100
        op_in = 0;
        #200
        
        // JR f2 (fw desde memory)
        op_in = 1;
        #100
        imem_addr = 32'd4;
        inst_in = 32'b10101100000001010000000000000000;
        #100  
        op_in = 0;
        #200
        
        // ADDU f3, f0, f1: 3 
        op_in = 1;
        #100 
        imem_addr = 32'd8;
        inst_in = 32'b10001100000001100000000000000000;#10  
        op_in = 0;
        #200

        // ADDU f3, f0, f1: 3 
        op_in = 1;
        #100  
        imem_addr = 32'd12;
        inst_in = 32'b00000000110000100100000000100001;#10  
        op_in = 0;
        #200
        
        // ADDU f4, f0, f1: 3 
        op_in = 1;
        #100  
        imem_addr = 32'd16;
        inst_in = 32'b00000000001000100011100000100001;#10  
        op_in = 0;
        #200

        // ADDU f5, f0, f1: 3 
        op_in = 1;
        #100  
        imem_addr = 32'd20;
        inst_in = 32'b00000000000000000000000000000000;#10  
        op_in = 0;
        #200
        
        #200
        op_in = 1;
        #100  
        imem_addr = 32'd4;
        #200
        wait(o_locked);
        #200
        clock_enable = 1;
        #100  
        reset = 1;
        #200
        reset = 0;
        #200

    
        // wait(halt_instr_signal);
        #6000
        $finish;
    end

    
   always 
       #20 clk = ~clk;

endmodule
