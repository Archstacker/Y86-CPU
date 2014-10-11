`include "defines.v"

module mem(
	input	wire			rst,
	input	wire[`WORD]		valE_i,
	input	wire[`BYTE]		dstW_i,
	output	reg	[`WORD]		valE_o,
	output	reg	[`BYTE]		dstW_o
);

	always @ (*) begin
		valE_o		<=	valE_i;
		dstW_o		<=	dstW_i;
	end

endmodule
