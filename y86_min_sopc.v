`include "defines.v"

module y86_min_sopc(
	input	wire			clk,
	input	wire			rst
);

	wire[`WORD]		inst_addr;
	wire[`INSTBUS]	inst;
	wire[`WORD]		mem_cpu_data;
	wire[`WORD]		cpu_mem_data;
	wire			cpu_mem_read;
	wire			cpu_mem_write;
	wire[`BYTE]		cpu_mem_addr;
	
	y86cpu y86cpu0(
		.clk(clk),		.rst(rst),
		.rom_data_i(inst),
		.mem_data_i(mem_cpu_data),
		.mem_read_o(cpu_mem_read),	.mem_write_o(cpu_mem_write),
		.mem_addr_o(cpu_mem_addr),	.mem_data_o(cpu_mem_data),
		.rom_addr_o(inst_addr)
	);

	inst_rom inst_rom0(
		.addr(inst_addr),
		.mem_read_i(cpu_mem_read),	.mem_write_i(cpu_mem_write),
		.mem_addr_i(cpu_mem_addr),	.mem_data_i(cpu_mem_data),
		.mem_data_o(mem_cpu_data),
		.inst(inst)
	);

endmodule
