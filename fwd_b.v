`include "defines.v"

module fwd_b(
	input	wire			rst,
	input	wire[`BYTE]		d_srcB,
	input	wire[`WORD]		d_rvalB,
	input	wire[`BYTE]		e_dstE,
	input	wire[`WORD]		e_valE,
	input	wire[`BYTE]		M_dstM,
	input	wire[`WORD]		m_valM,
	input	wire[`BYTE]		M_dstE,
	input	wire[`WORD]		M_valE,
	input	wire[`BYTE]		W_dstM,
	input	wire[`WORD]		W_valM,
	input	wire[`BYTE]		W_dstE,
	input	wire[`WORD]		W_valE,
	output	reg[`WORD]		d_valB
);

	always @ (*) begin
		d_valB	<=	d_rvalB;
		case ( d_srcB )
			e_dstE:		begin
				d_valB	<=	e_valE;
			end
			M_dstM:		begin
				d_valB	<=	m_valM;
			end
			M_dstE:		begin
				d_valB	<=	M_valE;
			end
			W_dstM:		begin
				d_valB	<=	W_valM;
			end
			W_dstE:		begin
				d_valB	<=	W_valE;
			end
		endcase
	end
endmodule
