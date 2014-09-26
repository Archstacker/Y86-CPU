`include "defines.v"
module if_id(
	input	wire			clk,
	input	wire			rst,
	input	wire[`PCLEN]	if_pc,
	input	wire[`INSTBUS]	if_inst,
	output	reg[`PCLEN]		id_pc,
	output	reg[`INSTBUS]	id_inst
);

	always @ (posedge clk) begin
		id_pc <= if_pc;
		id_inst <= if_inst;
	end
endmodule
