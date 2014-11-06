`include "defines.v"

module mem_wb(
	input	wire			clk,
	input	wire			rst,
	input	wire[`BYTE]		mem_icode,
	input	wire[`BYTE]		mem_rA,
	input	wire[`BYTE]		mem_rB,
	input	wire[`WORD]		mem_valE,
	input	wire[`WORD]		mem_valM,
	input	wire[`BYTE]		mem_dstE,
	input	wire[`BYTE]		mem_dstM,
	output	reg	[`WORD]		wb_valE,
	output	reg	[`WORD]		wb_valM,
	output	reg	[`BYTE]		wb_dstE,
	output	reg	[`BYTE]		wb_dstM
);

	always @ (*) begin
		wb_valE		<=	mem_valE;
		wb_valM		<=	mem_valM;
		wb_dstE		<=	mem_dstE;
		wb_dstM		<=	mem_dstM;
	end

endmodule
