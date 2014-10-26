`include "defines.v"

module mem(
	input	wire			rst,
	input	wire[`BYTE]		icode_i,
	input	wire[`WORD]		valA_i,
	input	wire[`WORD]		valP_i,
	input	wire[`WORD]		valE_i,
	input	wire[`WORD]		valM_i,

	output	reg				mem_read,
	output	reg				mem_write,
	output	reg[`BYTE]		mem_addr,
	output	reg[`WORD]		mem_data,
	output	reg[`WORD]		valM_o
);

	initial	begin
		mem_read	<=	`READDISABLE;
		mem_write	<=	`WRITEDISABLE;
	end

	always @ (*) begin
		case ( icode_i )
			`RMMOVL:	begin
				mem_write	<=	`WRITEENABLE;
				mem_addr	<=	valE_i;
				mem_data	<=	valA_i;
			end
			`MRMOVL:	begin
				mem_read	<=	`READENABLE;
				mem_addr	<=	valE_i;
			end
		endcase
		valM_o	<=	valM_i;
	end

endmodule
