// TODO: fix common import
`define MEMWIDTH_8 2'b10
`define MEMWIDTH_16 2'b01
`define MEMWIDTH_32 2'b00

module dmem
  (input logic clk, memWrite, memRead, memSign,
   input logic [1:0] memWidth,
   input logic [31:0] memAddr, writeData, debug_read_addr,
   output logic [31:0] readData, debug_read_data);
      
  // inicializacion de los Flip-Flops
  logic [31:0] dataMemory [0:255];
  
  logic [31:0] alignedAddr;
  logic [31:0] debug_alignedAddr;

  assign alignedAddr = memAddr/4;
  assign debug_alignedAddr = debug_read_addr/4;  

  always_ff @(posedge clk)
    begin
      // Read
      debug_read_data = dataMemory[debug_alignedAddr];
      if (memRead && !memWrite)
      begin
        case(memWidth)
          `MEMWIDTH_8:
          begin
            case (memAddr[1: 0])
              0: readData = {{24{memSign & dataMemory[alignedAddr][7]}}, dataMemory[alignedAddr][7: 0]};
              1: readData = {{24{memSign & dataMemory[alignedAddr][15]}}, dataMemory[alignedAddr][15: 8]};
              2: readData = {{24{memSign & dataMemory[alignedAddr][23]}}, dataMemory[alignedAddr][23: 16]};
              3: readData = {{24{memSign & dataMemory[alignedAddr][31]}}, dataMemory[alignedAddr][31: 24]};
            endcase
          end

          `MEMWIDTH_16:
          begin
            case(memAddr[1])
              0: readData = {{16{memSign & dataMemory[alignedAddr][15]}}, dataMemory[alignedAddr][15: 0]};
              1: readData = {{16{memSign & dataMemory[alignedAddr][31]}}, dataMemory[alignedAddr][31: 16]};
            endcase
          end
        
          `MEMWIDTH_32: readData = dataMemory[alignedAddr]; 

          default: readData = dataMemory[alignedAddr];
        endcase
      end

      // Write
      if (memWrite && !memRead)
      begin
        case (memWidth)
          `MEMWIDTH_8: 
          begin
              case (memAddr[1: 0])
              0: dataMemory[alignedAddr][7: 0] <= writeData[7:0];
              1: dataMemory[alignedAddr][15: 8] <= writeData[7:0];
              2: dataMemory[alignedAddr][23: 16] <= writeData[7:0];
              3: dataMemory[alignedAddr][31: 24] <= writeData[7:0];
              endcase
          end
          
          `MEMWIDTH_16:
          begin
            case(memAddr[1])
              0: dataMemory[alignedAddr][15: 0] <= writeData[15: 0];
              1: dataMemory[alignedAddr][31: 16] <= writeData[15: 0];
            endcase
          end
          
          `MEMWIDTH_32: dataMemory[alignedAddr] <= writeData;
          
          default: dataMemory[alignedAddr] <= dataMemory[alignedAddr];
          endcase
      end
    end
    
 endmodule  