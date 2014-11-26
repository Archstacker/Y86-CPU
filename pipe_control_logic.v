`include "defines.v"

module pipe_control_logic(
	input	wire[`BYTE]		D_icode_i,
	input	wire[`BYTE]		d_srcA_i,
	input	wire[`BYTE]		d_srcB_i,
	input	wire[`BYTE]		E_icode_i,
	input	wire[`BYTE]		E_dstE_i,
    input	wire[`BYTE]		E_dstM_i,
    input	wire			e_Cnd_i,
	input	wire[`BYTE]		M_icode_i,
	output	reg				F_stall_o,
	output	reg				D_stall_o,
	output	reg				D_bubble_o,
	output	reg				E_bubble_o,
	output	reg				set_cc_o,
	output	reg				M_bubble_o,
	output	reg				W_stall_o
);
	initial begin
		set_cc_o	<=	0;
		F_stall_o	<=	0;
		D_stall_o	<=	0;
		D_bubble_o	<=	0;
		E_bubble_o	<=	0;
		M_bubble_o	<=	0;
		W_stall_o	<=	0;
	end

	always @ (*) begin
		F_stall_o	<=	( E_icode_i==`IMRMOVL || E_icode_i==`IPOPL )&&
						( E_dstM_i==d_srcA_i || E_dstM_i==d_srcB_i ||
							E_dstE_i==d_srcA_i || E_dstE_i==d_srcB_i )||
						( D_icode_i==`IRET || E_icode_i==`IRET || M_icode_i==`IRET );

		D_stall_o	<=	( E_icode_i==`IMRMOVL || E_icode_i==`IPOPL )&&
						( E_dstM_i==d_srcA_i || E_dstM_i==d_srcB_i ||
							E_dstE_i==d_srcA_i || E_dstE_i==d_srcB_i );

		D_bubble_o	<=	( E_icode_i==`IJXX && !e_Cnd_i )||
						!(( E_icode_i==`IMRMOVL || E_icode_i==`IPOPL )
							&&( E_dstM_i==d_srcA_i || E_dstM_i==d_srcB_i ||
								E_dstE_i==d_srcA_i || E_dstE_i==d_srcB_i ) )
						&&( D_icode_i==`IRET || E_icode_i==`IRET || M_icode_i==`IRET );

		E_bubble_o	<=	( E_icode_i==`IJXX && !e_Cnd_i )||
						( E_icode_i==`IMRMOVL || E_icode_i==`IPOPL )&&
						( E_dstM_i==d_srcA_i || E_dstM_i==d_srcB_i ||
							E_dstE_i==d_srcA_i || E_dstE_i==d_srcB_i );

		M_bubble_o	<=	0;
		W_stall_o	<=	0;
	end

endmodule
