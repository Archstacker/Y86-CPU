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

	wire[3:0]			id_icode;
	wire[3:0]			id_ifun;
	wire[3:0]			id_rA;
	wire[3:0]			id_rB;
	wire[31:0]			id_valC;

	pc_reg pc_reg0(
		.clk(clk),	.rst(rst),	.pc(pc)
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
		.rA(id_rA),			.rB(id_rB),
		.valC(id_valC)
	);

endmodule
