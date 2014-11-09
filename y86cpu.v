`include "defines.v"

module y86cpu(
	input	wire			clk,
	input	wire			rst,
	input	wire[`INSTBUS]	rom_data_i,
	input	wire[`WORD]		mem_data_i,
	output	wire			mem_read_o,
	output	wire			mem_write_o,
	output	wire[`BYTE]		mem_addr_o,
	output	wire[`WORD]		mem_data_o,
	output	wire[`WORD]		rom_addr_o
);

	wire[`WORD]			pc;
	wire[`WORD]			id_pc_i;
	wire[`INSTBUS]		id_inst_i;

	wire[`BYTE]			id_icode_o;
	wire[`BYTE]			id_ifun_o;
	wire[`BYTE]			reg_rA_addr;
	wire[`BYTE]			reg_rB_addr;
	wire[`WORD]			reg_valA_o;
	wire[`WORD]			reg_valB_o;
	//wire[`WORD]			id_valA_o;
	wire[`WORD]			id_valB_o;
	wire[`WORD]			id_valC_o;
	wire[`WORD]			id_valP_o;
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
	wire[`WORD]			ex_valE_o;
	wire[`BYTE]			ex_dstE_o;
	wire[`BYTE]			ex_dstM_o;

	wire[`BYTE]			mem_icode_i;
	wire[`WORD]			mem_valA_i;
	wire[`WORD]			mem_valP_i;
	wire[`WORD]			mem_valE_i;
	wire[`BYTE]			mem_dstE_i;
	wire[`BYTE]			mem_dstM_i;
	wire[`WORD]			mem_valM_o;

	wire[`WORD]			wb_valE_i;
	wire[`WORD]			wb_valM_i;
	wire[`BYTE]			wb_dstE_i;
	wire[`BYTE]			wb_dstM_i;

	wire[`BYTE]			e_dstE;
	wire[`WORD]			e_valE;
	wire[`BYTE]			M_dstM;
	wire[`WORD]			m_valM;
	wire[`BYTE]			M_dstE;
	wire[`WORD]			M_valE;
	wire[`BYTE]			W_dstM;
	wire[`WORD]			W_valM;
	wire[`BYTE]			W_dstE;
	wire[`WORD]			W_valE;

	pc_reg pc_reg0(
		.clk(clk),	.rst(rst),	.newPC(id_valP_o),
		.pc(pc)
	);

	assign rom_addr_o = pc;

	if_id if_id0(
		.clk(clk),	.rst(rst),	.if_pc(pc),
		.if_inst(rom_data_i),	.id_pc(id_pc_i),
		.id_inst(id_inst_i)
	);

	id id0(
		.rst(rst),	.pc_i(id_pc_i),	.inst_i(id_inst_i),
		.icode_o(id_icode_o),	.ifun_o(id_ifun_o),
		.rA_o(reg_rA_addr),		.rB_o(reg_rB_addr),
		.valC_o(id_valC_o),		.valP_o(id_valP_o),
		.dstE_o(id_dstE_o),		.dstM_o(id_dstM_o)
	);

	regfile regfile0(
		.clk(clk),				.rst(rst),
		.srcA(reg_rA_addr),		.srcB(reg_rB_addr),
		.dstE(wb_dstE_i),		.dstM(wb_dstM_i),
		.valE(wb_valE_i),		.valM(wb_valM_i),
		.valA(reg_valA_o),		.valB(reg_valB_o)
	);

	fwd_b fwd_b0(
		.rst(rst),
		.d_srcB(reg_rB_addr),	.d_rvalB(reg_valB_o),
		.e_dstE(ex_dstE_o),		.e_valE(ex_valE_o),
		.M_dstM(mem_dstM_i),	.m_valM(mem_valM_o),
		.M_dstE(mem_dstE_i),	.M_valE(mem_valE_i),
		.W_dstM(wb_dstM_i),		.W_valM(wb_valM_i),
		.W_dstE(wb_dstE_i),		.W_valE(wb_valE_i),
		.d_valB(id_valB_o)
	);

	id_ex id_ex0(
		.clk(clk),	.rst(rst),
		.id_icode(id_icode_o),	.id_ifun(id_ifun_o),
		.id_valA(reg_valA_o),	.id_valB(id_valB_o),
		.id_valC(id_valC_o),	.id_valP(id_valP_o),
		.id_dstE(id_dstE_o),	.id_dstM(id_dstM_o),
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
		.valE_o(ex_valE_o),		.dstE_o(ex_dstE_o)
	);

	ex_mem ex_mem0(
		.clk(clk),				.rst(rst),
		.ex_icode(ex_icode_i),
		.ex_valA(ex_valA_i),	.ex_valP(ex_valP_i),
		.ex_valE(ex_valE_o),
		.ex_dstE(ex_dstE_o),	.ex_dstM(ex_dstM_o),
		.mem_icode(mem_icode_i),
		.mem_valA(mem_valA_i),	.mem_valP(mem_valP_i),
		.mem_valE(mem_valE_i),
		.mem_dstE(mem_dstE_i),	.mem_dstM(mem_dstM_i)
	);

	mem mem0(
		.rst(rst),
		.icode_i(mem_icode_i),
		.valA_i(mem_valA_i),	.valP_i(mem_valP_i),
		.valE_i(mem_valE_i),
		.valM_i(mem_data_i),
		.mem_read(mem_read_o),	.mem_write(mem_write_o),
		.mem_addr(mem_addr_o),	.mem_data(mem_data_o),
		.valM_o(mem_valM_o)
	);

	mem_wb mem_wb0(
		.clk(clk),				.rst(rst),
		.mem_icode(mem_icode_i),
		.mem_valE(mem_valE_i),	.mem_valM(mem_valM_o),
		.mem_dstE(mem_dstE_i),	.mem_dstM(mem_dstM_i),
		.wb_valE(wb_valE_i),	.wb_valM(wb_valM_i),
		.wb_dstE(wb_dstE_i),	.wb_dstM(wb_dstM_i)
	);

endmodule
