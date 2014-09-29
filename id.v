`include "defines.v"

module id(
    input   wire			rst,
    input   wire[`PCLEN]	pc_i,
    input   wire[`INSTBUS]	inst_i,

    //output  reg         instr_valid,
    //output  reg         need_regids,
    //output  reg         need_valC,

    output	reg[`BYTE]   icode,
    output	reg[`BYTE]   ifun,
    output	reg[`BYTE]   rA,
    output	reg[`BYTE]   rB,
    output	reg[`WORD]	 valC,
    output	reg[`PCLEN]  valP
);

	always @ (*) begin
		//if (rst == `RSTENABLE) begin
			icode	<=	4'h0;
			ifun	<=	4'h0;
			rA		<=	4'h0;
			rB		<=	4'h0;
			valC	<=	32'h00000000;
			valP	<=	16'h0000;
		if (rst == `RSTDISABLE) begin
			icode	<=	inst_i[`ICODE];
			ifun	<=	inst_i[`IFUN];
			case (icode)
				`HALT:		begin
					valP	<=	pc_i+4'h1;
				end
				`NOP:		begin
					valP	<=	pc_i+4'h1;
				end
				`RRMOVL:	begin
					rA		<=	inst_i[`RA];
					rB		<=	inst_i[`RB];
					valP	<=	pc_i+4'h2;
				end
				`IRMOVL:	begin
					rA		<=	inst_i[`RA];
					rB		<=	inst_i[`RB];
					valC	<=	inst_i[`WORD];
					valP	<=	pc_i+4'h6;
				end
				`RMMOVL:	begin
					rA		<=	inst_i[`RA];
					rB		<=	inst_i[`RB];
					valC	<=	inst_i[`WORD];
					valP	<=	pc_i+4'h6;
				end
				`MRMOVL:	begin
					rA		<=	inst_i[`RA];
					rB		<=	inst_i[`RB];
					valC	<=	inst_i[`WORD];
					valP	<=	pc_i+4'h6;
				end
				`OPL:		begin
					rA		<=	inst_i[`RA];
					rB		<=	inst_i[`RB];
					valP	<=	pc_i+4'h2;
				end
				`JXX:		begin
					valC	<=	inst_i[`DEST];
					valP	<=	pc_i+4'h4;
				end
				`CMOVXX:	begin
					rA		<=	inst_i[`RA];
					rB		<=	inst_i[`RB];
					valP	<=	pc_i+4'h2;
				end
				`CALL:		begin
					valC	<=	inst_i[`DEST];
					valP	<=	pc_i+4'h4;
				end
				`RET:		begin
					valP	<=	pc_i+4'h1;
				end
				`PUSHL:		begin
					rA		<=	inst_i[`RA];
					valP	<=	pc_i+4'h2;
				end
				`POPL:		begin
					rA		<=	inst_i[`RA];
					valP	<=	pc_i+4'h2;
				end
			endcase
		end
	end
endmodule
