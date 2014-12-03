`include "defines.v"

module e(
	input	wire			rst,
	input	wire[`NIBBLE]	E_icode_i,
	input	wire[`NIBBLE]	E_ifun_i,
	input	wire[`WORD]		E_valA_i,
	input	wire[`WORD]		E_valB_i,
	input	wire[`WORD]		E_valC_i,
	input	wire[`NIBBLE]	E_dstE_i,
	output reg signed[`WORD]e_valE_o,
    output	reg[`NIBBLE]	e_dstE_o,
	output	reg				e_Cnd_o
);

	reg	zf;
	reg sf;
	reg of;
	initial e_valE_o <= 32'H00000000;
	always @ (*) begin
		e_dstE_o		<=	E_dstE_i;
		case ( E_icode_i )
			`CMOVXX:	begin
				case ( E_ifun_i )
					`RRMOVL:	begin
						e_valE_o	<=	E_valA_i;
					end
				endcase
			end

			`IRMOVL:	begin
				e_valE_o	<=	E_valC_i;
			end

			`RMMOVL:	begin
				e_valE_o	<=	E_valB_i + E_valC_i;
			end

			`MRMOVL:	begin
				e_valE_o	<=	E_valB_i + E_valC_i;
			end

			`OPL:		begin
				case ( E_ifun_i )
					`ADDL:		begin
						e_valE_o	<=	E_valB_i + E_valA_i;
					end
					`SUBL:		begin
						e_valE_o	<=	E_valB_i - E_valA_i;
					end
					`ANDL:		begin
						e_valE_o	<=	E_valB_i & E_valA_i;
					end
					`XORL:		begin
						e_valE_o	<=	E_valB_i ^ E_valA_i;
					end
				endcase
				zf	<=	e_valE_o == 0 ;
				sf	<=	e_valE_o < 0 ;
				of	<=	(E_valA_i<0 == E_valB_i<0) && (e_valE_o<0 != E_valA_i<0) ;
			end

			`JXX:		begin
				case ( E_ifun_i )
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
				e_valE_o	<=	E_valB_i - 4;
			end

			`RET:		begin
				e_valE_o	<=	E_valB_i + 4;
			end

			`PUSHL:		begin
				e_valE_o	<=	E_valB_i - 4;
			end

			`POPL:		begin
				e_valE_o	<=	E_valB_i + 4;
			end
		endcase
	end

endmodule
