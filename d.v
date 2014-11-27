`include "defines.v"
module d(
	input	wire			rst,
    input	wire[`NIBBLE]	D_rA_i,
    input	wire[`NIBBLE]	D_rB_i,
    output	reg[`NIBBLE]	d_srcA_o,
    output	reg[`NIBBLE]	d_srcB_o
);

	always @ (*) begin
		d_srcA_o	<=	D_rA_i;
		d_srcB_o	<=	D_rB_i;
	end
endmodule
