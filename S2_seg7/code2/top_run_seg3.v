module top_run_seg3 (
	input CLOCK_50,    // Clock
	input rst_n,
	input key_in, 
	output	[6:0]	oSEG0,oSEG1,oSEG2,oSEG3,oSEG4,oSEG5,oSEG6,oSEG7
);

 // input [31:0]indata_24bit, 
 //    reg [31:0]indata_24bit; 

	// wire [31:0]outdata_24bit;

	wire  key_flag;
	wire [7:0]cout_cnt;

	wire [3:0]hundreds;
	wire [3:0]tens;
	wire [3:0]ones;


	filter inst_filter
(
	.clk          (CLOCK_50),
	.rst_n        (rst_n),
	.key_in       (key_in),
	.sum          (),
	.key_flag (key_flag)     /* 这里没用到，不写*/
);

	run_seg3 inst_run_seg3 (
			.CLOCK_50 (CLOCK_50),
			.rst_n    (rst_n),
			// .key_flag (1'b1),
			.key_flag (key_flag),
			.cout_cnt (cout_cnt)
		);


	B2BCD inst_B2BCD (
		.binary_in(cout_cnt), 
		.hundreds(hundreds), 
		.tens(tens), 
		.ones(ones));
	

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
			.iDIG  ({4'd7,4'd6,4'd5,4'd4,4'd3,hundreds,tens,ones})
		);




endmodule