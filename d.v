`include "defines.v"
module d(
	input	wire			rst,
    input	wire[`BYTE]		D_rA_i,
    input	wire[`BYTE]		D_rB_i,
    output	reg[`BYTE]		d_srcA_o,
    output	reg[`BYTE]		d_srcB_o
);

	always @ (*) begin
		d_srcA_o	<=	D_rA_i;
		d_srcB_o	<=	D_rB_i;
	end
endmodule
