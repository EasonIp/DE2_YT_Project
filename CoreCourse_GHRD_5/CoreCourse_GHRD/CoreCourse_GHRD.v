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
		input  wire        pio_w5500_intn,     //     pio_w5500_intn.export
		output wire        pio_w5500_reset,    //    pio_w5500_reset.export
		input  wire        pio_spi_miso,       //       pio_spi_miso.export
		output wire        pio_spi_mosi,       //       pio_spi_mosi.export
		output wire        pio_spi_sclk,       //       pio_spi_sclk.export
		output wire        pio_spi_csn         //        pio_spi_csn.export
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
		  .pio_w5500_intn_export     (pio_w5500_intn),     //     pio_w5500_intn.export
        .pio_w5500_reset_export    (pio_w5500_reset),    //    pio_w5500_reset.export
        .pio_spi_miso_export       (pio_spi_miso),       //       pio_spi_miso.export
        .pio_spi_mosi_export       (pio_spi_mosi),       //       pio_spi_mosi.export
        .pio_spi_sclk_export       (pio_spi_sclk),       //       pio_spi_sclk.export
        .pio_spi_csn_export        (pio_spi_csn),         //        pio_spi_csn.export
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
