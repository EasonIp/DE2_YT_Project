module check_iloveyou (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input [7:0]data_in,
	output reg [7:0]check_out,
	output reg flag_check
);

	reg [3:0] state;
	localparam IDEL        = 4'd0 ;   /*IDEL状态*/
	localparam Check_I     = 4'd1 ;  /*check_I*/
	localparam Disp_blank1 = 4'd2 ;
	localparam Check_L     = 4'd3 ;
	localparam Check_o1    = 4'd4 ;
	localparam Check_v     = 4'd5 ;
	localparam Check_e     = 4'd6 ;
	localparam Disp_blank2 = 4'd7 ;
	localparam Check_Y     = 4'd8 ;
	localparam Check_o2    = 4'd9 ;
	localparam Check_u     = 4'd10;
	localparam Disp_gantan = 4'd11;
	// localparam Error = 4'd12;  /**/


	always @(posedge clk or negedge rst_n) begin : proc_1
		if(~rst_n) begin
				state      <= IDEL;
				flag_check <= 0;
				check_out  <= " ";  //8'h20  空格
		end else begin
			case (state)
				IDEL       	: 	begin 	
									state      <= Check_I;
									flag_check <= 0;
									check_out  <= " ";
								end
				Check_I    	: 	begin 	
									if(data_in == "I") begin
										state <= Disp_blank1;
										check_out  <= "I";
									end
									else  state <= Check_I;
								end
				Disp_blank1	: 	begin 	
									state      <= Check_L;
									check_out  <= " ";
								end
				Check_L    	: 	begin 	
									if(data_in == "L") begin
										state <= Check_o1;
										check_out  <= "L";
									end
									else  state <= Check_L;
								end
				Check_o1    	: 	begin 	
									if(data_in == "o") begin
										state <= Check_v;
										check_out  <= "o";
									end
									else  state <= Check_o1;
								end
				Check_v    	: 	begin 	
									if(data_in == "v") begin
										state <= Check_e;
										check_out  <= "v";
									end
									else  state <= Check_v;
								end
				Check_e    	: 	begin 	
									if(data_in == "e") begin
										state <= Disp_blank2;
										check_out  <= "e";
									end
									else  state <= Check_e;
								end
				Disp_blank2	: 	begin 	
									state      <= Check_Y;
									check_out  <= " ";
								end
				Check_Y    	: 	begin 	
									if(data_in == "Y") begin
										state <= Check_o2;
										check_out  <= "Y";
									end
									else  state <= Check_Y;
								end
				Check_o2    	: 	begin 	
									if(data_in == "o") begin
										state <= Check_u;
										check_out  <= "o";
									end
									else  state <= Check_o2;
								end
				Check_u    	: 	begin 	
									if(data_in == "u") begin
										state <= Disp_gantan;
										check_out  <= "o";
									end
									else  state <= Check_u;
								end
				Disp_gantan  : 	begin /* state ==11*/	
									state      <= IDEL;
									check_out  <= "!";   /*8'h21*/
									flag_check <= 1;
								end

				default 	: 	begin
									state      <= IDEL;
								end/* default */
			endcase
		end
	end

endmodule