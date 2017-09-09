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
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include "unistd.h"  //  usleep  标准的时间延迟；在

void delay_us(int n)
{
	int i;
	i = n;
	while(i)
	{
		i--;
	}
}

int main()
{
	printf("Hello from Nios II!\n");
	while(1)
	{
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, 5);    //地址在system.h中找到
		//delay_us(5000000);
		usleep(500000);
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, 0xa);
		//delay_us(5000000);
		usleep(500000);
	}

  return 0;
}
