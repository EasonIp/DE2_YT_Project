/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "altera_avalon_uart_regs.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"

char str1[7] = "error\n";
char str2[6] = "done\n";

void send_string(char *p, unsigned char len) {
	unsigned char i;
	for (i = 0; i < len; i++) {
		while (!(IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE) & 0x40))
			;
		IOWR_ALTERA_AVALON_UART_TXDATA(UART_0_BASE, p[i]);
	}
}

void delay_ns(unsigned int n) {
	volatile i;
//	unsigned int i;
	i = n;

	while (i--)
		;
}

int main() {

	int uart_status;
	unsigned char data;
	unsigned char i;

	while (1) {

		uart_status = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);
		if (uart_status & 0x80) {
			data = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
			if (data > 10)
				send_string(str1, 7);
			else {
				for (i = 0; i < data * 2; i++) {
					IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, 0x00);
					delay_ns(100000);
					IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, 0x0f);
					delay_ns(100000);
				}
				send_string(str2, 6);
			}
		}
	}

	return 0;
}
