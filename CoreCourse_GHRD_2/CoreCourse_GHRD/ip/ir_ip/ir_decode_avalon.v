//只读型IP核比较好写
module ir_decode_avalon(
	cpu_clk,
	cpu_reset_n,
	
	cpu_cs,		//cpu片选信号
	cpu_read,	//cpu读请求信号
	cpu_addr,	//cpu读地址信号
	cpu_rddata,	//cpu读取数据端口
	
	cpu_write,	//cpu写请求
	cpu_wrdata,	//cpu写数据
	
	cpu_irq,
	
	iIR
);

	input cpu_clk;
	input cpu_reset_n;
	
	input cpu_cs;		//cpu片选信号
	input cpu_read;	//cpu读请求信号
	input [1:0]cpu_addr;	//cpu读地址信号
	output reg[15:0]cpu_rddata;	//cpu读取数据端口
	input cpu_write;
	input [15:0]cpu_wrdata;	//cpu写数据
	output reg cpu_irq;	//cpu中断请求
	
	input iIR;
	
	wire Get_Flag;
	
	wire [15:0]irData;
	wire [15:0]irAddr;

	reg [15:0]r_irData;
	reg [15:0]r_irAddr;
	
	always@(posedge cpu_clk or negedge cpu_reset_n)
	if(!cpu_reset_n)
		cpu_irq <= 1'b0;
	else if(Get_Flag)
		cpu_irq <= 1'b1;
	else if(cpu_cs && cpu_write && (cpu_addr == 2'd2))
		cpu_irq <= cpu_wrdata[0];

	always@(posedge cpu_clk or negedge cpu_reset_n)
	if(!cpu_reset_n)	
		cpu_rddata <= 16'd0;
	else if(cpu_cs && cpu_read)begin
		case(cpu_addr)
			2'd0:cpu_rddata <= r_irData;
			2'd1:cpu_rddata <= r_irAddr;
			2'd2:cpu_rddata[0] <= cpu_irq;
			2'd3:cpu_rddata <= cpu_rddata;
		endcase
	end

	//将解码模块的数据存入寄存器
	always@(posedge cpu_clk or negedge cpu_reset_n)
	if(!cpu_reset_n)begin
		r_irData <= 16'd0;
		r_irAddr <= 16'd0;
	end
	else if(Get_Flag)begin
		r_irData <= irData;
		r_irAddr <= irAddr;	
	end

	ir_decode ir_decode(
		.Clk(cpu_clk),
		.Rst_n(cpu_reset_n),
		.iIR(iIR),
		.Get_Flag(Get_Flag),
		.irData(irData),
		.irAddr(irAddr)
	);

endmodule


module ir_decode(
	Clk,
	Rst_n,
	
	iIR,
	
	Get_Flag,
	irData,
	irAddr
);

	input Clk;
	input Rst_n;
	input iIR;
	
	output Get_Flag;
	output [15:0]irData;
	output [15:0]irAddr;
	
	reg [18:0]cnt;//time counter
	reg [3:0]state;
	
	reg T9ms_ok;
	reg T4_5ms_ok;
	reg T_56ms_ok;
	reg T1_69ms_ok;
	
	reg Get_Data_Done;
	reg Cnt_en;
	reg timeout;
	reg [5:0]data_cnt;
	
	reg [31:0]data_tmp;
	
	assign irAddr = data_tmp[15:0];
	assign irData = data_tmp[31:16];
	
	localparam 
		IDEL = 4'b0001,
		LEADER_T9 = 4'b0010,
		LEADER_T4_5 = 4'b0100,
		DATE_GET = 4'b1000;
		
	reg s_IR0,s_IR1;
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		s_IR0 <= 1'b0;
		s_IR1 <= 1'b0;
	end
	else begin
		s_IR0 <= iIR;
		s_IR1 <= s_IR0;
	end
	
	reg s_IR0_Temp,s_IR1_Temp;
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		s_IR0_Temp <= 1'b0;
		s_IR1_Temp <= 1'b0;
	end
	else begin
		s_IR0_Temp <= s_IR1;
		s_IR1_Temp <= s_IR0_Temp;
	end
	
	wire ir_pedge,ir_nedge;
	
	assign ir_pedge = !s_IR1_Temp && s_IR0_Temp;
	assign ir_nedge = s_IR1_Temp && !s_IR0_Temp;

	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		T9ms_ok <= 1'b0;
	else if(cnt > 19'd325000 && cnt <19'd495000)
		T9ms_ok <= 1'b1;
	else
		T9ms_ok <= 1'b0;
		
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		T4_5ms_ok <= 1'b0;
	else if(cnt > 19'd152500 && cnt <19'd277500)
		T4_5ms_ok <= 1'b1;
	else
		T4_5ms_ok <= 1'b0;
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		T_56ms_ok <= 1'b0;
	else if(cnt > 19'd20000 && cnt <19'd35000)
		T_56ms_ok <= 1'b1;
	else
		T_56ms_ok <= 1'b0;
		
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		T1_69ms_ok <= 1'b0;
	else if(cnt > 19'd75000 && cnt <19'd90000)
		T1_69ms_ok <= 1'b1;
	else
		T1_69ms_ok <= 1'b0;
		
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)	
		cnt <= 19'd0;
	else if(Cnt_en == 1'b1)
		cnt <= cnt + 1'b1;
	else
		cnt <= 19'd0;
		
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)	
		timeout <= 1'b0;
	else if(cnt >= 19'd500000)
		timeout <= 1'b1;
	else 
		timeout <= 1'b0;

	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		state <= IDEL;
		Cnt_en <= 1'b0;
	end
	else if(!timeout)begin
		case(state)
			IDEL:
				if(ir_nedge)begin
					Cnt_en <= 1'b1;
					state <= LEADER_T9;
				end
				else begin
					state <= IDEL;
					Cnt_en <= 1'b0;
				end
			
			LEADER_T9:
				if(ir_pedge)begin
					if(T9ms_ok)begin
						Cnt_en <= 1'b0;
						state <= LEADER_T4_5;
					end
					else begin
						state <= IDEL;	
					end
				end
				else begin
					state <= LEADER_T9;
					Cnt_en <= 1'b1;
				end
					
			LEADER_T4_5:
				if(ir_nedge)begin
					if(T4_5ms_ok)begin
						Cnt_en <= 1'b0;
						state <= DATE_GET;
					end
					else begin
						state <= IDEL;	
					end
				end
				else begin
					state <= LEADER_T4_5;
					Cnt_en <= 1'b1;
				end
					
			DATE_GET:
				if(ir_pedge && !T_56ms_ok)
					state <= IDEL;
				else if(ir_nedge && (!T_56ms_ok && !T1_69ms_ok))
					state <= IDEL;			
				else if(Get_Data_Done)
					state <= IDEL;	
				else if(ir_pedge && T_56ms_ok)begin
					Cnt_en <= 1'b0;
				end
				else if(ir_nedge && (T_56ms_ok || T1_69ms_ok))begin
					Cnt_en <= 1'b0;				
				end
				else
					Cnt_en <= 1'b1;
			default:;
		endcase
	end
	else begin
		Cnt_en <= 1'b0;
		state <= IDEL;	
	end
	
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)begin
		Get_Data_Done <= 1'b0;
		data_cnt <= 6'd0;
		data_tmp <= 32'd0;
	end
	else if(state == DATE_GET)begin
		if(ir_pedge && (data_cnt == 6'd32))begin
			data_cnt <= 6'd0;
			Get_Data_Done <= 1'b1;
		end
		else begin
			if(ir_nedge)
				data_cnt <= data_cnt + 1'b1;
			if(ir_nedge && T_56ms_ok)
				data_tmp[data_cnt] <= 1'b0;
			else if(ir_nedge && T1_69ms_ok)
				data_tmp[data_cnt] <= 1'b1;
			Get_Data_Done <= 1'b0;
		end	
	end
	
	assign Get_Flag = Get_Data_Done;

endmodule

