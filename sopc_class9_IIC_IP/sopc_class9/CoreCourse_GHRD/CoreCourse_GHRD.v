module CoreCourse_GHRD(
		input  wire        clk,                           //                        clk.clk
		input  wire        reset_n,                     //                      reset.reset_n
		output wire [11:0] sdram_addr,                        //                      sdram.addr
		output wire [1:0]  sdram_ba,                          //                           .ba
		output wire        sdram_cas_n,                       //                           .cas_n
		output wire        sdram_cke,                         //                           .cke
		output wire        sdram_cs_n,                        //                           .cs_n
		inout  wire [15:0] sdram_dq,                          //                           .dq
		output wire [1:0]  sdram_dqm,                         //                           .dqm
		output wire        sdram_ras_n,                       //                           .ras_n
		output wire        sdram_we_n,                        //                           .we_n
		output wire        sdram_clk,                     //                  sdram_clk.clk
		input  wire        uart_0_rxd,                        //                     uart_0.rxd
		output wire        uart_0_txd,                        //                           .txd
		inout  wire        iic_0_scl,               //                   oc_iic_0.scl_pad_io
		inout  wire        iic_0_sda               //                           .sda_pad_io
);

    mysystem u0 (
        .clk_clk                           (clk),                           //                        clk.clk
        .reset_reset_n                     (reset_n),                     //                      reset.reset_n
        .sdram_addr                        (sdram_addr),                        //                      sdram.addr
        .sdram_ba                          (sdram_ba),                          //                           .ba
        .sdram_cas_n                       (sdram_cas_n),                       //                           .cas_n
        .sdram_cke                         (sdram_cke),                         //                           .cke
        .sdram_cs_n                        (sdram_cs_n),                        //                           .cs_n
        .sdram_dq                          (sdram_dq),                          //                           .dq
        .sdram_dqm                         (sdram_dqm),                         //                           .dqm
        .sdram_ras_n                       (sdram_ras_n),                       //                           .ras_n
        .sdram_we_n                        (sdram_we_n),                        //                           .we_n
        .sdram_clk_clk                     (sdram_clk),                     //                  sdram_clk.clk
        .uart_0_rxd                        (uart_0_rxd),                        //                     uart_0.rxd
        .uart_0_txd                        (uart_0_txd),                        //                           .txd
        .oc_iic_0_scl_pad_io               (iic_0_scl),               //                   oc_iic_0.scl_pad_io
        .oc_iic_0_sda_pad_io               (iic_0_sda),               //                           .sda_pad_io
        .altpll_0_areset_conduit_export    (),    //    altpll_0_areset_conduit.export
        .altpll_0_locked_conduit_export    (),    //    altpll_0_locked_conduit.export
        .altpll_0_phasedone_conduit_export ()  // altpll_0_phasedone_conduit.export
    );
	 
endmodule
