`include "defines.v"

module mem_wb(
	input	wire			clk,
	input	wire			rst,
	input	wire[`BYTE]		mem_icode,
	input	wire[`BYTE]		mem_rA,
	input	wire[`BYTE]		mem_rB,
	input	wire[`WORD]		mem_valE,
	input	wire[`WORD]		mem_valM,
	output	reg	[`WORD]		wb_valE,
	output	reg	[`WORD]		wb_valM,
	output	reg	[`BYTE]		wb_dstE,
	output	reg	[`BYTE]		wb_dstM
);

	always @ (*) begin
		wb_dstE		<=	4'hf;
		wb_dstM		<=	4'hf;
		wb_valE		<=	mem_valE;
		case (mem_icode)
			`IRMOVL:	begin
				wb_dstE	<=	mem_rB;
			end
		endcase
	end

endmodule
