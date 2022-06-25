`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2021 08:08:17 PM
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baud_rate
  #(
    parameter rate = 125000
    )
    (
    input wire i_clock,
    output reg tick = 1
    );
    
    localparam CLOCK_HZ = 10000000;
    localparam max_count = CLOCK_HZ / (rate * 16);
    reg [31:0] count  = 0;
    
    always @(posedge i_clock) begin: tick_count
        count <= count + 1;
        if(count == max_count)
        begin
            tick <= 1;
            count <= 0;
        end
        else tick <= 0;
    end
    
endmodule


module Rx
    (
    // INPUTS
    input wire i_clock,
    input wire i_reset,
    input wire rx,
    input wire tick,
    // OUTPUTS
    output reg [7:0] dout,
    output reg rx_done = 0
    );
    
    reg [4:0] tick_count;
    reg [3:0] bit_count;
    reg [7:0] aux_dout;
    
    // LOCAL PARAMETER
    localparam [2:0] STATE_WAITING = 3'b000;
    localparam [2:0] STATE_START = 3'b001;
    localparam [2:0] STATE_DATA = 3'b010;
    localparam [2:0] STATE_PARITY = 3'b011;
    localparam [2:0] STATE_STOP = 3'b100;
    
    // INTERNAL SIGNALS
    reg [2:0] state;
    reg [2:0] next_state = STATE_WAITING;
    
    
    always @(posedge tick) begin 
        case (state)
            STATE_WAITING: begin
                rx_done <= 0;
                aux_dout <= 0;
                bit_count <= 0;
                tick_count <= 0;                
                if(rx == 0) // checkeamos por bit de start
                begin
                    next_state <= STATE_START;
                end    
            end
            
            STATE_START: begin
                rx_done <= 0;
                aux_dout <= 0; // limpiamos registro auxiliar donde guardaremos la trama
                if(tick_count == 7) 
                begin
                    tick_count <= 0;
                    bit_count <= 0;
                    next_state <= STATE_DATA;
                    
                end
                else tick_count <= tick_count + 1;
            end 
               
            STATE_DATA: begin
                rx_done <= 0;            
                if(bit_count == 8) 
                begin
                    dout <= aux_dout; // Asignamos la trama a la salida dout   
                    tick_count <= 0;          
                    next_state <= STATE_PARITY;          
                end                                                                  
                else if (tick_count == 15) 
                begin                   
                    aux_dout <= aux_dout | (rx << bit_count);
                    bit_count <= bit_count + 1;
                    tick_count <= 0; 
                end
                else tick_count <= tick_count + 1; // lo ponemos en else para que no haya conflicto de escritura            
            end
            
            STATE_PARITY: begin
                rx_done <= 0;
                aux_dout <= 0;
                bit_count <= 0;
                if(tick_count == 15)
                begin
                    tick_count <= 0;
                    next_state <= STATE_STOP;   
                end
                else tick_count <= tick_count + 1;    
            end
            
            STATE_STOP: begin
                aux_dout <= 0;
                bit_count <= 0;              
                if(tick_count == 16 && rx == 1) // bit de stop detectado, mandamos tick de dato listo
                begin
                    tick_count <= 0;                    
                    rx_done <= 1;          
                    next_state <= STATE_WAITING;   
                end
                if(tick_count > 16 && rx == 1) // bit de stop no detectado, se descarta la trama
                begin
                    tick_count <= 0;
                    next_state <= STATE_WAITING;  
                end   
                if(tick_count < 17) // Dejamos de aumentar tick_count para que no se pase del limite
                begin
                    tick_count <= tick_count + 1;
                end                                           
            end
            default: begin
                rx_done <= 0;
                aux_dout <= 0;
                bit_count <= 0;
                tick_count <= 0; 
                next_state <= STATE_WAITING;
            end                         
        endcase                                                           
    end
        
    always @(posedge i_clock) begin
        if(i_reset) state <= STATE_WAITING;
        else state <= next_state;
    end
               
endmodule

module Tx
    (
    // INPUTS
    input wire i_clock,
    input wire i_reset,
    input wire tick,
    input wire [7:0] din,
    input wire din_ready,
    // OUTPUTS
    output reg tx,
    output reg tx_sent
    );
    
    reg [4:0] tick_count;
    reg [3:0] bit_count;
    reg [7:0] aux_din;
    reg [10:0] trama; 
    reg dato_esperando;
    reg tick_flag;
    
    // LOCAL PARAMETER
    localparam [1:0] STATE_WAITING = 2'b00;
    localparam [1:0] STATE_LOAD = 2'b01;
    localparam [1:0] STATE_DATA = 2'b10;
    localparam [1:0] STATE_INIT = 2'b11;

    
    // INTERNAL SIGNALS
    reg [1:0] state;
    reg [1:0] next_state = STATE_INIT;
    
    always @(posedge din_ready) begin
        aux_din <= din;
        dato_esperando <= 1;
    end
    
    always @(posedge tick) begin
        tick_count <= tick_count + 1;
        tick_flag <= 1;
        if (tick_count == 16) tick_count <= 0;          
    end    
      
    
    always @(posedge i_clock) begin 
        case (state)
            STATE_INIT: begin
                tick_count <= 0;
                bit_count <= 0;
                aux_din <= 0;
                trama <= 0; 
                dato_esperando <= 0;
                tick_flag <= 0;
                tx <= 1;
                tx_sent <= 0;
                next_state <= STATE_WAITING;            
            end
            STATE_WAITING: begin
                tick_count <= 0;
                bit_count <= 0;
                trama <= 0;
                tick_flag <= 0;
                tx <= 1; 
                if(dato_esperando)
                begin
                    tx_sent <= 0;
                    next_state <= STATE_LOAD;  
                end                  
            end
            
            STATE_LOAD: begin
                trama <= {2'b10,aux_din,1'b0}; //bit_stop - bit_parity - din - bit_start
                dato_esperando <= 0;
                tick_count <= 0;
                bit_count <= 0;
                tick_flag <= 1;
                tx <= 1;
                next_state <= STATE_DATA;                                
            end            
            
            STATE_DATA: begin
                 
                if(tick_count == 0 && tick_flag)
                begin
                   if(bit_count == 11 ) begin
                    tx_sent <= 1;
                    next_state <= STATE_WAITING;
                   end
                   else
                   begin
                       tx <= trama[bit_count];
                       bit_count <= bit_count + 1;
                       tick_flag <= 0;                   
                   end 
                end                                                
            end 
            default: begin
                tick_count <= 0;
                bit_count <= 0;
                aux_din <= 0;
                trama <= 0; 
                dato_esperando <= 0;
                tick_flag <= 0;
                tx <= 1;
                tx_sent <= 0;
                next_state <= STATE_WAITING;            
            end                                  
        endcase                                                           
    end
    
    always @(posedge i_clock) begin
        if(i_reset) state <= STATE_INIT;
        else state <= next_state;
    end
               
endmodule