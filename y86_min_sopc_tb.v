`include "defines.v"
`timescale 1ns/1ps

module y86_min_sopc_tb();

	reg		clock_50;
	reg		rst;

	initial begin
		clock_50 = 1'b0;
		forever #10 clock_50 = ~clock_50;
	end
	initial begin
		rst = `RSTENABLE;
		#55 rst = `RSTDISABLE;
		#200 $stop;
	end

	y86_min_sopc y86_min_sopc0(
		.clk(clock_50),
		.rst(rst)
	);

endmodule
