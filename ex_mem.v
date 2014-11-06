`include "defines.v"

module ex_mem(
	input	wire			clk,
	input	wire			rst,
	input	wire[`BYTE]		ex_icode,
	input	wire[`BYTE]		ex_rA,
	input	wire[`BYTE]		ex_rB,
	input	wire[`WORD]		ex_valA,
	input	wire[`WORD]		ex_valP,
	input	wire[`WORD]		ex_valE,
	input	wire[`BYTE]		ex_dstE,

	output	reg[`BYTE]		mem_icode,
	output	reg[`BYTE]		mem_rA,
	output	reg[`BYTE]		mem_rB,
	output	reg[`WORD]		mem_valA,
	output	reg[`WORD]		mem_valP,
	output	reg[`WORD]		mem_valE,
	output	reg[`BYTE]		mem_dstE
);

	always @ (posedge clk) begin
		mem_icode	<=	ex_icode;
		mem_rA		<=	ex_rA;
		mem_rB		<=	ex_rB;
		mem_valA	<=	ex_valA;
		mem_valP	<=	ex_valP;
		mem_valE	<=	ex_valE;
		mem_dstE	<=	ex_dstE;
	end

endmodule

