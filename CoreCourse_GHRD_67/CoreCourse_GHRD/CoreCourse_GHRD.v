module CoreCourse_GHRD(
		input  wire        clk50m,        //     clk.clk
		input  wire        reset_n,  //   reset.reset_n
		output wire [11:0] sdram_addr,     //   sdram.addr
		output wire [1:0]  sdram_ba,       //        .ba
		output wire        sdram_cas_n,    //        .cas_n
		output wire        sdram_cke,      //        .cke
		output wire        sdram_clk,      //        .clk
		output wire        sdram_cs_n,     //        .cs_n
		inout  wire [15:0] sdram_dq,       //        .dq
		output wire [1:0]  sdram_dqm,      //        .dqm
		output wire        sdram_ras_n,    //        .ras_n
		output wire        sdram_we_n,     //        .we_n
		input  wire        uart_0_rxd,     //  uart_0.rxd
		output wire        uart_0_txd,     //        .txd
		output wire [3:0]  led, // pio_led.export
		input  wire [1:0]  key,  // pio_key.export
		input iIR,
		output wire	[7:0] hex_sel,//数码管位选（选择当前要显示的数码管）
		output wire [6:0] hex_seg,//数码管段选（当前要显示的内容）
		output wire        epcs_dclk,                 //               epcs.dclk
		output wire        epcs_sce,                  //                   .sce
		output wire        epcs_sdo,                  //                   .sdo
		input  wire        epcs_data0,                 //                   .data0
		output wire [15:0] TFT_RGB,          //           tft_sram.TFT_RGB
		output wire        TFT_HS,           //                   .TFT_HS
		output wire        TFT_VS,           //                   .TFT_VS
		output wire        TFT_CLK,          //                   .TFT_CLK
		output wire        TFT_DE,           //                   .TFT_DE
		output wire        TFT_PWM,          //                   .TFT_PWM
		inout  wire [15:0] SRAM_DQ,          //                   .SRAM_DQ
		output wire [17:0] SRAM_ADDR,        //                   .SRAM_ADDR
		output wire [1:0]  SRAM_BE,          //                   .SRAM_BE
		output wire        SRAM_NCE,         //                   .SRAM_NCE
		output wire        SRAM_NWE,         //                   .SRAM_NWE
		output wire        SRAM_NOE          //                   .SRAM_NOE
);

	wire nios_reset_n;
	wire [31:0]seg7_data;
	wire seg7_en;

	
    mysystem u0 (
        .clk_clk        (clk50m),        //     clk.clk
        .reset_reset_n  (nios_reset_n),  //   reset.reset_n
		  .altpll_0_sdram_clk (sdram_clk),        //     altpll_0_sdram.clk
        .sdram_addr     (sdram_addr),     //   sdram.addr
        .sdram_ba       (sdram_ba),       //        .ba
        .sdram_cas_n    (sdram_cas_n),    //        .cas_n
        .sdram_cke      (sdram_cke),      //        .cke
        .sdram_cs_n     (sdram_cs_n),     //        .cs_n
        .sdram_dq       (sdram_dq),       //        .dq
        .sdram_dqm      (sdram_dqm),      //        .dqm
        .sdram_ras_n    (sdram_ras_n),    //        .ras_n
        .sdram_we_n     (sdram_we_n),     //        .we_n
        .uart_0_rxd     (uart_0_rxd),     //  uart_0.rxd
        .uart_0_txd     (uart_0_txd),     //        .txd
        .pio_led_export (led), // pio_led.export
        .pio_key_export (key),  // pio_key.export
		  .ir_decode_export          (iIR),          //          ir_decode.export
        .altpll_0_areset_export    (~reset_n),    //    altpll_0_areset.export
        .altpll_0_locked_export    (nios_reset_n),    //    altpll_0_locked.export
        .altpll_0_phasedone_export (),  // altpll_0_phasedone.export
		  .pio_seg7_export           (seg7_data),           //           pio_seg7.export
        .pio_seg7_en_export        (seg7_en),         //        pio_seg7_en.export
		  .epcs_dclk                 (epcs_dclk),                 //               epcs.dclk
        .epcs_sce                  (epcs_sce),                  //                   .sce
        .epcs_sdo                  (epcs_sdo),                  //                   .sdo
        .epcs_data0                (epcs_data0),                 //                   .data0
		  .tft_sram_TFT_RGB          (TFT_RGB),          //           tft_sram.TFT_RGB
        .tft_sram_TFT_HS           (TFT_HS),           //                   .TFT_HS
        .tft_sram_TFT_VS           (TFT_VS),           //                   .TFT_VS
        .tft_sram_TFT_CLK          (TFT_CLK),          //                   .TFT_CLK
        .tft_sram_TFT_DE           (TFT_DE),           //                   .TFT_DE
        .tft_sram_TFT_PWM          (TFT_PWM),          //                   .TFT_PWM
        .tft_sram_SRAM_DQ          (SRAM_DQ),          //                   .SRAM_DQ
        .tft_sram_SRAM_ADDR        (SRAM_ADDR),        //                   .SRAM_ADDR
        .tft_sram_SRAM_BE          (SRAM_BE),          //                   .SRAM_BE
        .tft_sram_SRAM_NCE         (SRAM_NCE),         //                   .SRAM_NCE
        .tft_sram_SRAM_NWE         (SRAM_NWE),         //                   .SRAM_NWE
        .tft_sram_SRAM_NOE         (SRAM_NOE)          //                   .SRAM_NOE
    );
	 
	 HXE8 HXE8(
		 .Clk(clk50m),
		 .Rst_n(reset_n),
		 .En(seg7_en),
		 .disp_data(seg7_data),
		 .sel(hex_sel),
		 .seg(hex_seg)
	 );
	 
endmodule
