`include "defines.v"

module y86cpu(
    input   wire                clk,
    input   wire                rst,
    input   wire[`INSTBUS]      rom_data_i,
    input   wire[`WORD]         mem_data_i,
    output  wire                mem_read_o,
    output  wire                mem_write_o,
    output  wire[`WORD]         mem_addr_o,
    output  wire[`WORD]         mem_data_o,
    output  wire[`WORD]         rom_addr_o
);

    wire                F_stall;
    wire                D_stall;
    wire                D_bubble;
    wire                E_bubble;
    wire                set_cc;
    wire                M_bubble;
    wire                W_stall;
    
    wire[`WORD]         F_predPC;
    wire[`WORD]         f_pc;
    wire[`NIBBLE]       f_icode;
    wire[`NIBBLE]       f_ifun;
    wire[`NIBBLE]       f_rA;
    wire[`NIBBLE]       f_rB;
    wire[`WORD]         f_valC;
    wire[`WORD]         f_valP;
    wire[`NIBBLE]       f_dstE;
    wire[`NIBBLE]       f_dstM;
    wire[`NIBBLE]       D_icode;
    wire[`NIBBLE]       D_ifun;
    wire[`NIBBLE]       D_rA;
    wire[`NIBBLE]       D_rB;
    wire[`WORD]         D_valC;
    wire[`WORD]         D_valP;
    wire[`NIBBLE]       D_dstE;
    wire[`NIBBLE]       D_dstM;
    wire[`NIBBLE]       d_srcA;
    wire[`NIBBLE]       d_srcB;
    wire[`WORD]         d_rvalA;
    wire[`WORD]         d_rvalB;
    wire[`WORD]         d_valA;
    wire[`WORD]         d_valB;

    wire[`NIBBLE]       E_icode;
    wire[`NIBBLE]       E_ifun;
    wire[`WORD]         E_valA;
    wire[`WORD]         E_valB;
    wire[`WORD]         E_valC;
    wire[`WORD]         E_valP;
    wire[`NIBBLE]       E_dstE;
    wire[`NIBBLE]       E_dstM;
    wire[`WORD]         e_valE;
    wire[`NIBBLE]       e_dstE;
    wire                e_Cnd;

    wire[`NIBBLE]       M_icode;
    wire[`WORD]         M_valA;
    wire[`WORD]         M_valP;
    wire[`WORD]         M_valE;
    wire[`NIBBLE]       M_dstE;
    wire[`WORD]         m_valM;
    wire[`NIBBLE]       M_dstM;
    wire                M_Cnd;

    wire[`NIBBLE]       W_icode;
    wire[`WORD]         W_valE;
    wire[`WORD]         W_valM;
    wire[`NIBBLE]       W_dstE;
    wire[`NIBBLE]       W_dstM;

    F F0(
        .clk(clk),              .rst(rst),
        .F_stall_i(F_stall),
        .f_icode_i(f_icode),
        .f_valC_i(f_valC),      .f_valP_i(f_valP),
        .F_predPC_o(F_predPC)
    );

    select_pc select_pc0(
        .rst(rst),
        .F_predPC_i(F_predPC),
        .M_icode_i(M_icode),    .M_Cnd_i(M_Cnd),
        .M_valA_i(M_valA),
        .W_icode_i(W_icode),    .W_valM_i(W_valM),
        .f_pc_o(f_pc)
    );

    assign rom_addr_o = f_pc;

    f f0(
        .rst(rst),
        .f_pc_i(f_pc),          .inst_i(rom_data_i),
        .f_icode_o(f_icode),    .f_ifun_o(f_ifun),
        .f_rA_o(f_rA),          .f_rB_o(f_rB),
        .f_valC_o(f_valC),      .f_valP_o(f_valP),
        .f_dstE_o(f_dstE),      .f_dstM_o(f_dstM)

    );

    D D0(
        .clk(clk),              .rst(rst),
        .D_stall_i(D_stall),    .D_bubble_i(D_bubble),
        .f_icode_i(f_icode),    .f_ifun_i(f_ifun),
        .f_rA_i(f_rA),          .f_rB_i(f_rB),
        .f_valC_i(f_valC),      .f_valP_i(f_valP),
        .f_dstE_i(f_dstE),      .f_dstM_i(f_dstM),
        .D_icode_o(D_icode),    .D_ifun_o(D_ifun),
        .D_rA_o(D_rA),          .D_rB_o(D_rB),
        .D_valC_o(D_valC),      .D_valP_o(D_valP),
        .D_dstE_o(D_dstE),      .D_dstM_o(D_dstM)
    );

    d d0(
        .rst(rst),
        .D_rA_i(D_rA),          .D_rB_i(D_rB),
        .d_srcA_o(d_srcA),      .d_srcB_o(d_srcB)
    );

    regfile regfile0(
        .clk(clk),              .rst(rst),
        .srcA(d_srcA),          .srcB(d_srcB),
        .dstE(W_dstE),          .dstM(W_dstM),
        .valE(W_valE),          .valM(W_valM),
        .valA(d_rvalA),         .valB(d_rvalB)
    );

    fwd_b fwd_b0(
        .rst(rst),
        .d_srcB_i(d_srcB),      .d_rvalB_i(d_rvalB),
        .e_dstE_i(e_dstE),      .e_valE_i(e_valE),
        .M_dstM_i(M_dstM),      .m_valM_i(m_valM),
        .M_dstE_i(M_dstE),      .M_valE_i(M_valE),
        .W_dstM_i(W_dstM),      .W_valM_i(W_valM),
        .W_dstE_i(W_dstE),      .W_valE_i(W_valE),
        .d_valB_o(d_valB)
    );

    sel_fwd_a sel_fwd_a0(
        .rst(rst),
        .D_icode_i(D_icode),    .D_valP_i(D_valP),
        .d_srcA_i(d_srcA),      .d_rvalA_i(d_rvalA),
        .e_dstE_i(e_dstE),      .e_valE_i(e_valE),
        .M_dstM_i(M_dstM),      .m_valM_i(m_valM),
        .M_dstE_i(M_dstE),      .M_valE_i(M_valE),
        .W_dstM_i(W_dstM),      .W_valM_i(W_valM),
        .W_dstE_i(W_dstE),      .W_valE_i(W_valE),
        .d_valA_o(d_valA)
    );

    E E0(
        .clk(clk),  .rst(rst),
        .E_bubble_i(E_bubble),
        .D_icode_i(D_icode),        .D_ifun_i(D_ifun),
        .d_valA_i(d_valA),      .d_valB_i(d_valB),
        .D_valC_i(D_valC),      .D_valP_i(D_valP),
        .D_dstE_i(D_dstE),      .D_dstM_i(D_dstM),
        .E_icode_o(E_icode),        .E_ifun_o(E_ifun),
        .E_valA_o(E_valA),  .E_valB_o(E_valB),
        .E_valC_o(E_valC),  .E_valP_o(E_valP),
        .E_dstE_o(E_dstE),      .E_dstM_o(E_dstM)
    );

    e e0(
        .rst(rst),
        .E_icode_i(E_icode),        .E_ifun_i(E_ifun),
        .E_valA_i(E_valA),      .E_valB_i(E_valB),
        .E_valC_i(E_valC),      .E_dstE_i(E_dstE),
        .e_valE_o(e_valE),      .e_dstE_o(e_dstE),
        .e_Cnd_o(e_Cnd)
    );

    M M0(
        .clk(clk),              .rst(rst),
        .M_bubble_i(M_bubble),
        .E_icode_i(E_icode),
        .E_valA_i(E_valA),  .E_valP_i(E_valP),
        .e_valE_i(e_valE),
        .e_dstE_i(e_dstE),      .E_dstM_i(E_dstM),
        .e_Cnd_i(e_Cnd),
        .M_icode_o(M_icode),
        .M_valA_o(M_valA),      .M_valP_o(M_valP),
        .M_valE_o(M_valE),
        .M_dstE_o(M_dstE),      .M_dstM_o(M_dstM),
        .M_Cnd_o(M_Cnd)
    );

    m m0(
        .rst(rst),
        .M_icode_i(M_icode),
        .M_valA_i(M_valA),      .M_valP_i(M_valP),
        .M_valE_i(M_valE),
        .valM_i(mem_data_i),
        .mem_read(mem_read_o),  .mem_write(mem_write_o),
        .mem_addr(mem_addr_o),  .mem_data(mem_data_o),
        .m_valM_o(m_valM)
    );

    W W0(
        .clk(clk),              .rst(rst),
        .W_stall_i(W_stall),
        .M_icode_i(M_icode),
        .M_valE_i(M_valE),      .m_valM_i(m_valM),
        .M_dstE_i(M_dstE),      .M_dstM_i(M_dstM),
        .W_icode_o(W_icode),
        .W_valE_o(W_valE),      .W_valM_o(W_valM),
        .W_dstE_o(W_dstE),      .W_dstM_o(W_dstM)
    );

    pipe_control_logic pipe_control_logic1(
        .D_icode_i(D_icode),
        .d_srcA_i(d_srcA),      .d_srcB_i(d_srcB),
        .E_icode_i(E_icode),
        .E_dstE_i(E_dstE),      .E_dstM_i(E_dstM),
        .e_Cnd_i(e_Cnd),
        .M_icode_i(M_icode),
        .F_stall_o(F_stall),
        .D_stall_o(D_stall),    .D_bubble_o(D_bubble),
        .E_bubble_o(E_bubble),
        .set_cc_o(set_cc),
        .M_bubble_o(M_bubble),
        .W_stall_o(W_stall)
    );

endmodule
