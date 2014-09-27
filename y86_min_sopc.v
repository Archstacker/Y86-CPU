`include "defines.v"

module y86_min_sopc(
	input	wire			clk,
	input	wire			rst
);

	wire[`PCLEN]	inst_addr;
	wire[`INSTBUS]	inst;
	
	y86cpu y86cpu0(
		.clk(clk),		.rst(rst),
		.rom_addr_o(inst_addr),	.rom_data_i(inst)
	);

	inst_rom inst_rom0(
		.addr(inst_addr),	.inst(inst)
	);

endmodule
