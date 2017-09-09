module rom_ctrl (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	output [7:0]addr
);


always @(posedge clk or negedge rst_n) begin : proc_1
	if(~rst_n) begin
		addr <= 8'd0;
	end else begin
		 if(addr == 8'b1111_1111) begin
		 	addr <= 0;
		 end
		 else begin
		 	addr <= addr + 1;
		 end
	end
end

endmodule