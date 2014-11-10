`include "defines.v"

module fwd_b(
	input	wire			rst,
	input	wire[`BYTE]		d_srcB_i,
	input	wire[`WORD]		d_rvalB_i,
	input	wire[`BYTE]		e_dstE_i,
	input	wire[`WORD]		e_valE_i,
	input	wire[`BYTE]		M_dstM_i,
	input	wire[`WORD]		m_valM_i,
	input	wire[`BYTE]		M_dstE_i,
	input	wire[`WORD]		M_valE_i,
	input	wire[`BYTE]		W_dstM_i,
	input	wire[`WORD]		W_valM_i,
	input	wire[`BYTE]		W_dstE_i,
	input	wire[`WORD]		W_valE_i,
	output	reg[`WORD]		d_valB_o
);

	always @ (*) begin
		d_valB_o	<=	d_rvalB_i;
		case ( d_srcB_i )
			e_dstE_i:	begin
				d_valB_o	<=	e_valE_i;
			end
			M_dstM_i:	begin
				d_valB_o	<=	m_valM_i;
			end
			M_dstE_i:	begin
				d_valB_o	<=	M_valE_i;
			end
			W_dstM_i:	begin
				d_valB_o	<=	W_valM_i;
			end
			W_dstE_i:	begin
				d_valB_o	<=	W_valE_i;
			end
		endcase
	end
endmodule
