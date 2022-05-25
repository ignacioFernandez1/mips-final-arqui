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
        // ADDU f2, f1, f0: 3
        op_in = 1;
        imem_addr = 0;
        inst_in = 32'b00000000001000000001000000100001;#10  
        op_in = 0;
        #10
        
        // SUBU f3, f1, f0: 1
        op_in = 1;
        imem_addr = 32'd4;
        inst_in = 32'b00000000001000000001100000100011;#10  
        op_in = 0;
        #10 

        // JALR f10
        op_in = 1;
        imem_addr = 32'd8;
        inst_in = 32'b00000001010000001111100000001001;#10  
        op_in = 0;
        #10 

        // // JR f10
        // op_in = 1;
        // imem_addr = 32'd8;
        // inst_in = 32'b00000001010000000000000000001000;#10  
        // op_in = 0;
        // #10 
        
        // // JAL 1
        // op_in = 1;
        // imem_addr = 32'd8;
        // inst_in = 32'b00001100000000000000000000000001;#10  
        // op_in = 0;
        // #10  

        // // J 1
        // op_in = 1;
        // imem_addr = 32'd8;
        // inst_in = 32'b00001000000000000000000000000001;#10  
        // op_in = 0;
        // #10    


        // // ADDI f4, f0, 6: 7
        // op_in = 1;
        // imem_addr = 32'd8;
        // inst_in = 32'b00100000000001000000000000000110;#10  
        // op_in = 0;
        // #10

        // // SLTI f5, f0, 6: 1
        // op_in = 1;
        // imem_addr = 32'd12;
        // inst_in = 32'b00101000000001010000000000000110;#10  
        // op_in = 0;
        // #10

        // // LUI f6, 1: 65536
        // op_in = 1;
        // imem_addr = 32'd16;
        // inst_in = 32'b00111100000001100000000000000001;#10  
        // op_in = 0;
        // #10

        // // ANDI f7, f0, 3: 1
        // op_in = 1;
        // imem_addr = 32'd20;
        // inst_in = 32'b00110000000001110000000000000011;#10  
        // op_in = 0;
        // #10

        // // ORI f8, f0, 2: 3
        // op_in = 1;
        // imem_addr = 32'd24;
        // inst_in = 32'b00110100000010000000000000000010;#10  
        // op_in = 0;
        // #10

        // // XORI f9, f0, 1: 0
        // op_in = 1;
        // imem_addr = 32'd28;
        // inst_in = 32'b00111000000010010000000000000000;#10  
        // op_in = 0;
        // #10
        
        #20
        op_in = 1;
        reset = 1;
        #10
        reset = 0;
        #10
        clk = 1;
        
        
        #460
        $finish;
    end

    
   always 
       #20 clk = ~clk;

endmodule
