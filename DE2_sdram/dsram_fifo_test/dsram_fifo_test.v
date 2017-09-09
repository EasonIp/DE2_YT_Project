module dsram_fifo_test(
		//////////// VGA //////////
		output [7:0]VGA_B,
		output VGA_BLANK_N,
		output VGA_CLK,
		output [7:0]VGA_G,
		output VGA_HS,
		output [7:0]VGA_R,
		output VGA_SYNC_N,
		output VGA_VS,
			// FPGA��LCD�ӿ��ź�
		output lcd_en,	//����ʹ���źţ�����Ч
		output lcd_clk,	//ʱ���ź�	
		output lcd_hsy,	//��ͬ���ź�
		output lcd_vsy,	//��ͬ���ź�
		output[4:0] lcd_db_r,
		output[5:0] lcd_db_g,
		output[4:0] lcd_db_b,
			// FPGA��SDRAMӲ���ӿ�
		output sdram_clk,			//	SDRAMʱ���ź�
		output sdram_cke,			//  SDRAMʱ����Ч�ź�
		output sdram_cs_n,			//	SDRAMƬѡ�ź�
		output sdram_ras_n,			//	SDRAM�е�ַѡͨ����
		output sdram_cas_n,			//	SDRAM�е�ַѡͨ����
		output sdram_we_n,			//	SDRAMд����λ
		output[1:0] sdram_ba,		//	SDRAM��L-Bank��ַ��
		output[11:0] sdram_addr,	//  SDRAM��ַ����
		inout[15:0] sdram_data,		// SDRAM��������
			//��Ƶ����ӿ�
		input vpclk,		//��Ƶʱ��
		input vvsync,	//��Ƶ��ͬ���ź�
		input vhref,		//��Ƶ��ͬ���ź�
		input[7:0] vdb,	//��Ƶ��������
		output vxclk,	//��Ƶ����ʱ��
		output vscl,	//��������IICʱ���ź�
		inout vsda,	//��������IIC�����ź�
		input clk,
		input rst_n
		);


//---------------------------------------------
	//LCD��FIFO�Ľӿ�
wire[15:0] rdfifo_rddb;		//FIFO������������
wire rdfifo_rdreq;	//FIFO�������ź�
wire rdfifo_clr;		//FIFO��λ�źţ��ߵ�ƽ��Ч
	// SDRAM�ķ�װ�ӿ�
wire sdram_wr_req;			//ϵͳдSDRAM�����ź�
wire sdram_rd_req;			//ϵͳ��SDRAM�����ź�
wire sdram_wr_ack;			//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO�������Ч�ź�
wire sdram_rd_ack;			//ϵͳ��SDRAM��Ӧ�ź�,��ΪrdFIFO����д��Ч�ź�	
wire[8:0] sdwr_byte = 9'd160;	//ͻ��дSDRAM�ֽ�����1-256����
wire[8:0] sdrd_byte = 9'd160;	//ͻ����SDRAM�ֽ�����1-256����
wire[21:0] sys_wraddr;		//дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
wire[21:0] sys_rdaddr;		//��SDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
wire[15:0] sys_data_in;		//дSDRAMʱ�����ݴ���
wire[15:0] sys_data_out;	//sdram���ݶ�������FIFO������������
	//wrFIFO������ƽӿ�
