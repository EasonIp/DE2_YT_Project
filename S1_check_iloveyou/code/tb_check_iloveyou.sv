
`timescale 1ns/1ps
`define  clk_period 20

module tb_check_iloveyou (); /* this is automatically generated */

	logic clk;    // Clock
	logic rst_n;  // Asynchronous reset active low
	logic [7:0]data_in;
	logic [7:0]check_out;
	logic flag_check;

	// clock
	initial begin
		clk = 0;
		forever #(`clk_period/2) clk = ~clk;
	end

	// reset
	initial begin
		rst_n = 0;
		
		#(`clk_period*2)
		rst_n = 1;
		// #(clk_period) data_in = 65 + {$random} % 26;   //65=A   97=a
		forever 
		begin
			#(`clk_period) data_in = "A" + {$random} % 58;   /*(26+32)*/
		end

	end

	check_iloveyou inst_check_iloveyou
		(
			.clk        (clk),
			.rst_n      (rst_n),
			.data_in    (data_in),
			.check_out  (check_out),
			.flag_check (flag_check)
		);


	// dump wave
	initial begin
        $fsdbDumpfile("tb_check_iloveyou.fsdb");
        $fsdbDumpvars(0, "tb_check_iloveyou", "+mda");
	end

endmodule
