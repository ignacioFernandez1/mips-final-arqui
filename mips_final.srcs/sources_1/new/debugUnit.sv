import common::*;

`define MODE_DEBUG = 8'b0;
`define MODE_NORMAL = 8'b1;

/*
    La debug unit sigue el siguiente formato:
        - Los primeros 8 bits recibidos indican el modo en el que el procesador va a funcionar
        - Luego espera que se le envien las instrucciones de 32 bits, hasta que llega la ultima (HALT o 32'b0)
        - Por ultimo inicia el procesador enviando el clock dependiendo del modo
*/

module debugUnit(
    input wire i_clock, i_reset, rx,
    input logic [31:0] debug_read_data_reg,
    input logic [31:0] debug_read_data_mem,
    input logic [31:0] debug_pc,
    output reg tx, du_clock, du_imem_op, imem_addr_select,
    output reg [31:0] du_imem_address, du_instr,
    output logic [4:0] debug_read_addr_reg,
    output logic [31:0] debug_read_addr_mem
    );

    logic dtx_ready, rx_done;
    logic [7:0] dtx, drx;
    logic [2:0] state;
    logic [2:0] next_state;
    logic [7:0] mode;
    logic [31:0] instr;
    logic [1:0] i;
    logic clock_enable;

    localparam IMEM_WRITE = 0;
    localparam IMEM_READ = 1;

    localparam STATE_INIT = 3'b000;
    localparam STATE_INSTR_RCV = 3'b001;
    localparam STATE_INSTR_WRITE = 3'b010;
    localparam STATE_INSTR_FINISHED = 3'b011;

    top_uart uart(.i_clock(i_clock), .i_reset(i_reset), .rx_top(rx), .dtx_ready(dtx_ready),
                  .dtx(dtx), .tx_top(tx), .rx_done(rx_done), .drx(drx));

    assign du_clock = i_clock & clock_enable;
    
    always @(posedge i_clock) begin
        if(i_reset) next_state <= STATE_INIT;
        else state <= next_state;
        if (state == STATE_INSTR_WRITE) begin
            i <= 3;
            du_instr <= instr;
            du_imem_op <= IMEM_WRITE;
            // esto en la sintezis no va a funcionar
            state <= STATE_INSTR_RCV;
            next_state <= STATE_INSTR_RCV;
        end
        if (du_instr == 0) begin
            clock_enable <= 1;
            imem_addr_select <= 1;
            du_imem_op <= IMEM_READ;
            next_state <= STATE_INSTR_FINISHED;
        end
        if (state == STATE_INIT) begin
            instr <= 0;
            i <= 3;
            du_imem_op <= IMEM_READ;
            du_imem_address <= -4;
            clock_enable <= 0;
            imem_addr_select <= 0;
        end
    end
    
    always_ff @( posedge rx_done) begin
        case (state)
            STATE_INIT:
            begin
                next_state <= STATE_INSTR_RCV;
                mode <= drx;
                instr <= 0;
                i <= 3;
                du_imem_op <= IMEM_READ;
                du_imem_address <= -4;
                clock_enable <= 0;
                imem_addr_select <= 0;
            end
            STATE_INSTR_RCV:
            begin
                du_imem_op = IMEM_READ;
                instr[(i*8) +: 8] <= drx;
                if (i == 0) begin
                    next_state <= STATE_INSTR_WRITE;
                    du_imem_address <= du_imem_address + 4;
                end
                else  i <= i - 1;
            end
            STATE_INSTR_WRITE:
            begin
                
            end
            STATE_INSTR_FINISHED: ;
            default: next_state <= STATE_INIT;
        endcase
    end
    
endmodule
