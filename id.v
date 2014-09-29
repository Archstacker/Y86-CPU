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
    output	reg[`IMME]	 valC,
    output	reg[`PCLEN]  valP
);

	initial		icode	<=	4'b0000;
	initial		ifun	<=	4'b0000;
	always @ (*) begin
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
				valC	<=	inst_i[`IMME];
				valP	<=	pc_i+4'h6;
			end
			`RMMOVL:	begin
				rA		<=	inst_i[`RA];
				rB		<=	inst_i[`RB];
				valC	<=	inst_i[`IMME];
				valP	<=	pc_i+4'h6;
			end
			`MRMOVL:	begin
				rA		<=	inst_i[`RA];
				rB		<=	inst_i[`RB];
				valC	<=	inst_i[`IMME];
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
endmodule
