
`timescale 1ns/1ps
`define period 20

module tb_top_run_seg3 (); /* this is automatically generated */
	// clock
    // (*NOTE*) replace reset, clock, others

	logic       CLOCK_50;
	logic       rst_n;
	logic       key_in;
	logic [6:0] oSEG0;
	logic [6:0] oSEG1;
	logic [6:0] oSEG2;
	logic [6:0] oSEG3;
	logic [6:0] oSEG4;
	logic [6:0] oSEG5;
	logic [6:0] oSEG6;
	logic [6:0] oSEG7;


	initial begin
		CLOCK_50 = 0;
		forever #(`period/2) CLOCK_50 = ~CLOCK_50;
	end

	// reset
	initial begin
		rst_n = 0;
		#(`period*2)  rst_n = 1;
	end


	top_run_seg3 inst_top_run_seg3
		(
			.CLOCK_50 (CLOCK_50),
			.rst_n    (rst_n),
			.key_in   (key_in),
			.oSEG0    (oSEG0),
			.oSEG1    (oSEG1),
			.oSEG2    (oSEG2),
			.oSEG3    (oSEG3),
			.oSEG4    (oSEG4),
			.oSEG5    (oSEG5),
			.oSEG6    (oSEG6),
			.oSEG7    (oSEG7)
		);

	initial begin
		// do something
		key_in = 1;
		#(`period*5)  key_in = 0;
		#(`period*100000)  key_in = 1;
		#(`period*50000000)
		repeat(10)@(posedge CLOCK_50);
		$stop;
	end

	// dump wave
	initial begin
        $fsdbDumpfile("tb_top_run_seg3.fsdb");
        $fsdbDumpvars(0, "tb_top_run_seg3", "+mda");
	end

endmodule
