/*
 * led.c
 *
 *  Created on: 2017-8-31
 *      Author: EasonIp
 */

#include "system.h"
#include "altera_avalon_pio_regs.h"
#include <stdio.h>
void delay(void);
int alt_main(void)
{
	unsigned int led_data;
	unsigned int led_code;
	printf("fpga\n");
	while(1)
	{
		for(led_data=0;led_data<18;led_data++)
		{
			led_code=0x01<<led_data;
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_18_BASE,led_code);
			delay();
		}
	}
	return 0;
}

void delay(void)
{
	unsigned int i;
	i=1000000;
	while(i>0)
	{i--;}
}
