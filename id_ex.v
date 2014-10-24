`include "defines.v"

module id_ex(
	input	wire			clk,
	input	wire			rst,

	input	wire[`BYTE]		id_icode,
	input	wire[`BYTE]		id_ifun,
	input	wire[`BYTE]		id_rA,
	input	wire[`BYTE]		id_rB,
	input	wire[`WORD]		id_valA,
	input	wire[`WORD]		id_valB,
	input	wire[`WORD]		id_valC,
	input	wire[`PCLEN]	id_valP,

	output	reg[`BYTE]		ex_icode,
	output	reg[`BYTE]		ex_ifun,
	output	reg[`BYTE]		ex_rA,
	output	reg[`BYTE]		ex_rB,
	output	reg[`WORD]		ex_valA,
	output	reg[`WORD]		ex_valB,
	output	reg[`WORD]		ex_valC,
	output	reg[`PCLEN]		ex_valP
);

	always @ (posedge clk) begin
		ex_icode	<=	id_icode;
		ex_ifun		<=	id_ifun;
		ex_rA		<=	id_rA;
		ex_rB		<=	id_rB;
		ex_valA		<=	id_valA;
		ex_valB		<=	id_valB;
		ex_valC		<=	id_valC;
		ex_valP		<=	id_valP;
	end
endmodule
