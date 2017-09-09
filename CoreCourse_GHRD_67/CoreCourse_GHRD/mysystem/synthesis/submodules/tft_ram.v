module tft_ram(
	input AS_CLK,
	input AS_RST_N,

	input AS_NCS,
	input [17:0]AS_ADDR,
	input [15:0]AS_WRDATA,
	input AS_WRREQ,
	output reg AS_WAIT,
	
	output reg SRAM_NOE,
	output reg SRAM_NWE,
	output reg SRAM_NCE,
	output [1:0]SRAM_BE,
	output reg [17:0]SRAM_ADDR,
	inout [15:0]SRAM_DQ,
	
	input Clk9M,
	output [15:0]TFT_RGB,
	output TFT_HS,
	output TFT_VS,
	output TFT_CLK,
	output TFT_DE,
	output TFT_PWM
);

	wire [15:0]oSRAM_DQ;
	
	assign SRAM_DQ = (!SRAM_NWE && !SRAM_NCE && !TFT_RDREQ)?oSRAM_DQ:16'hzzzz;
	assign SRAM_BE = 2'b00;
	
	reg [15:0]disp_data;
	wire [9:0]hcount;
	wire [9:0]vcount;
	
	TFT_CTRL TFT_CTRL(
		.Clk9M(Clk9M),	//系统输入时钟9MHZ
		.Rst_n(AS_RST_N),
		.data_in(disp_data),	//待显示数据
		.hcount(hcount),		//TFT行扫描计数器
		.vcount(vcount),		//TFT场扫描计数器
		.TFT_RGB(TFT_RGB),	//TFT数据输出
		.TFT_HS(TFT_HS),		//TFT行同步信号
		.TFT_VS(TFT_VS),		//TFT场同步信号
		.TFT_CLK(TFT_CLK),
		.TFT_DE(TFT_DE),
		.TFT_PWM(TFT_PWM)
	);
	
	reg [1:0]Clk_reg;
	wire pedge_Clk9M;
	always@(posedge AS_CLK)
		Clk_reg <= {Clk_reg[0],Clk9M} ;
	
	assign pedge_Clk9M = (Clk_reg == 2'b01);
	wire TFT_RDREQ;
	
	assign TFT_RDREQ = pedge_Clk9M && TFT_DE;
	
	reg r_TFT_RDREQ;
	
	always@(posedge AS_CLK)
		r_TFT_RDREQ <= TFT_RDREQ;
		
	reg r_SRAM_NOE;

	always@(posedge AS_CLK)
		r_SRAM_NOE <= SRAM_NOE;
		
	always@(posedge AS_CLK)
	if(!r_SRAM_NOE && !SRAM_NOE)
		disp_data <= SRAM_DQ;
		
	always@(*)
	if(!TFT_RDREQ && !AS_NCS && AS_WRREQ)	//无读请求，有写请求
		SRAM_ADDR <= AS_ADDR[17:0];	//SRAM地址为写地址
	else
		SRAM_ADDR <= vcount * 480 + hcount;	//SRAM地址为读地址
		
	assign oSRAM_DQ = AS_WRDATA;	//SRAM地址为写地址
			
	always@(*)
	if(!TFT_RDREQ && !AS_NCS && AS_WRREQ)begin	//无读请求，有写请求
		SRAM_NCE <= 0;
		SRAM_NWE <= 0;
		SRAM_NOE <= 1;
	end
	else begin
		SRAM_NCE <= 0;
		SRAM_NWE <= 1;
		SRAM_NOE <= 0;
	end
	
	//AS——WAIT 从机要求总线等待
	always@(*)
		AS_WAIT = TFT_RDREQ || r_TFT_RDREQ;
	
endmodule

module TFT_CTRL(
	Clk9M,	//系统输入时钟9MHZ
	Rst_n,	//复位输入，低电平复位
	data_in,	//待显示数据
	hcount,		//TFT行扫描计数器
	vcount,		//TFT场扫描计数器
	TFT_RGB,	//TFT数据输出
	TFT_HS,		//TFT行同步信号
	TFT_VS,		//TFT场同步信号
	TFT_CLK,		//TFT像素时钟
	TFT_DE,		//TFT数据使能
	TFT_PWM		//TFT背光控制
);
			
	//----------------模块输入端口----------------
	input  Clk9M;          //系统输入时钟9MHZ
	input  Rst_n;
	input  [15:0]data_in;     //待显示数据

	//----------------模块输出端口----------------
	output [9:0]hcount;
	output [9:0]vcount;
	output [15:0]TFT_RGB;  //TFT数据输出
	output TFT_HS;           //TFT行同步信号
	output TFT_VS;           //TFT场同步信号
	output TFT_CLK;
	output TFT_DE;
	output TFT_PWM;

	//----------------内部寄存器定义----------------
	reg [9:0] hcount_r;     //TFT行扫描计数器
	reg [9:0] vcount_r;     //TFT场扫描计数器
	//----------------内部连线定义----------------
	wire hcount_ov;
	wire vcount_ov;
	wire dat_act;//有效显示区标定

	//TFT行、场扫描时序参数表
	parameter TFT_HS_end=10'd40,
				 hdat_begin=10'd42,
				 hdat_end=10'd522,
				 hpixel_end=10'd524,
				 TFT_VS_end=10'd9,
				 vdat_begin=10'd11,
				 vdat_end=10'd283,
				 vline_end=10'd285;

	assign hcount=hcount_r-hdat_begin;
	assign vcount=vcount_r-vdat_begin;
	
	assign TFT_CLK = Clk9M;
	assign TFT_DE = dat_act;
	assign TFT_PWM = Rst_n;

	//**********************TFT驱动部分**********************
	//行扫描
	always@(posedge Clk9M or negedge Rst_n)
	if(!Rst_n)
		hcount_r<=10'd0;
	else if(hcount_ov)
		hcount_r<=10'd0;
	else
		hcount_r<=hcount_r+10'd1;

	assign hcount_ov=(hcount_r==hpixel_end);

	//场扫描
	always@(posedge Clk9M or negedge Rst_n)
	if(!Rst_n)
		vcount_r<=10'd0;
	else if(hcount_ov) begin
		if(vcount_ov)
			vcount_r<=10'd0;
		else
			vcount_r<=vcount_r+10'd1;
	end
	else 
		vcount_r<=vcount_r;
		
	assign 	vcount_ov=(vcount_r==vline_end);

	//数据、同步信号输出
	assign dat_act=((hcount_r>=hdat_begin)&&(hcount_r<hdat_end))
					&&((vcount_r>=vdat_begin)&&(vcount_r<vdat_end));
					
	assign TFT_HS=(hcount_r>TFT_HS_end);
	assign TFT_VS=(vcount_r>TFT_VS_end);
	assign TFT_RGB=(dat_act)?data_in:16'h0000;
		
endmodule 

