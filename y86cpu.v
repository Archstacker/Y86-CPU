`include "defines.v"

module y86cpu(
	input	wire			clk,
	input	wire			rst,
	input	wire[`INSTBUS]	rom_data_i,
	output	wire[`PCLEN]	rom_addr_o
);

	wire[`PCLEN]		pc;
	wire[`PCLEN]		id_pc_i;
	wire[`INSTBUS]		id_inst_i;

	wire[`BYTE]			id_icode_o;
	wire[`BYTE]			id_ifun_o;
	wire[`BYTE]			reg_rA_addr;
	wire[`BYTE]			reg_rB_addr;
	wire[`WORD]			reg_rA_data;
	wire[`WORD]			reg_rB_data;
	wire[`WORD]			id_valA_o;
	wire[`WORD]			id_valB_o;
	wire[`WORD]			id_valC_o;
	wire[`PCLEN]		id_valP_o;
	wire[`BYTE]			id_dstE_o;
	wire[`BYTE]			id_dstM_o;

	wire[`BYTE]			ex_icode_i;
	wire[`BYTE]			ex_ifun_i;
	wire[`WORD]			ex_valA_i;
	wire[`WORD]			ex_valB_i;
	wire[`WORD]			ex_valC_i;
	wire[`PCLEN]		ex_valP_i;
	wire[`BYTE]			ex_dstE_i;
	wire[`BYTE]			ex_dstM_i;
	wire[`WORD]			ex_valE_o;
	wire[`BYTE]			ex_dstE_o;
	wire[`BYTE]			ex_dstM_o;

	wire[`WORD]			mem_valE_i;
	wire[`BYTE]			mem_dstE_i;
	wire[`BYTE]			mem_dstM_i;
	wire[`WORD]			mem_valE_o;
	wire[`WORD]			mem_valM_o;
	wire[`BYTE]			mem_dstE_o;
	wire[`BYTE]			mem_dstM_o;

	wire[`WORD]			wb_valE_i;
	wire[`WORD]			wb_valM_i;
	wire[`BYTE]			wb_dstE_i;
	wire[`BYTE]			wb_dstM_i;

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
		.valA_i(reg_rA_data),	.valB_i(reg_rB_data),
		.icode_o(id_icode_o),	.ifun_o(id_ifun_o),
		.rA_o(reg_rA_addr),		.rB_o(reg_rB_addr),
		.valA_o(id_valA_o),		.valB_o(id_valB_o),
		.valC_o(id_valC_o),		.valP_o(id_valP_o),
		.dstE_o(id_dstE_o),		.dstM_o(id_dstM_o)
	);

	regfile regfile0(
		.clk(clk),				.rst(rst),
		.srcA(reg_rA_addr),		.srcB(reg_rB_addr),
		.dstE(wb_dstE_i),		.dstM(wb_dstM_i),
		.valE(wb_valE_i),		.valM(wb_valM_i),
		.valA(reg_rA_data),		.valB(reg_rB_data)
	);

	id_ex id_ex0(
		.clk(clk),	.rst(rst),
		.id_icode(id_icode_o),	.id_ifun(id_ifun_o),
		.id_valA(id_valA_o),	.id_valB(id_valB_o),
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
		.valC_i(ex_valC_i),		.valP_i(ex_valP_i),
		.dstE_i(ex_dstE_i),		.dstM_i(ex_dstM_i),
		.valE_o(ex_valE_o),		.dstE_o(ex_dstE_o),
		.dstM_o(ex_dstM_o)
	);

	ex_mem ex_mem0(
		.clk(clk),				.rst(rst),
		.ex_valE(ex_valE_o),	.ex_dstE(ex_dstE_o),
		.ex_dstM(ex_dstM_o),
		.mem_valE(mem_valE_i),	.mem_dstE(mem_dstE_i),
		.mem_dstM(mem_dstM_i)
	);

	mem mem0(
		.rst(rst),
		.valE_i(mem_valE_i),	.dstE_i(mem_dstE_i),
		.dstM_i(mem_dstM_i),
		.valE_o(mem_valE_o),	.valM_o(mem_valM_o),
		.dstE_o(mem_dstE_o),	.dstM_o(mem_dstM_o)
	);

	mem_wb mem_wb0(
		.clk(clk),				.rst(rst),
		.mem_valE(mem_valE_o),	.mem_valM(mem_valM_o),
		.mem_dstE(mem_dstE_o),	.mem_dstM(mem_dstM_o),
		.wb_valE(wb_valE_i),	.wb_valM(wb_valM_i),
		.wb_dstE(wb_dstE_i),	.wb_dstM(wb_dstM_i)
	);

endmodule
