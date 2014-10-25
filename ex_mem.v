`include "defines.v"

module ex_mem(
	input	wire			clk,
	input	wire			rst,
	input	wire[`BYTE]		ex_icode,
	input	wire[`BYTE]		ex_rA,
	input	wire[`BYTE]		ex_rB,
	input	wire[`WORD]		ex_valA,
	input	wire[`PCLEN]	ex_valP,
	input	wire[`WORD]		ex_valE,

	output	reg[`BYTE]		mem_icode,
	output	reg[`BYTE]		mem_rA,
	output	reg[`BYTE]		mem_rB,
	output	reg[`WORD]		mem_valA,
	output	reg[`PCLEN]		mem_valP,
	output	reg[`WORD]		mem_valE
);

	always @ (posedge clk) begin
		mem_icode	<=	ex_icode;
		mem_rA		<=	ex_rA;
		mem_rB		<=	ex_rB;
		mem_valA	<=	ex_valA;
		mem_valP	<=	ex_valP;
		mem_valE	<=	ex_valE;
	end

endmodule

