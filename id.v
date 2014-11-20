`include "defines.v"

module f(
    input   wire			rst,
    input   wire[`WORD]		pc_i,
    input   wire[`INSTBUS]	inst_i,

    //output  reg         instr_valid,
    //output  reg         need_regids,
    //output  reg         need_valC,

    output	reg[`BYTE]		f_icode_o,
    output	reg[`BYTE]		f_ifun_o,
    output	reg[`BYTE]		f_rA_o,
    output	reg[`BYTE]		f_rB_o,
    output	reg[`WORD]		f_valC_o,
    output	reg[`WORD]		f_valP_o,
    output	reg[`BYTE]		f_dstE_o,
    output	reg[`BYTE]		f_dstM_o
);

	always @ (*) begin
		//if (rst == `RSTENABLE) begin
			f_icode_o	<=	4'h0;
			f_ifun_o	<=	4'h0;
			f_rA_o		<=	4'hf;
			f_rB_o		<=	4'hf;
			f_valC_o	<=	32'h00000000;
			f_valP_o	<=	16'h0000;
			f_dstE_o	<=	4'hf;
			f_dstM_o	<=	4'hf;
		if (rst == `RSTDISABLE) begin
			f_icode_o	<=	inst_i[`ICODE];
			f_ifun_o	<=	inst_i[`IFUN];
			case ( f_icode_o )
				`HALT:		begin
					f_valP_o	<=	pc_i+4'h1;
				end
				`NOP:		begin
					f_valP_o	<=	pc_i+4'h1;
				end
				`CMOVXX:	begin
					f_rA_o		<=	inst_i[`RA];
					f_rB_o		<=	inst_i[`RB];
					f_valP_o	<=	pc_i+4'h2;
					f_dstE_o	<=	inst_i[`RB];
				end
				`IRMOVL:	begin
					f_rA_o		<=	inst_i[`RA];
					f_rB_o		<=	inst_i[`RB];
					f_valC_o	<=	inst_i[`WORD];
					f_valP_o	<=	pc_i+4'h6;
					f_dstE_o	<=	inst_i[`RB];
				end
				`RMMOVL:	begin
					f_rA_o		<=	inst_i[`RA];
					f_rB_o		<=	inst_i[`RB];
					f_valC_o	<=	inst_i[`WORD];
					f_valP_o	<=	pc_i+4'h6;
				end
				`MRMOVL:	begin
					f_rA_o		<=	inst_i[`RA];
					f_rB_o		<=	inst_i[`RB];
					f_valC_o	<=	inst_i[`WORD];
					f_valP_o	<=	pc_i+4'h6;
					f_dstM_o	<=	inst_i[`RA];
				end
				`OPL:		begin
					f_rA_o		<=	inst_i[`RA];
					f_rB_o		<=	inst_i[`RB];
					f_valP_o	<=	pc_i+4'h2;
					f_dstE_o	<=	inst_i[`RB];
				end
				`JXX:		begin
					f_valC_o	<=	inst_i[`DEST];
					f_valP_o	<=	pc_i+4'h4;
				end
				`CALL:		begin
					f_valC_o	<=	inst_i[`DEST];
					f_valP_o	<=	pc_i+4'h4;
				end
				`RET:		begin
					f_valP_o	<=	pc_i+4'h1;
				end
				`PUSHL:		begin
					f_rA_o		<=	inst_i[`RA];
					f_rB_o		<=	`RESP;
					f_valP_o	<=	pc_i+4'h2;
					f_dstE_o	<=	`RESP;
				end
				`POPL:		begin
					f_rA_o		<=	`RESP;
					f_rB_o		<=	`RESP;
					f_valP_o	<=	pc_i+4'h2;
					f_dstE_o	<=	`RESP;
					f_dstM_o	<=	inst_i[`RA];
				end
			endcase
		end
	end
endmodule
