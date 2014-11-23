`include "defines.v"

module ex(
	input	wire			rst,
	input	wire[`BYTE]		icode_i,
	input	wire[`BYTE]		ifun_i,
	input	wire[`WORD]		valA_i,
	input	wire[`WORD]		valB_i,
	input	wire[`WORD]		valC_i,
	input	wire[`BYTE]		dstE_i,
	output reg signed[`WORD]valE_o,
    output	reg[`BYTE]		dstE_o,
	output	reg				e_Cnd_o
);

	reg	zf;
	reg sf;
	reg of;
	initial valE_o <= 32'H00000000;
	always @ (*) begin
		dstE_o		<=	dstE_i;
		case ( icode_i )
			`CMOVXX:	begin
				case ( ifun_i )
					`RRMOVL:	begin
						valE_o	<=	valA_i;
					end
				endcase
			end

			`IRMOVL:	begin
				valE_o	<=	valC_i;
			end

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
				zf	<=	valE_o == 0 ;
				sf	<=	valE_o < 0 ;
				of	<=	(valA_i<0 == valB_i<0) && (valE_o<0 != valA_i<0) ;
			end

			`JXX:		begin
				case ( ifun_i )
					`JMP:		begin
						e_Cnd_o	<=	1;
					end
					`JLE:		begin
						e_Cnd_o	<=	(sf ^ of) | zf;
					end
					`JL:		begin
						e_Cnd_o	<=	(sf ^ of);
					end
					`JE:		begin
						e_Cnd_o	<=	zf;
					end
					`JNE:		begin
						e_Cnd_o	<=	~zf;
					end
					`JGE:		begin
						e_Cnd_o	<=	~(sf ^ of);
					end
					`JG:		begin
						e_Cnd_o	<=	~(sf ^ of) & ~zf;
					end
				endcase
			end

			`CALL:		begin
				valE_o	<=	valB_i - 4;
			end

			`PUSHL:		begin
				valE_o	<=	valB_i - 4;
			end

			`POPL:		begin
				valE_o	<=	valB_i + 4;
			end
		endcase
	end

endmodule
