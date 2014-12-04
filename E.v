`include "defines.v"
module E(
    input   wire                clk,
    input   wire                rst,
    input   wire                E_bubble_i,

    input   wire[`NIBBLE]       D_icode_i,
    input   wire[`NIBBLE]       D_ifun_i,
    input   wire[`WORD]         d_valA_i,
    input   wire[`WORD]         d_valB_i,
    input   wire[`WORD]         D_valC_i,
    input   wire[`WORD]         D_valP_i,
    input   wire[`NIBBLE]       D_dstE_i,
    input   wire[`NIBBLE]       D_dstM_i,

    output  reg[`NIBBLE]        E_icode_o,
    output  reg[`NIBBLE]        E_ifun_o,
    output  reg[`WORD]          E_valA_o,
    output  reg[`WORD]          E_valB_o,
    output  reg[`WORD]          E_valC_o,
    output  reg[`WORD]          E_valP_o,
    output  reg[`NIBBLE]        E_dstE_o,
    output  reg[`NIBBLE]        E_dstM_o
);

    always @ (posedge clk) begin
        if( E_bubble_i==`ENABLE ) begin
            E_icode_o   <=      `INOP;
            E_dstE_o    <=      `RNONE;
            E_dstM_o    <=      `RNONE;
        end
        else begin
            E_icode_o   <=      D_icode_i;
            E_ifun_o    <=      D_ifun_i;
            E_valA_o    <=      d_valA_i;
            E_valB_o    <=      d_valB_i;
            E_valC_o    <=      D_valC_i;
            E_valP_o    <=      D_valP_i;
            E_dstE_o    <=      D_dstE_i;
            E_dstM_o    <=      D_dstM_i;
        end
    end
endmodule
