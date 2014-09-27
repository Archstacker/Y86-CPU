`include "defines.v"
module inst_rom(
	input	wire[`PCLEN]			addr,
	output	wire[`INSTBUS]			inst
);

	reg [7:0]	inst_mem[0:`INSTMEMNUM-1];

	initial $readmemh ( "inst_rom.data",	inst_mem );
	initial begin
	$display("%h",inst_mem[0]);
	end

	//always @ (*)begin
	//	inst	<=	inst_mem[addr[`PCLENNUM-1:2]];
	//end
	assign inst = {inst_mem[addr],inst_mem[addr+1],inst_mem[addr+2],inst_mem[addr+3],inst_mem[addr+4],inst_mem[addr+5]};

endmodule
