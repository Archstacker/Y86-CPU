`include "defines.v"

module ex(
	input	wire			rst,
	input	wire[`BYTE]		icode_i,
	input	wire[`BYTE]		ifun_i,
	input	wire[`WORD]		valA_i,
	input	wire[`WORD]		valB_i,
	input	wire[`WORD]		valC_i,
	input	wire[`PCLEN]	valP_i,
	input	wire[`BYTE]		dstE_i,
	input	wire[`BYTE]		dstM_i,
	output	reg	[`WORD]		valE_o,
	output	reg	[`BYTE]		dstE_o,
	output	reg	[`BYTE]		dstM_o
);

	initial valE_o <= 32'H00000000;
	always @ (*) begin
		case ( icode_i )
			`OPL:		begin
				case ( ifun_i )
					`ADDL:		begin
						valE_o	<=	valB_i + valA_i;
					end
					`SUBL:		begin
						valE_o	<=	valB_i - valA_i;
					end
					`ANDL:		begin
						valE_o	<=	valB_i & valA_i;
					end
					`XORL:		begin
						valE_o	<=	valB_i ^ valA_i;
					end
				endcase
			end
		endcase
	end
	always @ (*) begin
		dstE_o	<=	dstE_i;
		dstM_o	<=	dstM_i;
	end

endmodule
