module top_run_seg2 (
	input CLOCK_50,    // Clock
	input rst_n,
	input key_in, 
	output	[6:0]	oSEG0,oSEG1,oSEG2,oSEG3,oSEG4,oSEG5,oSEG6,oSEG7
);

 // input [31:0]indata_24bit, 
    reg [31:0]indata_24bit; 

	wire [31:0]outdata_24bit;

	wire  [3:0]sum;

	filter inst_filter
(
	.clk          (CLOCK_50),
	.rst_n        (rst_n),
	.key_in       (key_in),
	.sum          (sum),
	.key_key_flag ()     /* 这里没用到，不写*/
);

		run_seg2  inst_run_seg2 (
			.CLOCK_50      (CLOCK_50),
			.rst_n         (rst_n),
			// .indata_24bit  ({4'd8,sum,sum,sum,sum,sum,sum,4'd0}),
			.indata_24bit  ({4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,sum}),
			.outdata_24bit (outdata_24bit)
		);


		SEG7_LUT_8 inst_SEG7_LUT_8
		(
			.oSEG0 (oSEG0),
			.oSEG1 (oSEG1),
			.oSEG2 (oSEG2),
			.oSEG3 (oSEG3),
			.oSEG4 (oSEG4),
			.oSEG5 (oSEG5),
			.oSEG6 (oSEG6),
			.oSEG7 (oSEG7),
			.iDIG  (outdata_24bit)
		);




endmodule