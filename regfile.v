`include "defines.v"

module regfile(
	input	wire                clk,
	input	wire                rst,
	input	wire[`NIBBLE]	    srcA,
	input	wire[`NIBBLE]	    srcB,
	input	wire[`NIBBLE]	    dstE,
	input	wire[`NIBBLE]	    dstM,
        input	wire[`WORD]         valE,
	input	wire[`WORD]         valM,
	output	reg[`WORD]          valA,
	output	reg[`WORD]          valB
);

	reg[`WORD]	regs[0:`REGNUM-1];

	initial regs[0] <=      32'H00000000;
	initial regs[1] <=      32'H00000000;
	initial regs[2] <=      32'H00000000;
	initial regs[3] <=      32'H00000000;
	initial regs[4] <=      32'H00000000;
	initial regs[5] <=      32'H00000000;
	initial regs[6] <=      32'H00000000;
	initial regs[7] <=      32'H00000000;

	always @ (posedge clk) begin
		if(dstE != `RNONE) begin
			regs[dstE] <=   valE;
		end
		if(dstM != `RNONE) begin
			regs[dstM] <=   valM;
		end
	end

	always @ (*) begin
		if(srcA != `RNONE) begin
			valA <=     regs[srcA];
		end
	end

	always @ (*) begin
		if(srcB != `RNONE) begin
			valB <=     regs[srcB];
		end
	end

endmodule
