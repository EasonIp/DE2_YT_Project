module run_seg2 (
	input CLOCK_50,    // Clock
	input rst_n,
    input [31:0]indata_24bit, 
	output [31:0]outdata_24bit 
	
);

	reg [31:0]cont;   //
	reg clk_seg;
parameter Num_cont = 50_000_000 / 1 /2 -1;   /*1Hz*/

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
reg [31:0]r_indata_24bit;  //异步输入缓存

always @(posedge clk_seg or negedge rst_n) begin : proc_disp
	if(~rst_n) begin
		r_indata_24bit <= 0;
	end else begin
		r_indata_24bit <= indata_24bit;
		
	end
end

assign outdata_24bit = r_indata_24bit;

endmodule