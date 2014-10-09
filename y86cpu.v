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
	wire[`BYTE]			rA_addr;
	wire[`BYTE]			rB_addr;
	wire[`WORD]			rA_data;
	wire[`WORD]			rB_data;
	wire[`WORD]			id_valC_o;
	wire[`PCLEN]		id_valP_o;
	wire[`WORD]			id_valA_o;
	wire[`WORD]			id_valB_o;

	wire[`BYTE]			ex_icode_i;
	wire[`BYTE]			ex_ifun_i;
	wire[`WORD]			ex_valA_i;
	wire[`WORD]			ex_valB_i;
	wire[`WORD]			ex_valC_i;
	wire[`PCLEN]		ex_valP_i;

	wire[`WORD]			ex_valE_o;

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
		.valA_i(rA_data),		.valB_i(rB_data),
		.icode_o(id_icode_o),	.ifun_o(id_ifun_o),
		.rA(rA_addr),			.rB(rB_addr),
		.valC_o(id_valC_o),		.valP_o(id_valP_o),
		.valA_o(id_valA_o),		.valB_o(id_valB_o)
	);

	regfile regfile0(
		.clk(clk),				.rst(rst),
		.srcA(rA_addr),			.srcB(rB_addr),
		.valA(rA_data),			.valB(rB_data)
	);

	id_ex id_ex0(
		.clk(clk),	.rst(rst),
		.id_icode(id_icode_o),	.id_ifun(id_ifun_o),
		.id_valA(id_valA_o),	.id_valB(id_valB_o),
		.id_valC(id_valC_o),	.id_valP(id_valP_o),
		.ex_icode(ex_icode_i),	.ex_ifun(ex_ifun_i),
		.ex_valA(ex_valA_i),	.ex_valB(ex_valB_i),
		.ex_valC(ex_valC_i),	.ex_valP(ex_valP_i)
	);

	ex ex0(
		.rst(rst),
		.icode_i(ex_icode_i),	.ifun_i(ex_ifun_i),
		.valA_i(ex_valA_i),		.valB_i(ex_valB_i),
		.valC_i(ex_valC_i),		.valP_i(ex_valP_i),
		.valE_o(ex_valE_o)
	);
endmodule
