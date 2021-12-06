

module imem
  #(parameter N = 32)
  ( input logic [N-1:0] i, // instruccion a escribir en la memoria
    input logic [5:0] addr, // direccion a donde buscar la instruccion
    input logic op, // 0 = escritura de instruccion | 1 = lectura de instruccion 
    output logic [N-1:0] q);
    
    
        // LOCAL PARAMETER
   localparam WRITE = 0;
   localparam READ = 1;
      
   logic [31:0] rom [63:0];
                             

   
    always_comb
     begin 
        if (op == READ && addr > 63) q = 0;
        else if(op == READ && addr < 63) q = rom[addr];
        if (op == WRITE && addr < 63) rom[addr] = i;
    end
  

      

endmodule