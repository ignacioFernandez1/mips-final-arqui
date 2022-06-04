import common::*;

module hazardUnit(
    input [4:0] RsD, RtD, RsE, RtE, 
    input [4:0] writeRegE, writeRegM, writeRegW,
    input regWriteM, regWriteW,
    // input regWriteE,
    // input MemToRegE, MemToRegM, BranchOrJumpRegD,//If Decode is executing Branch or JR or JALR
    // input TakenD,
    output [`HCTL_WIDTH] HCTL);
    
    logic RsD_ne0;
    logic RtD_ne0;
    logic RsE_ne0;
    logic RtE_ne0;
    
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

    // logic lwStallD = MemToRegE & (RtE == RsD | RtE == RtD);
    // //TODO WriteReg is R0?
    // logic branchStallD = BranchOrJumpRegD &
    //     (regWriteE & ((RsD_ne0 & writeRegE == RsD) | (RtD_ne0 & writeRegE == RtD))
    //     |MemToRegM & ((RsD_ne0 & writeRegM == RsD) | (RtD_ne0 & writeRegM == RtD)));
    
    // logic stallD = lwStallD | branchStallD;
    // assign HCTL[`HCTL_STALLD] = stallD;
    // assign HCTL[`HCTL_STALLF] = stallD;
    // assign HCTL[`HCTL_FLUSHE] = stallD;
    
    // assign HCTL[`HCTL_FLUSHD] = ~stallD & TakenD;
    
endmodule
