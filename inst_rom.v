`include "defines.v"
module inst_rom(
	input	wire[`WORD]		addr,
	input	wire			mem_read_i,
	input	wire			mem_write_i,
	input	wire[`WORD]		mem_addr_i,
	input	wire[`WORD]		mem_data_i,
	output	reg[`WORD]		mem_data_o,
	output	wire[`INSTBUS]	inst
);

	reg [`BYTE]	inst_mem[0:`INSTMEMNUM-1];

	initial $readmemh ( "inst_rom.data",	inst_mem );

    initial mem_data_o	<= 32'H00000000;
	//always @ (*)begin
	//	inst	<=	inst_mem[addr[`WORDNUM-1:2]];
	//end
	assign inst = {inst_mem[addr],inst_mem[addr+1],inst_mem[addr+2],inst_mem[addr+3],inst_mem[addr+4],inst_mem[addr+5]};
	always @ (*) begin
		if( mem_read_i == `READENABLE ) begin
			mem_data_o	<=	{inst_mem[mem_addr_i+3],inst_mem[mem_addr_i+2],inst_mem[mem_addr_i+1],inst_mem[mem_addr_i]};
		end
		if( mem_write_i == `WRITEENABLE ) begin
			{inst_mem[mem_addr_i+3],inst_mem[mem_addr_i+2],inst_mem[mem_addr_i+1],inst_mem[mem_addr_i]} <= mem_data_i;
		end
	end

endmodule
