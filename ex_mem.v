`include "defines.v"

module M(
	input	wire			clk,
	input	wire			rst,
	input	wire			M_bubble_i,
	input	wire[`NIBBLE]	E_icode_i,
	input	wire[`WORD]		E_valA_i,
	input	wire[`WORD]		E_valP_i,
	input	wire[`WORD]		e_valE_i,
	input	wire[`NIBBLE]	e_dstE_i,
	input	wire[`NIBBLE]	E_dstM_i,
	input	wire			e_Cnd_i,

	output	reg[`NIBBLE]	M_icode_o,
	output	reg[`WORD]		M_valA_o,
	output	reg[`WORD]		M_valP_o,
	output	reg[`WORD]		M_valE_o,
	output	reg[`NIBBLE]	M_dstE_o,
	output	reg[`NIBBLE]	M_dstM_o,
	output	reg				M_Cnd_o
);

	always @ (posedge clk) begin
		M_icode_o	<=	E_icode_i;
		M_valA_o	<=	E_valA_i;
		M_valP_o	<=	E_valP_i;
		M_valE_o	<=	e_valE_i;
		M_dstE_o	<=	e_dstE_i;
		M_dstM_o	<=	E_dstM_i;
		M_Cnd_o		<=	e_Cnd_i;
	end

endmodule

