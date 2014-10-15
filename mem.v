`include "defines.v"

module mem(
	input	wire			rst,
	input	wire[`WORD]		valE_i,
	input	wire[`BYTE]		dstE_i,
	input	wire[`BYTE]		dstM_i,
	output	reg	[`WORD]		valE_o,
	output	reg	[`WORD]		valM_o,
	output	reg	[`BYTE]		dstE_o,
	output	reg	[`BYTE]		dstM_o
);

	always @ (*) begin
		valE_o		<=	valE_i;
		dstE_o		<=	dstE_i;
		dstM_o		<=	dstM_i;
	end

endmodule
