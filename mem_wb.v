`include "defines.v"

module mem_wb(
	input	wire			clk,
	input	wire			rst,
	input	wire			W_stall_i,
	input	wire[`NIBBLE]	mem_icode,
	input	wire[`WORD]		mem_valE,
	input	wire[`WORD]		mem_valM,
	input	wire[`NIBBLE]	mem_dstE,
	input	wire[`NIBBLE]	mem_dstM,
	output	reg	[`NIBBLE]	W_icode_o,
	output	reg	[`WORD]		wb_valE,
	output	reg	[`WORD]		wb_valM,
	output	reg	[`NIBBLE]	wb_dstE,
	output	reg	[`NIBBLE]	wb_dstM
);

	always @ (posedge clk) begin
		wb_valE		<=	mem_valE;
		wb_valM		<=	mem_valM;
		wb_dstE		<=	mem_dstE;
		wb_dstM		<=	mem_dstM;
		W_icode_o	<=	mem_icode;
	end

endmodule
