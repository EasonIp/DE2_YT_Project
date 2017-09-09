

module top_vga_disp_pic(
//=======================================================
//  PARAMETER declarations  PORT declarations
//=======================================================
//////////// Sma //////////
input		          		SMA_CLKIN,
output		          	SMA_CLKOUT,

//////////// LED //////////
output		   [8:0]		LEDG,
output	     [17:0]	   LEDR,

//////////// KEY //////////
input		      [3:0]		KEY,

//////////// SW //////////
input		     [17:0]		SW,
//////////// SEG7 //////////
output		   [6:0]		HEX0,
output		   [6:0]		HEX1,
output		   [6:0]		HEX2,
output		   [6:0]		HEX3,
output		   [6:0]		HEX4,
output		   [6:0]		HEX5,
output		   [6:0]		HEX6,
output		   [6:0]		HEX7,

//////////// VGA //////////
output		   [7:0]		VGA_B,
output		        		VGA_BLANK_N,
output		        		VGA_CLK,
output		   [7:0]		VGA_G,
output	          		VGA_HS,
output	      [7:0]		VGA_R,
output	         		VGA_SYNC_N,
output	          		VGA_VS,

//////////// CLOCK //////////
input		          		CLOCK_50,
input		          		CLOCK2_50,
input		          		CLOCK3_50,
input		          		ENETCLK_25
);
///////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================
//	For Audio CODEC

wire [31:0]	mSEG7_DIG;
reg  [31:0]	Cont;
wire		   VGA_CTRL_CLK;
wire  [9:0]	mVGA_R;
wire  [9:0]	mVGA_G;
wire  [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;
wire		   DLY_RST;

//	For VGA Controller
wire			mVGA_CLK;
// wire	[9:0]	mRed;
// wire	[9:0]	mGreen;
// wire	[9:0]	mBlue;
// wire			VGA_Read;	//	VGA data request

// wire  [9:0] recon_VGA_R;
// wire  [9:0] recon_VGA_G;
// wire  [9:0] recon_VGA_B;

always@(posedge CLOCK_50 or negedge KEY[0])
    begin
        if(!KEY[0])
			 Cont	<=	0;
        else
			 Cont	<=	Cont+1;
    end


assign	mSEG7_DIG	=	{	Cont[27:24],Cont[27:24],Cont[27:24],Cont[27:24],
							Cont[27:24],Cont[27:24],Cont[27:24],Cont[27:24]	};
assign	LEDR		=	{	Cont[25:23],Cont[25:23],Cont[25:23],
							Cont[25:23],Cont[25:23],Cont[25:23]	};
assign	LEDG		=	{	Cont[25:23],Cont[25:23],Cont[25:23]	};


//	7 segment LUT
SEG7_LUT_8 			u0	(	.oSEG0(HEX0),
							.oSEG1(HEX1),
							.oSEG2(HEX2),
							.oSEG3(HEX3),
							.oSEG4(HEX4),
							.oSEG5(HEX5),
							.oSEG6(HEX6),
							.oSEG7(HEX7),
							.iDIG(mSEG7_DIG) );

//	Reset Delay Timer
Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);


//in source-sysnhtounous compensation mode   creat an "arest" input to async reset the PLL;
//c0=25M, 18,25(-9-度)
// VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK2_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(mVGA_CLK)	);
VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK2_50),.c0(VGA_CTRL_CLK),.c1(),.c2()	);

//	VGA Controller
//assign VGA_BLANK_N = !cDEN;
assign VGA_CLK = VGA_CTRL_CLK;
vga_controller vga_ins(.iRST_n(DLY_RST),
                      .iVGA_CLK(VGA_CTRL_CLK),
                      .oBLANK_n(VGA_BLANK_N),
                      .oHS(VGA_HS),
                      .oVS(VGA_VS),
                      .b_data(VGA_B),
                      .g_data(VGA_G),
                      .r_data(VGA_R));
endmodule



//  sample


// module top_vga_disp_pic(
// //=======================================================
// //  PARAMETER declarations  PORT declarations
// //=======================================================
// //////////// Sma //////////
// input		          		SMA_CLKIN,
// output		          	SMA_CLKOUT,

// //////////// LED //////////
// output		   [8:0]		LEDG,
// output	     [17:0]	   LEDR,

// //////////// KEY //////////
// input		      [3:0]		KEY,

