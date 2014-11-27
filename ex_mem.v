`include "defines.v"

module ex_mem(
	input	wire			clk,
	input	wire			rst,
	input	wire			M_bubble_i,
	input	wire[`NIBBLE]	ex_icode,
	input	wire[`WORD]		ex_valA,
	input	wire[`WORD]		ex_valP,
	input	wire[`WORD]		ex_valE,
	input	wire[`NIBBLE]	ex_dstE,
	input	wire[`NIBBLE]	ex_dstM,
	input	wire			e_Cnd_i,

	output	reg[`NIBBLE]	mem_icode,
	output	reg[`WORD]		mem_valA,
	output	reg[`WORD]		mem_valP,
	output	reg[`WORD]		mem_valE,
	output	reg[`NIBBLE]	mem_dstE,
	output	reg[`NIBBLE]	mem_dstM,
	output	reg				M_Cnd_o
);

	always @ (posedge clk) begin
		mem_icode	<=	ex_icode;
		mem_valA	<=	ex_valA;
		mem_valP	<=	ex_valP;
		mem_valE	<=	ex_valE;
		mem_dstE	<=	ex_dstE;
		mem_dstM	<=	ex_dstM;
		M_Cnd_o		<=	e_Cnd_i;
	end

endmodule

