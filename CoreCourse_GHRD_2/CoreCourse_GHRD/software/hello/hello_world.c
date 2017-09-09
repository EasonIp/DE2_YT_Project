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
#include "unistd.h"
#include "io.h"
#include "sys/alt_irq.h"

int irdata,iraddr;
char get_flag;

void delay_us(int n)
{
	int i;
	i = n;
	while(i)
	{
		i--;
	}
}


alt_isr_func ir_decode_isr(void* context, alt_u32 id){

    char *context_t;

    context_t = context;
    /* ���жϲ���Ĵ��� */
    IOWR_16DIRECT(IR_DECODE_BASE, 2 * 2, 0);

	irdata = IORD_16DIRECT(IR_DECODE_BASE, 0);
	iraddr = IORD_16DIRECT(IR_DECODE_BASE, 2);
	get_flag = 1;
    return 0;
}


void ir_decode_init()
{
	char *p;
	alt_ic_isr_register(
		IR_DECODE_IRQ_INTERRUPT_CONTROLLER_ID,
		IR_DECODE_IRQ,
		ir_decode_isr,
		p,
		0);
}

int main()
{

	printf("Hello from Nios II!\n");
	ir_decode_init();
	while(1)
	{
		if(get_flag)
		{
			printf("irdata is %x\n",irdata);
			printf("iraddr is %x\n",iraddr);
			get_flag = 0;
		}
	}

  return 0;
}
