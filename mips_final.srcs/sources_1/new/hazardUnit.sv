import common::*;

`define HCTL_WIDTH 31: 0

`define HCTL_STALLF 0
`define HCTL_STALLD 1
`define HCTL_STALLE 2
`define HCTL_STALLM 3
`define HCTL_STALLW 4

`define HCTL_FLUSHF 5
`define HCTL_FLUSHD 6
`define HCTL_FLUSHE 7
`define HCTL_FLUSHM 8
`define HCTL_FLUSHW 9

// Forward from Execute to Decode
`define HCTL_FORWARDAD 10
`define HCTL_FORWARDBD 11

// Forward from Memory or Writeback to Execute
`define HCTL_FORWARDAE 13: 12
`define HCTL_FORWARDBE 15: 14
`define FORWARDE_WIDTH 1: 0

`define FORWARDE_NONE 2'b00
`define FORWARDE_FROM_MEMORY 2'b01
`define FORWARDE_FROM_WRITEBACK 2'b10

module hazardUnit(
    input [4:0] RsD, RtD, RsE, RtE, 
    input [4:0] writeRegE, writeRegM, writeRegW,
    input regWriteM, regWriteW, regWriteE,
    input memToRegE, memToRegM, branchOrJumpRegD,
    input PCSrc,
    output [`HCTL_WIDTH] HCTL);
    
    logic RsD_ne0;
    logic RtD_ne0;
    logic RsE_ne0;
    logic RtE_ne0;
    logic lwStallD, branchStallD, stallD;
    
    assign RsD_ne0 = RsD != 5'b0;
    assign RtD_ne0 = RtD != 5'b0;
    assign RsE_ne0 = RsE != 5'b0;
    assign RtE_ne0 = RtE != 5'b0;

    //Forwarding sources to D stage (For Branch)
    assign HCTL[`HCTL_FORWARDAD] = (RsD_ne0 & RsD == writeRegM & regWriteM);
    assign HCTL[`HCTL_FORWARDBD] = (RtD_ne0 & RtD == writeRegM & regWriteM);


    //Forwarding sources to E stage (ALU)
    assign HCTL[`HCTL_FORWARDAE]
        = RsE_ne0 & RsE == writeRegM & regWriteM ? `FORWARDE_FROM_MEMORY
        : RsE_ne0 & RsE == writeRegW & regWriteW ? `FORWARDE_FROM_WRITEBACK
        : `FORWARDE_NONE;
    assign HCTL[`HCTL_FORWARDBE]
        = RtE_ne0 & RtE == writeRegM & regWriteM ? `FORWARDE_FROM_MEMORY
        : RtE_ne0 & RtE == writeRegW & regWriteW ? `FORWARDE_FROM_WRITEBACK
        : `FORWARDE_NONE;

    // si la instruccion en decode usa el mismo registro que el load en execute, hacemos un stall
    assign lwStallD = memToRegE & (RtE == RsD | RtE == RtD);

    assign branchStallD = branchOrJumpRegD &
        (regWriteE & ((RsD_ne0 & writeRegE == RsD) | (RtD_ne0 & writeRegE == RtD))
        |memToRegM & ((RsD_ne0 & writeRegM == RsD) | (RtD_ne0 & writeRegM == RtD)));
    
    assign stallD = lwStallD | branchStallD;
    assign HCTL[`HCTL_STALLD] = stallD;
    assign HCTL[`HCTL_STALLF] = stallD;
    assign HCTL[`HCTL_FLUSHE] = stallD;
    
    assign HCTL[`HCTL_FLUSHD] = ~stallD & PCSrc;
    
endmodule
