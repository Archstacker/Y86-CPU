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
			`CMOVXX:	begin
				wb_dstE	<=	mem_rB;
			end
			`IRMOVL:	begin
				wb_dstE	<=	mem_rB;
			end
			`MRMOVL:	begin
				wb_dstM	<=	mem_rA;
			end
			`OPL:		begin
				wb_dstE	<=	mem_rB;
			end
			`CALL:		begin
				wb_dstE	<=	`RESP;
			end
			`RET:		begin
				wb_dstE	<=	`RESP;
			end
			`PUSHL:		begin
				wb_dstE	<=	`RESP;
			end
			`POPL:		begin
				wb_dstE	<=	`RESP;
				wb_dstM	<=	mem_rA;
			end
		endcase
	end

endmodule
