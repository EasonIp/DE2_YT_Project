
module key_led(

		input  wire        clk_50,      //   YT

		input  wire        reset_reset_n,  //   reset.reset_n
		output wire [12:0] sdram_addr,     //   sdram.addr
		output wire [1:0]  sdram_ba,       //        .ba
		output wire        sdram_cas_n,    //        .cas_n
		output wire        sdram_cke,      //        .cke
		// 
		output wire        sdram_clk,      //      YT   添加一个单独的时钟
		// 
		output wire        sdram_cs_n,     //        .cs_n
		inout  wire [31:0] sdram_dq,       //        .dq
		output wire [3:0]  sdram_dqm,      //        .dqm
		output wire        sdram_ras_n,    //        .ras_n
		output wire        sdram_we_n,     //        .we_n
		output wire [3:0]  pio_led_export, // pio_led.export
		input  wire [1:0]  pio_key_export  // pio_key.export
);

		wire nios_clk;
		wire nios_rest_n;

	mypll inst_mypll (
		.areset(~reset_reset_n), 
		.inclk0(clk_50), 
		.c0(nios_clk), 
		.c1(sdram_clk), 
		.locked(nios_rest_n)    //  YT  pll的输出没有稳定的时候是低电平，稳定之后是高电平
						// 与复位按键功能一致
		);


	YT_system inst_YT_system
		(
			.clk_clk        (nios_clk),
			.reset_reset_n  (nios_rest_n),
			.sdram_addr     (sdram_addr),
			.sdram_ba       (sdram_ba),
			.sdram_cas_n    (sdram_cas_n),
			.sdram_cke      (sdram_cke),
			.sdram_cs_n     (sdram_cs_n),
			.sdram_dq       (sdram_dq),
			.sdram_dqm      (sdram_dqm),
			.sdram_ras_n    (sdram_ras_n),
			.sdram_we_n     (sdram_we_n),
			.pio_led_export (pio_led_export),
			.pio_key_export (pio_key_export)
		);





    // YT_system u0 (
    //     .clk_clk        (<connected-to-clk_clk>),        //     clk.clk
    //     .reset_reset_n  (<connected-to-reset_reset_n>),  //   reset.reset_n
    //     .sdram_addr     (<connected-to-sdram_addr>),     //   sdram.addr
    //     .sdram_ba       (<connected-to-sdram_ba>),       //        .ba
    //     .sdram_cas_n    (<connected-to-sdram_cas_n>),    //        .cas_n
    //     .sdram_cke      (<connected-to-sdram_cke>),      //        .cke
    //     .sdram_cs_n     (<connected-to-sdram_cs_n>),     //        .cs_n
    //     .sdram_dq       (<connected-to-sdram_dq>),       //        .dq
    //     .sdram_dqm      (<connected-to-sdram_dqm>),      //        .dqm
    //     .sdram_ras_n    (<connected-to-sdram_ras_n>),    //        .ras_n
    //     .sdram_we_n     (<connected-to-sdram_we_n>),     //        .we_n
    //     .pio_led_export (<connected-to-pio_led_export>), // pio_led.export
    //     .pio_key_export (<connected-to-pio_key_export>)  // pio_key.export
    // );

endmodule // key_led