// //////////// SW //////////
// input		     [17:0]		SW,
// //////////// SEG7 //////////
// output		   [6:0]		HEX0,
// output		   [6:0]		HEX1,
// output		   [6:0]		HEX2,
// output		   [6:0]		HEX3,
// output		   [6:0]		HEX4,
// output		   [6:0]		HEX5,
// output		   [6:0]		HEX6,
// output		   [6:0]		HEX7,

// //////////// LCD //////////
// output		        		LCD_BLON,
// inout		      [7:0]		LCD_DATA,
// output		          	LCD_EN,
// output		          	LCD_ON,
// output		          	LCD_RS,
// output		        		LCD_RW,

// //////////// RS232 //////////
// output		        		UART_CTS,
// input		          		UART_RTS,
// input		          		UART_RXD,
// output		          	UART_TXD,

// //////////// PS2 //////////
// inout		          		PS2_CLK,
// inout		          		PS2_DAT,
// inout		          		PS2_CLK2,
// inout		          		PS2_DAT2,

// //////////// SDCARD //////////
// output		        		SD_CLK,
// inout		          		SD_CMD,
// inout		      [3:0]		SD_DAT,
// input		          		SD_WP_N,

// //////////// VGA //////////
// output		   [7:0]		VGA_B,
// output		        		VGA_BLANK_N,
// output		        		VGA_CLK,
// output		   [7:0]		VGA_G,
// output	          		VGA_HS,
// output	      [7:0]		VGA_R,
// output	         		VGA_SYNC_N,
// output	          		VGA_VS,

// //////////// Audio //////////
// input		          		AUD_ADCDAT,
// inout		          		AUD_ADCLRCK,
// inout		          		AUD_BCLK,
// output		        		AUD_DACDAT,
// inout		          		AUD_DACLRCK,
// output		        		AUD_XCK,

// //////////// I2C for EEPROM //////////
// output		        		EEP_I2C_SCLK,
// inout		          		EEP_I2C_SDAT,

// //////////// I2C for Audio and Tv-Decode //////////
// output		        		I2C_SCLK,
// inout		          		I2C_SDAT,

// //////////// Ethernet 0 //////////
// output		        		ENET0_GTX_CLK,
// input		          		ENET0_INT_N,
// output		        		ENET0_MDC,
// input		          		ENET0_MDIO,
// output		        		ENET0_RST_N,
// input		          		ENET0_RX_CLK,
// input		          		ENET0_RX_COL,
// input		          		ENET0_RX_CRS,
// input		      [3:0]		ENET0_RX_DATA,
// input		          		ENET0_RX_DV,
// input		          		ENET0_RX_ER,
// input		          		ENET0_TX_CLK,
// output		   [3:0]		ENET0_TX_DATA,
// output		        		ENET0_TX_EN,
// output		        		ENET0_TX_ER,
// input		          		ENET0_LINK100,

// //////////// Ethernet 1 //////////
// output		        		ENET1_GTX_CLK,
// input		          		ENET1_INT_N,
// output		        		ENET1_MDC,
// input		          		ENET1_MDIO,
// output		        		ENET1_RST_N,
// input		          		ENET1_RX_CLK,
// input		          		ENET1_RX_COL,
// input		          		ENET1_RX_CRS,
// input		      [3:0]		ENET1_RX_DATA,
// input		          		ENET1_RX_DV,
// input		          		ENET1_RX_ER,
// input		          		ENET1_TX_CLK,
// output		   [3:0]		ENET1_TX_DATA,
// output		        		ENET1_TX_EN,
// output		        		ENET1_TX_ER,
// input		          		ENET1_LINK100,

// //////////// TV Decoder 1 //////////
// input		          		TD_CLK27,
// input		      [7:0]		TD_DATA,
// input		          		TD_HS,
// output		        		TD_RESET_N,
// input		          		TD_VS,


// //////////// USB OTG controller //////////
// inout         [15:0]    OTG_DATA,
// output         [1:0]    OTG_ADDR,
// output                  OTG_CS_N,
// output                  OTG_WR_N,
// output                  OTG_RD_N,
// input          [1:0]    OTG_INT,
// output                  OTG_RST_N,
// input          [1:0]    OTG_DREQ,
// output         [1:0]    OTG_DACK_N,
// inout                   OTG_FSPEED,
// inout                   OTG_LSPEED,

// //////////// IR Receiver //////////
// input		          		IRDA_RXD,

