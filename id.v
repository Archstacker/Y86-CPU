`include "defines.v"

module id(
    input   wire			rst,
    input   wire[`WORD]		pc_i,
    input   wire[`INSTBUS]	inst_i,
	input	reg[`WORD]		valA_i,
	input	reg[`WORD]		valB_i,

    //output  reg         instr_valid,
    //output  reg         need_regids,
    //output  reg         need_valC,

    output	reg[`BYTE]		icode_o,
    output	reg[`BYTE]		ifun_o,
    output	reg[`BYTE]		rA_o,
    output	reg[`BYTE]		rB_o,
	output	reg[`WORD]		valA_o,
	output	reg[`WORD]		valB_o,
    output	reg[`WORD]		valC_o,
    output	reg[`WORD]		valP_o
);

	always @ (*) begin
		//if (rst == `RSTENABLE) begin
			icode_o	<=	4'h0;
			ifun_o	<=	4'h0;
			rA_o	<=	4'hf;
			rB_o	<=	4'hf;
			valC_o	<=	32'h00000000;
			valP_o	<=	16'h0000;
		if (rst == `RSTDISABLE) begin
			icode_o	<=	inst_i[`ICODE];
			ifun_o	<=	inst_i[`IFUN];
			case (icode_o)
				`HALT:		begin
					valP_o	<=	pc_i+4'h1;
				end
				`NOP:		begin
					valP_o	<=	pc_i+4'h1;
				end
				`CMOVXX:	begin
					rA_o	<=	inst_i[`RA];
					rB_o	<=	inst_i[`RB];
					valP_o	<=	pc_i+4'h2;
				end
				`IRMOVL:	begin
					rA_o	<=	inst_i[`RA];
					rB_o	<=	inst_i[`RB];
					valC_o	<=	inst_i[`WORD];
					valP_o	<=	pc_i+4'h6;
				end
				`RMMOVL:	begin
					rA_o	<=	inst_i[`RA];
					rB_o	<=	inst_i[`RB];
					valC_o	<=	inst_i[`WORD];
					valP_o	<=	pc_i+4'h6;
				end
				`MRMOVL:	begin
					rA_o	<=	inst_i[`RA];
					rB_o	<=	inst_i[`RB];
					valC_o	<=	inst_i[`WORD];
					valP_o	<=	pc_i+4'h6;
				end
				`OPL:		begin
					rA_o	<=	inst_i[`RA];
					rB_o	<=	inst_i[`RB];
					valP_o	<=	pc_i+4'h2;
				end
				`JXX:		begin
					valC_o	<=	inst_i[`DEST];
					valP_o	<=	pc_i+4'h4;
				end
				`CALL:		begin
					valC_o	<=	inst_i[`DEST];
					valP_o	<=	pc_i+4'h4;
				end
				`RET:		begin
					valP_o	<=	pc_i+4'h1;
				end
				`PUSHL:		begin
					rA_o	<=	inst_i[`RA];
					valP_o	<=	pc_i+4'h2;
				end
				`POPL:		begin
					rA_o	<=	inst_i[`RA];
					rB_o	<=	inst_i[`RB];
					valP_o	<=	pc_i+4'h2;
				end
			endcase
		end
	end
	always @ (*) begin
		valA_o	<=	valA_i;
		valB_o	<=	valB_i;
	end
endmodule
