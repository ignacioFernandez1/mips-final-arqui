`timescale 1ns / 1ps

module intf
  #(
    parameter N_BITS = 8
  )
  (
    input wire i_clock,
    input wire i_reset,
    input wire [N_BITS-1:0]data,
    input wire data_ready,
    input wire [N_BITS-1:0]alu_result,
    output reg [N_BITS-1:0]data0, 
    output reg [N_BITS-1:0]data1, 
    output reg [5:0]code, 
    output reg [N_BITS-1:0]dout,
    output reg dout_ready           
    );
    
     // LOCAL PARAMETER
    localparam [2:0] STATE_DATO0 = 3'b000;
    localparam [2:0] STATE_DATO1 = 3'b001;
    localparam [2:0] STATE_DATO2 = 3'b010;
    localparam [2:0] STATE_ALU = 3'b011;
    localparam [2:0] STATE_INIT = 3'b100;
    
    

    
    // INTERNAL SIGNALS
    reg [2:0] state;
    reg [2:0] next_state = STATE_INIT;
    reg dato_flag;
    
    always @(posedge data_ready) begin
        dato_flag <= 1;
    end        
    
    always @(posedge i_clock) begin 
        case (state)
            STATE_INIT: begin
                dato_flag <= 0;
                data0 <= 0;
                data1 <= 0;
                code <= 0;
                dout <= 0;
                dout_ready <= 0;
                next_state <= STATE_DATO0;                
            end
            STATE_DATO0: begin
                dout_ready <= 0;
                data1 <= 0;
                code <= 0;
                dout <= 0;
                dout_ready <= 0;                    
                if (dato_flag)
                begin
                    data0 <= data;
                    dato_flag <= 0;
                    next_state <= STATE_DATO1;  
                end    
            end
            
            STATE_DATO1: begin
                code <= 0;
                dout <= 0;
                dout_ready <= 0;             
                if (dato_flag)
                begin
                    data1 <= data;
                    dato_flag <= 0;
                    next_state <= STATE_DATO2;  
                end    
            end                  
            STATE_DATO2: begin
                dout <= 0;
                dout_ready <= 0;                   
                if (dato_flag)
                begin
                    code <= data[5:0];
                    dato_flag <= 0;
                    next_state <= STATE_ALU;  
                end    
            end
            
            STATE_ALU: begin
                dout <= alu_result;
                dout_ready <= 1;
                next_state <= STATE_DATO0;            
            end
            default: begin
                dato_flag <= 0;
                data0 <= 0;
                data1 <= 0;
                code <= 0;
                dout <= 0;
                dout_ready <= 0;
                next_state <= STATE_INIT;             
            end                                               
        endcase                                                           
    end
    
    always @(posedge i_clock) begin
        if(i_reset) state <= STATE_DATO0;
        else state <= next_state;
    end    
    
    
endmodule