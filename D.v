`include "defines.v"
module D(
	input	wire			clk,
	input	wire			rst,
	input	wire			D_stall_i,
	input	wire			D_bubble_i,
    input	wire[`NIBBLE]	f_icode_i,
    input	wire[`NIBBLE]	f_ifun_i,
    input	wire[`NIBBLE]	f_rA_i,
    input	wire[`NIBBLE]	f_rB_i,
    input	wire[`WORD]		f_valC_i,
    input	wire[`WORD]		f_valP_i,
    input	wire[`NIBBLE]	f_dstE_i,
    input	wire[`NIBBLE]	f_dstM_i,
    output	reg[`NIBBLE]	D_icode_o,
    output	reg[`NIBBLE]	D_ifun_o,
    output	reg[`NIBBLE]	D_rA_o,
    output	reg[`NIBBLE]	D_rB_o,
    output	reg[`WORD]		D_valC_o,
    output	reg[`WORD]		D_valP_o,
    output	reg[`NIBBLE]	D_dstE_o,
    output	reg[`NIBBLE]	D_dstM_o
);

	always @ (posedge clk) begin
		if( rst == `DISABLE && D_stall_i != `ENABLE ) begin
			if( D_bubble_i==`ENABLE ) begin
				D_icode_o	<=	`INOP;
				D_dstE_o	<=	`RNONE;
				D_dstM_o	<=	`RNONE;
			end
			else begin
				D_icode_o	<=	f_icode_i;
				D_ifun_o	<=	f_ifun_i;
				D_rA_o		<=	f_rA_i;
				D_rB_o		<=	f_rB_i;
				D_valC_o	<=	f_valC_i;
				D_valP_o	<=	f_valP_i;
				D_dstE_o	<=	f_dstE_i;
				D_dstM_o	<=	f_dstM_i;
			end
		end
	end
endmodule
