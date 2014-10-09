`include "defines.v"

module ex_mem(
	input	wire			clk,
	input	wire			rst,
	input	wire[`BYTE]		ex_icode,
	input	wire[`WORD]		ex_valA,
	input	wire[`WORD]		ex_valE,
	output	reg	[`BYTE]		mem_icode,
	output	reg	[`WORD]		mem_valA,
	output	reg	[`WORD]		mem_valE
);

	always @ (posedge clk) begin
		mem_icode	<=	ex_icode;
		mem_valA	<=	ex_valA;
		mem_valE	<=	ex_valE;
	end

endmodule

