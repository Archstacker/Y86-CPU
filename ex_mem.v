`include "defines.v"

module ex_mem(
	input	wire			clk,
	input	wire			rst,
	input	wire[`WORD]		ex_valE,
	input	wire[`BYTE]		ex_dstE,
	input	wire[`BYTE]		ex_dstM,
	output	reg	[`WORD]		mem_valE,
	output	reg	[`BYTE]		mem_dstE,
	output	reg	[`BYTE]		mem_dstM
);

	always @ (posedge clk) begin
		mem_valE	<=	ex_valE;
		mem_dstE	<=	ex_dstE;
		mem_dstM	<=	ex_dstM;
	end

endmodule

