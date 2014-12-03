`include "defines.v"

module W(
	input	wire			clk,
	input	wire			rst,
	input	wire			W_stall_i,
	input	wire[`NIBBLE]	M_icode_i,
	input	wire[`WORD]		M_valE_i,
	input	wire[`WORD]		m_valM_i,
	input	wire[`NIBBLE]	M_dstE_i,
	input	wire[`NIBBLE]	M_dstM_i,
	output	reg	[`NIBBLE]	W_icode_o,
	output	reg	[`WORD]		W_valE_o,
	output	reg	[`WORD]		W_valM_o,
	output	reg	[`NIBBLE]	W_dstE_o,
	output	reg	[`NIBBLE]	W_dstM_o
);

	always @ (posedge clk) begin
		W_valE_o		<=	M_valE_i;
		W_valM_o		<=	m_valM_i;
		W_dstE_o		<=	M_dstE_i;
		W_dstM_o		<=	M_dstM_i;
		W_icode_o	<=	M_icode_i;
	end

endmodule