// //////////// SDRAM //////////
// output		  [12:0]		DRAM_ADDR,
// output	      [1:0]		DRAM_BA,
// output		        		DRAM_CAS_N,
// output		        		DRAM_CKE,
// output		        		DRAM_CLK,
// output		        		DRAM_CS_N,
// inout		     [31:0]		DRAM_DQ,
// output		   [3:0]		DRAM_DQM,
// output		        		DRAM_RAS_N,
// output		        		DRAM_WE_N,

// //////////// SRAM //////////
// output		  [19:0]		SRAM_ADDR,
// output		        		SRAM_CE_N,
// inout		     [15:0]		SRAM_DQ,
// output		        		SRAM_LB_N,
// output		        		SRAM_OE_N,
// output		        		SRAM_UB_N,
// output		        		SRAM_WE_N,

// //////////// Flash //////////
// output	     [22:0]		FL_ADDR,
// output		        		FL_CE_N,
// inout		      [7:0]		FL_DQ,
// output		        		FL_OE_N,
// output		        		FL_RST_N,
// input		          		FL_RY,
// output		        		FL_WE_N,
// output		        		FL_WP_N,

// //////////// GPIO //////////
// inout		     [35:0]		GPIO,

// //////////// HSMC (LVDS) //////////

// //input		          		HSMC_CLKIN_N1,
// //input		          		HSMC_CLKIN_N2,
// input		          		HSMC_CLKIN_P1,
// input		          		HSMC_CLKIN_P2,
// input		          		HSMC_CLKIN0,
// //output		          		HSMC_CLKOUT_N1,
// //output		          		HSMC_CLKOUT_N2,
// output		          	HSMC_CLKOUT_P1,
// output		          	HSMC_CLKOUT_P2,
// output		          	HSMC_CLKOUT0,
// inout		      [3:0]		HSMC_D,
// //input		    [16:0]		HSMC_RX_D_N,
// input		     [16:0]		HSMC_RX_D_P,
// //output		    [16:0]		HSMC_TX_D_N,
// output	     [16:0]		HSMC_TX_D_P,

// //////// EXTEND IO //////////
// inout		      [6:0]		EX_IO,
// //////////// CLOCK //////////
// input		          		CLOCK_50,
// input		          		CLOCK2_50,
// input		          		CLOCK3_50,
// input		          		ENETCLK_25
// );
// ///////////////////////////////////////////////////////////////////
// //=============================================================================
// // REG/WIRE declarations
// //=============================================================================


// wire	CPU_CLK;
// wire	CPU_RESET;

// //	For Audio CODEC
// wire		   AUD_CTRL_CLK;	//	For Audio Controller

// wire [31:0]	mSEG7_DIG;
// reg  [31:0]	Cont;
// wire		   VGA_CTRL_CLK;
// wire  [9:0]	mVGA_R;
// wire  [9:0]	mVGA_G;
// wire  [9:0]	mVGA_B;
// wire [19:0]	mVGA_ADDR;
// wire		   DLY_RST;

// //	For VGA Controller
// wire			mVGA_CLK;
// wire	[9:0]	mRed;
// wire	[9:0]	mGreen;
// wire	[9:0]	mBlue;
// wire			VGA_Read;	//	VGA data request

// wire  [9:0] recon_VGA_R;
// wire  [9:0] recon_VGA_G;
// wire  [9:0] recon_VGA_B;

// //	For Down Sample
// wire	[3:0]	Remain;
// wire	[9:0]	Quotient;

// wire			mDVAL;


// // DEFAULT LCD       //

// //wire      LCD_ON_1  ;
// //wire      LCD_BLON_1;
// wire [7:0] LCD_D_1;
// wire       LCD_RW_1;
// wire       LCD_EN_1;
// wire       LCD_RS_1;

// //=============================================================================
// // Structural coding
// //=============================================================================
// // initial //
// //
// assign LCD_DATA = LCD_D_1;
// assign LCD_RW   = LCD_RW_1;
// assign LCD_EN   = LCD_EN_1;
// assign LCD_RS   = LCD_RS_1; 
// assign LCD_ON   = 1'b1;
// assign LCD_BLON = 1'b0; //not supported;


// assign DRAM_DQ 			= 32'hzzzzzzzz;
 
    		         
// assign AUD_ADCLRCK    	= 1'bz;     					
    					
// assign AUD_DACLRCK 		= 1'bz;     					
// assign AUD_DACDAT 		= 1'bz;     					
// assign AUD_BCLK 		= 1'bz;     						
// assign AUD_XCK 		= 1'bz;     						
   						