wire[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
//wire[21:0] wrf_ain;		//sdram����д�뻺��FIFO�����ַ����
wire wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч
	//ϵͳ��������źŽӿ�
wire clk_25m;		//PLL���25MHzʱ��
wire clk_50m;	//PLL���50MHzʱ��
wire clk_100m;	//PLL���100MHzʱ��
wire sys_rst_n;	//ϵͳ��λ�źţ�����Ч

assign vxclk = clk_25m;		//25MHz�����OV7670

//------------------------------------------------
//����ϵͳ��λ�źź�PLL����ģ��
sys_ctrl		uut_sysctrl(
					.clk(clk),
					.rst_n(rst_n),
					.sys_rst_n(sys_rst_n),
					.clk_25m(clk_25m),
					.clk_50m(clk_50m),
					.clk_100m(clk_100m),
					.sdram_clk(sdram_clk)
					);

// //------------------------------------------------
// //��Ƶ�ɼ�����ģ��	
// video_input		uut_videoinput(
// 					.clk(clk_25m),
// 					.clk_100m(clk_100m),
// 					.rst_n(sys_rst_n),
// 					.vpclk(vpclk),
// 					.vvsync(vvsync),
// 					.vhref(vhref),
// 					.vdb(vdb),
// 					.vscl(vscl),
// 					.vsda(vsda),
// 					.wrf_din(wrf_din),
// 					.wrf_wrreq(wrf_wrreq)
// 					);		
reg [18:0]ADDR;
////Addresss generator
always@(posedge clk_25m,negedge rst_n)
begin
  if (!rst_n)
     ADDR<=19'd0;
  else if (VGA_HS==1'b0 && VGA_VS==1'b0)
     ADDR<=19'd0;
  else if (VGA_BLANK_N==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
	assign wrf_wrreq=1;
	img_pic inst_img_pic (.address(ADDR), .clock(clk_100m), .q(wrf_din));

//---------------------------------------------
// 	//LCD����ģ��
// lcd_driver	uut_lcd_driver(	
// 				.clk(clk_25m),	//25MHz
// 				.rst_n(sys_rst_n),
// 				.lcd_en(lcd_en),
// 				.lcd_clk(lcd_clk),
// 				.lcd_hsy(lcd_hsy),
// 				.lcd_vsy(lcd_vsy),
// 				.lcd_db_r(lcd_db_r),
// 				.lcd_db_g(lcd_db_g),
// 				.lcd_db_b(lcd_db_b),
// 				.rdfifo_rddb(rdfifo_rddb),//
// 				.rdfifo_rdreq(rdfifo_rdreq),//
// 				.rdfifo_clr(rdfifo_clr)//
// 			);
	
	assign VGA_CLK =clk_25m;
	vga_driver inst_vga_driver
		(
			.clk         (clk_25m),
			.rdfifo_rddb (rdfifo_rddb),
			.rst_n       (rst_n),
			.oBLANK_n    (VGA_BLANK_N),
			.oHS         (VGA_HS),
			.oVS         (VGA_VS),
			.b_data      (VGA_B),
			.g_data      (VGA_G),
			.r_data      (VGA_R)
		);

//------------------------------------------------
	//����SDRAM��װ����ģ��
sdram_top		uut_sdramtop(				// SDRAM
							.clk(clk_100m),
							.rst_n(sys_rst_n),
							.sdram_wr_req(sdram_wr_req),//
							.sdram_rd_req(sdram_rd_req),//
							.sdram_wr_ack(sdram_wr_ack),//
							.sdram_rd_ack(sdram_rd_ack),//	
							.sys_wraddr(sys_wraddr),//
							.sys_rdaddr(sys_rdaddr),//
							.sys_data_in(sys_data_in),//
							.sys_data_out(sys_data_out),//
							.sdwr_byte(sdwr_byte),//
							.sdrd_byte(sdrd_byte),//	
							.sdram_cke(sdram_cke),
							.sdram_cs_n(sdram_cs_n),
							.sdram_ras_n(sdram_ras_n),
							.sdram_cas_n(sdram_cas_n),
							.sdram_we_n(sdram_we_n),
							.sdram_ba(sdram_ba),
							.sdram_addr(sdram_addr),
							.sdram_data(sdram_data),
							.sdram_udqm(),
							.sdram_ldqm()
					);
	

//------------------------------------------------
	//��дSDRAM���ݻ���FIFOģ������	
sdfifo_ctrl			uut_sdffifoctrl(
						.clk_25m(clk_25m),
						.clk_100m(clk_100m),
						.rst_n(sys_rst_n),
						.wrf_clr(vvsync),						
						.wrf_din(wrf_din),
						.wrf_wrreq(wrf_wrreq),
						.sdram_wr_ack(sdram_wr_ack),//
						.sys_wraddr(sys_wraddr),//
						.sys_rdaddr(sys_rdaddr),//
						.sys_data_in(sys_data_in),//
						.sdram_wr_req(sdram_wr_req),//
						.sys_data_out(sys_data_out),//
						.sdram_rd_ack(sdram_rd_ack),//
						.sdram_rd_req(sdram_rd_req),//
						.rdfifo_rdreq(rdfifo_rdreq),//						
						.rdfifo_clr(rdfifo_clr),//
						.rdfifo_rddb(rdfifo_rddb)//
					);

endmodule
