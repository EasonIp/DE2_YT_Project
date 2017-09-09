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
		input  wire [1:0]  key  // pio_key.export
);

	wire nios_clk;
	wire nios_reset_n;
	
	pll pll(
		.areset(~reset_n),
		.inclk0(clk50m),
		.c0(nios_clk),
		.c1(sdram_clk),
		.locked(nios_reset_n)
	);

    mysystem u0 (
        .clk_clk        (nios_clk),        //     clk.clk
        .reset_reset_n  (nios_reset_n),  //   reset.reset_n
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
        .pio_key_export (key)  // pio_key.export
    );
	 
endmodule
