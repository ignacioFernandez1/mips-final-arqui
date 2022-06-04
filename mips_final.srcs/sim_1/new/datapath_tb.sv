import common::*;

module datapath_tb();
    
    
    // TOP I/O
    logic reset, clk;
    
    top top (.clk_in(clk), .i_reset(reset));

    initial begin
        $display("Starting test");
        reset = 0;
        clk = 1;
        #10
        // ADDU f2, f1, f0: 3
        top.op_in = 1;
        top.imem_addr = 0;
        top.inst_in = 32'b00000000001000000001000000100001;#10  
        top.op_in = 0;
        #10
        
        // ADDU f3, f2, f0: 4 (fw desde memory)
        top.op_in = 1;
        top.imem_addr = 32'd4;
        top.inst_in = 32'b00000000010000000001100000100001;#10  
        top.op_in = 0;
        #10
        
        // ADDU f4, f0, f2: 4 (fw desde w)
        top.op_in = 1;
        top.imem_addr = 32'd8;
        top.inst_in = 32'b00000000000000100010000000100001;#10  
        top.op_in = 0;
        #10
        
        
//        // SW f1, 0(f10)
//        top.op_in = 1;
//        top.imem_addr = 32'd8;
//        top.inst_in = 32'b10101101010000010000000000000000;#10  
//        top.op_in = 0;
//        #10
                  
//        // SH f1, 4(f10)
//        top.op_in = 1;
//        top.imem_addr = 32'd12;
//        top.inst_in = 32'b10100101010000010000000000000100;#10  
//        top.op_in = 0;
//        #10

//        // SB f1, 8(f10)
//        top.op_in = 1;
//        top.imem_addr = 32'd16;
//        top.inst_in = 32'b10100001010000010000000000001000;#10  
//        top.op_in = 0;
//        #10

//        // LW f5, 0(f10)
//        top.op_in = 1;
//        top.imem_addr = 32'd20;
//        top.inst_in = 32'b10001101010001010000000000000000;#10  
//        top.op_in = 0;
//        #10 

//        // LHU f6, 0(f10)
//        top.op_in = 1;
//        top.imem_addr = 32'd24;
//        top.inst_in = 32'b10010101010001100000000000000000;#10  
//        top.op_in = 0;
//        #10 
        
//        // LH f7, 0(f10)
//        top.op_in = 1;
//        top.imem_addr = 32'd28;
//        top.inst_in = 32'b10000101010001110000000000000000;#10  
//        top.op_in = 0;
//        #10  

        // // LBU f6, 0(f10)
        // op_in = 1;
        // top.imem_addr = 32'd24;
        // inst_in = 32'b10010001010001100000000000000000;#10  
        // op_in = 0;
        // #10 
        
        // // LB f7, 0(f10)
        // op_in = 1;
        // imem_addr = 32'd28;
        // inst_in = 32'b10000001010001110000000000000000;#10  
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
        top.op_in = 1;
        reset = 1;
        #10
        reset = 0;

        
        
        #2000
        $finish;
    end

    
   always 
       #20 clk = ~clk;

endmodule
