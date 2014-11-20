`include "defines.v"

module y86cpu(
	input	wire			clk,
	input	wire			rst,
	input	wire[`INSTBUS]	rom_data_i,
	input	wire[`WORD]		mem_data_i,
	output	wire			mem_read_o,
	output	wire			mem_write_o,
	output	wire[`WORD]		mem_addr_o,
	output	wire[`WORD]		mem_data_o,
	output	wire[`WORD]		rom_addr_o
);

	wire[`WORD]			pc;
	wire[`WORD]			id_pc_i;
	wire[`INSTBUS]		id_inst_i;

    wire[`BYTE]			f_icode;
    wire[`BYTE]			f_ifun;
    wire[`BYTE]			f_rA;
    wire[`BYTE]			f_rB;
    wire[`WORD]			f_valC;
    wire[`WORD]			f_valP;
    wire[`BYTE]			f_dstE;
    wire[`BYTE]			f_dstM;
    wire[`BYTE]			D_icode;
    wire[`BYTE]			D_ifun;
    wire[`BYTE]			D_rA;
    wire[`BYTE]			D_rB;
    wire[`WORD]			D_valC;
    wire[`WORD]			D_valP;
    wire[`BYTE]			D_dstE;
    wire[`BYTE]			D_dstM;
	wire[`BYTE]			d_srcA;
	wire[`BYTE]			d_srcB;
	wire[`WORD]			d_rvalA;
	wire[`WORD]			d_rvalB;
	wire[`WORD]			d_valA;
	wire[`WORD]			d_valB;
	wire[`BYTE]			id_dstE_o;
	wire[`BYTE]			id_dstM_o;

	wire[`BYTE]			ex_icode_i;
	wire[`BYTE]			ex_ifun_i;
	wire[`WORD]			ex_valA_i;
	wire[`WORD]			ex_valB_i;
	wire[`WORD]			ex_valC_i;
	wire[`WORD]			ex_valP_i;
	wire[`BYTE]			ex_dstE_i;
	wire[`BYTE]			ex_dstM_i;
	wire[`WORD]			e_valE;
	wire[`BYTE]			e_dstE;
	wire[`BYTE]			ex_dstM_o;

	wire[`BYTE]			mem_icode_i;
	wire[`WORD]			mem_valA_i;
	wire[`WORD]			mem_valP_i;
	wire[`WORD]			M_valE;
	wire[`BYTE]			M_dstE;
	wire[`WORD]			m_valM;
	wire[`BYTE]			M_dstM;

	wire[`WORD]			W_valE;
	wire[`WORD]			W_valM;
	wire[`BYTE]			W_dstE;
	wire[`BYTE]			W_dstM;

	pc_reg pc_reg0(
		.clk(clk),				.rst(rst),
		.newPC(D_valP),			.pc(pc)
	);

	assign rom_addr_o = pc;

	f f0(
		.rst(rst),	.pc_i(pc),	.inst_i(rom_data_i),
		.f_icode_o(f_icode),	.f_ifun_o(f_ifun),
		.f_rA_o(f_rA),			.f_rB_o(f_rB),
		.f_valC_o(f_valC),		.f_valP_o(f_valP),
		.f_dstE_o(f_dstE),		.f_dstM_o(f_dstM)

	);

	D D0(
		.clk(clk),				.rst(rst),
		.f_icode_i(f_icode),	.f_ifun_i(f_ifun),
		.f_rA_i(f_rA),			.f_rB_i(f_rB),
		.f_valC_i(f_valC),		.f_valP_i(f_valP),
		.f_dstE_i(f_dstE),		.f_dstM_i(f_dstM),
		.D_icode_o(D_icode),	.D_ifun_o(D_ifun),
		.D_rA_o(D_rA),			.D_rB_o(D_rB),
		.D_valC_o(D_valC),		.D_valP_o(D_valP),
		.D_dstE_o(D_dstE),		.D_dstM_o(D_dstM)
	);

	d d0(
		.rst(rst),
		.D_rA_i(D_rA),			.D_rB_i(D_rB),
		.d_srcA_o(d_srcA),		.d_srcB_o(d_srcB)
	);

	regfile regfile0(
		.clk(clk),				.rst(rst),
		.srcA(d_srcA),			.srcB(d_srcB),
		.dstE(W_dstE),			.dstM(W_dstM),
		.valE(W_valE),			.valM(W_valM),
		.valA(d_rvalA),			.valB(d_rvalB)
	);

	fwd_b fwd_b0(
		.rst(rst),
		.d_srcB_i(d_srcB),		.d_rvalB_i(d_rvalB),
		.e_dstE_i(e_dstE),		.e_valE_i(e_valE),
		.M_dstM_i(M_dstM),		.m_valM_i(m_valM),
		.M_dstE_i(M_dstE),		.M_valE_i(M_valE),
		.W_dstM_i(W_dstM),		.W_valM_i(W_valM),
		.W_dstE_i(W_dstE),		.W_valE_i(W_valE),
		.d_valB_o(d_valB)
	);

	sel_fwd_a sel_fwd_a0(
		.rst(rst),
		.D_icode_i(D_icode),	.D_valP_i(D_valP),
		.d_srcA_i(d_srcA),		.d_rvalA_i(d_rvalA),
		.e_dstE_i(e_dstE),		.e_valE_i(e_valE),
		.M_dstM_i(M_dstM),		.m_valM_i(m_valM),
		.M_dstE_i(M_dstE),		.M_valE_i(M_valE),
		.W_dstM_i(W_dstM),		.W_valM_i(W_valM),
		.W_dstE_i(W_dstE),		.W_valE_i(W_valE),
		.d_valA_o(d_valA)
	);

	id_ex id_ex0(
		.clk(clk),	.rst(rst),
		.id_icode(D_icode),		.id_ifun(D_ifun),
		.id_valA(d_valA),		.id_valB(d_valB),
		.id_valC(D_valC),		.id_valP(D_valP),
		.id_dstE(D_dstE),		.id_dstM(D_dstM),
		.ex_icode(ex_icode_i),	.ex_ifun(ex_ifun_i),
		.ex_valA(ex_valA_i),	.ex_valB(ex_valB_i),
		.ex_valC(ex_valC_i),	.ex_valP(ex_valP_i),
		.ex_dstE(ex_dstE_i),	.ex_dstM(ex_dstM_i)
	);

	ex ex0(
		.rst(rst),
		.icode_i(ex_icode_i),	.ifun_i(ex_ifun_i),
		.valA_i(ex_valA_i),		.valB_i(ex_valB_i),
		.valC_i(ex_valC_i),		.dstE_i(ex_dstE_i),
		.valE_o(e_valE),		.dstE_o(e_dstE)
	);

	ex_mem ex_mem0(
		.clk(clk),				.rst(rst),
		.ex_icode(ex_icode_i),
		.ex_valA(ex_valA_i),	.ex_valP(ex_valP_i),
		.ex_valE(e_valE),
		.ex_dstE(e_dstE),		.ex_dstM(ex_dstM_o),
		.mem_icode(mem_icode_i),
		.mem_valA(mem_valA_i),	.mem_valP(mem_valP_i),
		.mem_valE(M_valE),
		.mem_dstE(M_dstE),		.mem_dstM(M_dstM)
	);

	mem mem0(
		.rst(rst),
		.icode_i(mem_icode_i),
		.valA_i(mem_valA_i),	.valP_i(mem_valP_i),
		.valE_i(M_valE),
		.valM_i(mem_data_i),
		.mem_read(mem_read_o),	.mem_write(mem_write_o),
		.mem_addr(mem_addr_o),	.mem_data(mem_data_o),
		.valM_o(m_valM)
	);

	mem_wb mem_wb0(
		.clk(clk),				.rst(rst),
		.mem_icode(mem_icode_i),
		.mem_valE(M_valE),		.mem_valM(m_valM),
		.mem_dstE(M_dstE),		.mem_dstM(M_dstM),
		.wb_valE(W_valE),		.wb_valM(W_valM),
		.wb_dstE(W_dstE),		.wb_dstM(W_dstM)
	);

endmodule
