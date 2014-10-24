`include "defines.v"

module mem(
	input	wire			rst,
	input	wire[`WORD]		valE_i,
	output	reg	[`WORD]		valE_o,
	output	reg	[`WORD]		valM_o
);

	always @ (*) begin
		valE_o		<=	valE_i;
	end

endmodule