// assign I2C_SDAT 		= 1'bz;     						
// assign I2C_SCLK		= 1'bz;
// assign EEP_I2C_SDAT 		= 1'bz;     						
// assign EEP_I2C_SCLK		= 1'bz;      						
// assign SD_DAT 			= 4'bz;     							    						
// assign SD_CMD 			= 1'bz;     						
// assign SD_CLK 			= 1'bz;     						
// assign OTG_DATA   		= 16'hzzzz;	

// assign FL_DQ         = 8'hzz;				



// always@(posedge CLOCK_50 or negedge KEY[0])
//     begin
//         if(!KEY[0])
// 			 Cont	<=	0;
//         else
// 			 Cont	<=	Cont+1;
//     end

// //	All inout port turn to tri-state
// assign	SD_DAT		=	4'bz;
// assign	GPIO   =	36'hzzzzzzzz;

// //	Disable USB speed select
// assign	OTG_FSPEED	=	1'bz;
// assign	OTG_LSPEED	=	1'bz;


// //	Enable TV Decoder
// assign	TD_RESET_N	=	KEY[0];

// //	All inout port turn to tri-state
// assign	DRAM_DQ		=	32'hzzzzzzzz;
// assign	SRAM_DQ		=	16'hzzzz;
// assign	SD_DAT		=	4'bz;

// assign	AUD_XCK	    =	AUD_CTRL_CLK;
// assign	AUD_ADCLRCK	=	AUD_DACLRCK;

// assign	mSEG7_DIG	=	{	Cont[27:24],Cont[27:24],Cont[27:24],Cont[27:24],
// 							Cont[27:24],Cont[27:24],Cont[27:24],Cont[27:24]	};
// assign	LEDR		=	{	Cont[25:23],Cont[25:23],Cont[25:23],
// 							Cont[25:23],Cont[25:23],Cont[25:23]	};
// assign	LEDG		=	{	Cont[25:23],Cont[25:23],Cont[25:23]	};


// //	7 segment LUT
// SEG7_LUT_8 			u0	(	.oSEG0(HEX0),
// 							.oSEG1(HEX1),
// 							.oSEG2(HEX2),
// 							.oSEG3(HEX3),
// 							.oSEG4(HEX4),
// 							.oSEG5(HEX5),
// 							.oSEG6(HEX6),
// 							.oSEG7(HEX7),
// 							.iDIG(mSEG7_DIG) );

// //	Reset Delay Timer
// Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);


// //in source-sysnhtounous compensation mode   creat an "arest" input to async reset the PLL;
// //c0=25M, 18,25
// VGA_Audio_PLL 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK2_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(mVGA_CLK)	);

// //	VGA Controller
// //assign VGA_BLANK_N = !cDEN;
// assign VGA_CLK = VGA_CTRL_CLK;
// vga_controller vga_ins(.iRST_n(DLY_RST),
//                       .iVGA_CLK(VGA_CTRL_CLK),
//                       .oBLANK_n(VGA_BLANK_N),
//                       .oHS(VGA_HS),
//                       .oVS(VGA_VS),
//                       .b_data(VGA_B),
//                       .g_data(VGA_G),
//                       .r_data(VGA_R));
					
// //	Audio CODEC and video decoder setting
// I2C_AV_Config 		u3	(	//	Host Side
// 							.iCLK(CLOCK_50),
// 							.iRST_N(KEY[0]),
// 							//	I2C Side
// 							.I2C_SCLK(I2C_SCLK),
// 							.I2C_SDAT(I2C_SDAT)	);

// AUDIO_DAC 			u4	(	//	Audio Side
// 							.oAUD_BCK(AUD_BCLK),
// 							.oAUD_DATA(AUD_DACDAT),
// 							.oAUD_LRCK(AUD_DACLRCK),
// 							//	Control Signals
// 							.iSrc_Select(SW[17]),
// 				            .iCLK_18_4(AUD_CTRL_CLK),
// 							.iRST_N(DLY_RST)	);


// LCD_TEST 			u5	(	//	Host Side
// 							.iCLK(CLOCK_50),
// 							.iRST_N(DLY_RST),
// 							//	LCD Side
// 							.LCD_DATA(LCD_D_1),
// 							.LCD_RW(LCD_RW_1),
// 							.LCD_EN(LCD_EN_1),
// 							.LCD_RS(LCD_RS_1)	);


// endmodule
