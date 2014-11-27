`include "defines.v"

module select_pc(
    input   wire			rst,
    input   wire[`WORD]		F_predPC_i,
    input   wire[`NIBBLE]	M_icode_i,
	input	wire			M_Cnd_i,
	input	wire[`WORD]		M_valA_i,
	input	wire[`NIBBLE]	W_icode_i,
	input	wire[`WORD]		W_valM_i,

    output	reg[`WORD]		f_pc_o
);

	always @ (*) begin
		if( M_icode_i==`IJXX && !M_Cnd_i ) begin
			f_pc_o	<=	M_valA_i;
		end
		else if( W_icode_i==`IRET )begin
			f_pc_o	<=	W_valM_i;
		end
		else begin
			f_pc_o	<=	F_predPC_i;
		end
	end
endmodule
