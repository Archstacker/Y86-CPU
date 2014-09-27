`include "defines.v"

module id(
    input   wire			rst,
    input   wire[`PCLEN]	pc_i,
    input   wire[`INSTBUS]	inst_i,

    //output  reg         instr_valid,
    //output  reg         need_regids,
    //output  reg         need_valC,

    output	reg[3:0]   icode,
    output	reg[3:0]   ifun,
    output	reg[3:0]   rA,
    output	reg[3:0]   rB,
    output	reg[31:0]	valC
);

	initial		icode	<=	4'b0000;
	initial		ifun	<=	4'b0000;
	always @ (*) begin
		icode	<=	inst_i[`ICODE];
		ifun	<=	inst_i[`IFUN];
		case (icode)
			`RRMOVL:	begin
				rA		<=	inst_i[`RA];
				rB		<=	inst_i[`RB];
			end
			`IRMOVL:	begin
				rA		<=	inst_i[`RA];
				rB		<=	inst_i[`RB];
				valC	<=	inst_i[`IMME];
			end
			`MRMOVL:	begin
				rA		<=	inst_i[`RA];
				rB		<=	inst_i[`RB];
				valC	<=	inst_i[`IMME];
			end
			`OPL:		begin
				rA		<=	inst_i[`RA];
				rB		<=	inst_i[`RB];
			end
			`JXX:		begin
				valC	<=	inst_i[`DEST];
			end
			`CMOVXX:	begin
				rA		<=	inst_i[`RA];
				rB		<=	inst_i[`RB];
			end
			`CALL:		begin
				valC	<=	inst_i[`DEST];
			end
			`RET:		begin
			end
			`PUSHL:		begin
				rA		<=	inst_i[`RA];
			end
			`POPL:		begin
				rA		<=	inst_i[`RA];
			end
		endcase
	end
endmodule
