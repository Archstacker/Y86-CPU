`include "defines.v"

module regfile(
	input	wire			clk,
	input	wire			rst,
	input	wire[`BYTE]		srcA,
	input	wire[`BYTE]		srcB,
	output	reg[`WORD]		valA,
	output	reg[`WORD]		valB
);

reg[`WORD]	regs[0:`REGNUM-1];

	initial regs[0] <= 32'H00000001;
	initial regs[1] <= 32'H00000002;
	initial regs[2] <= 32'H00000003;
	initial regs[3] <= 32'H00000004;
	initial regs[4] <= 32'H00000005;
	initial regs[5] <= 32'H00000006;
	initial regs[6] <= 32'H00000007;
	initial regs[7] <= 32'H00000011;

	always @ (*) begin
		if(srcA != `NOREG) begin
			valA <= regs[srcA];
		end
	end

	always @ (*) begin
		if(srcB != `NOREG) begin
			valB <= regs[srcB];
		end
	end

endmodule
