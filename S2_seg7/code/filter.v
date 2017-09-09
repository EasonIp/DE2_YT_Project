module filter(clk, rst_n, key_in, sum,key_flag);

	input clk,rst_n;
	input key_in;
	output reg [3:0] sum;
	
	output reg key_flag;
	
	reg [31:0] count;
	
	reg state;
	
	`define T 50_000_000/50
	// `define T 600
	
	always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				key_flag <= 0;
				count <= 0;
				state <= 0;
			end
		else
			case(state)
				0	:	begin
							if(!key_in)
								begin
									if(count < `T - 1)
										begin
											count <= count + 1;
											key_flag <= 0;
											state <= 0;
										end
									else
										begin
											count <= 0;
											key_flag <= 1;
											state <= 1;
										end
								end
//							else
//								begin
//									count <= 0;
//									state <= 0;
//									key_flag <= 0;
//								end
						end
						
				1	:	begin
							key_flag <= 0;
							if(key_in)
								begin
									if(count < `T - 1)
										begin
											count <= count + 1;
											state <= 1;
										end
									else
										begin
											count <= 0;
											state <= 0;
										end
								end
							else
								begin
									count <= 0;
//									state <= 1;
								end
						end	
			endcase
	end
	
	always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			sum <= 3'd0;
		else
			begin
				if(key_flag)
					sum <= sum + 1'b1;
				else
					sum <= sum;
			end
	end
	
endmodule 
