`include "defines.v"
module pc_reg(
	input	wire			clk,
	input	wire			rst,
	input	wire[`PCLEN]	newPC,
	output	reg[`PCLEN]		pc
	//output	reg				ce
);

	//always @ (posedge clk) begin
	//	if (rst == `RSTENABLE) begin
	//		ce <= `CHIPDISABLE;
	//	end else begin
	//		ce <= `CHIPENABLE;
	//	end
	//end

	initial pc <= 48'h000000000000;
	always @ (*) begin
		if (rst == `RSTDISABLE) begin
			pc <= newPC;
		end
	end
endmodule

