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

	wire[`BYTE]			id_icode;
	wire[`BYTE]			id_ifun;
	wire[`BYTE]			rA_addr;
	wire[`BYTE]			rB_addr;
	wire[`WORD]			id_valC;
	wire[`PCLEN]		id_valP;

	wire[`WORD]			rA_data;
	wire[`WORD]			rB_data;

	pc_reg pc_reg0(
		.clk(clk),	.rst(rst),	.newPC(id_valP),
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
		.icode(id_icode),	.ifun(id_ifun),
		.rA(rA_addr),		.rB(rB_addr),
		.valC(id_valC),		.valP(id_valP)
	);

	regfile regfile0(
		.clk(clk),			.rst(rst),
		.srcA(rA_addr),		.srcB(rB_addr),
		.valA(rA_data),		.valB(rB_data)
	);

endmodule
