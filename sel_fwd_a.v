`include "defines.v"

module sel_fwd_a(
	input	wire			rst,
	input	wire[`NIBBLE]	D_icode_i,
	input	wire[`WORD]		D_valP_i,
	input	wire[`NIBBLE]	d_srcA_i,
	input	wire[`WORD]		d_rvalA_i,
	input	wire[`NIBBLE]	e_dstE_i,
	input	wire[`WORD]		e_valE_i,
	input	wire[`NIBBLE]	M_dstM_i,
	input	wire[`WORD]		m_valM_i,
	input	wire[`NIBBLE]	M_dstE_i,
	input	wire[`WORD]		M_valE_i,
	input	wire[`NIBBLE]	W_dstM_i,
	input	wire[`WORD]		W_valM_i,
	input	wire[`NIBBLE]	W_dstE_i,
	input	wire[`WORD]		W_valE_i,
	output	reg[`WORD]		d_valA_o
);

	always @ (*) begin
		d_valA_o	<=	d_rvalA_i;
		if( D_icode_i==`ICALL || D_icode_i==`IJXX ) begin
			d_valA_o	<=	D_valP_i;
		end
		else if ( d_srcA_i != `RNONE ) begin
			case ( d_srcA_i )
				e_dstE_i:		begin
					d_valA_o	<=	e_valE_i;
				end
				M_dstM_i:		begin
					d_valA_o	<=	m_valM_i;
				end
				M_dstE_i:		begin
					d_valA_o	<=	M_valE_i;
				end
				W_dstM_i:		begin
					d_valA_o	<=	W_valM_i;
				end
				W_dstE_i:		begin
					d_valA_o	<=	W_valE_i;
				end
			endcase
		end
	end
endmodule
