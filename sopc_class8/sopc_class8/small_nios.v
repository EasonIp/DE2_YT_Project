module small_nios(

	input clk,
	input reset_n,
	input uart_0_rxd,
	
	output uart_0_txd,
	output [3:0]pio_led
);

    mysystem u0 (
        .clk_clk        (clk),        //     clk.clk
        .reset_reset_n  (reset_n),  //   reset.reset_n
        .uart_0_rxd     (uart_0_rxd),     //  uart_0.rxd
        .uart_0_txd     (uart_0_txd),     //        .txd
        .pio_led_export (pio_led)  // pio_led.export
    );

endmodule 
