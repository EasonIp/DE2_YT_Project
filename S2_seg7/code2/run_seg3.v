module run_seg3 (
	input CLOCK_50,    // Clock
	input rst_n,
	input key_flag,
	output [7:0]cout_cnt
	
);

	reg [31:0]cont;   //
	reg clk_seg;
parameter Num_cont = 50_000_000 / 1 /2 -1;   /*1Hz*/

	reg start;

always @(posedge CLOCK_50 or negedge rst_n) begin : proc_start
	if(~rst_n) begin
		start <= 0;
	end else begin
		if(key_flag) begin
			start <= 1;
		end else
			start <= 0;
	end
end

always @(posedge CLOCK_50 or negedge rst_n) begin : proc_clk
	if(~rst_n) begin
		cont <= 0;
		clk_seg <= 0;
	end else begin
		if(cont == Num_cont) begin
			cont <= 0;
			clk_seg <= ~clk_seg;
		end else begin
			cont <= cont + 1;
		end
	end
end
reg [7:0]r_cout_cnt;  

always @(posedge clk_seg or negedge rst_n) begin : proc_disp
	if(~rst_n) begin
		r_cout_cnt <= 0;
	end else begin
		if(start) begin
			r_cout_cnt <= r_cout_cnt +1;
		end
		else
		r_cout_cnt <= 0;
	end
end

assign cout_cnt = r_cout_cnt;

endmodule