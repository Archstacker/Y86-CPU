`include "defines.v"

module ex_mem(
	input	wire			clk,
	input	wire			rst,
	input	wire[`WORD]		ex_valE,
	input	wire[`BYTE]		ex_dstW,
	output	reg	[`WORD]		mem_valE,
	output	reg	[`BYTE]		mem_dstW
);

	always @ (posedge clk) begin
		mem_valE	<=	ex_valE;
		mem_dstW	<=	ex_dstW;
	end

endmodule

