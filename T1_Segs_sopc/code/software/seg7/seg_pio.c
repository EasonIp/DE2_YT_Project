/*
 * seg_pio.c
 *
 *  Created on: 2017-8-31
 *      Author: EasonIp
 */

#include <stdio.h>
#include "system.h"
#include "sys/unistd.h"
#include <io.h>

static unsigned char azmap[] = {0x40,0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x00,0x10,0x08,0x03,0x46,0x21,0x06,0x0E};

int main()
{
	printf("fpga\n");
	unsigned char i=0;
	while(1)
	{
		for(i=0;i<16;i++)
		{
			IOWR(SEG7_BASE,0,azmap[i]);
			usleep(500*1000);
		}
	}
	return 0;
}
