/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2' in SOPC Builder design 'mysystem'
 * SOPC Builder design path: G:/XiaoMeige_fpga_System/class/sopc_class/CoreCourse_GHRD/mysystem.sopcinfo
 *
 * Generated: Sun Aug 14 21:04:12 CST 2016
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x1001820
#define ALT_CPU_CPU_FREQ 100000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x19
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 2048
#define ALT_CPU_EXCEPTION_ADDR 0x20
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 100000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0x19
#define ALT_CPU_NAME "nios2"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_RESET_ADDR 0x1001000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x1001820
#define NIOS2_CPU_FREQ 100000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x19
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 2048
#define NIOS2_EXCEPTION_ADDR 0x20
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0x19
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_RESET_ADDR 0x1001000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_EPCS_FLASH_CONTROLLER
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_TIMER
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2_QSYS
#define __ALTPLL
#define __IR_DECODE


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/uart_0"
#define ALT_STDERR_BASE 0x1002080
#define ALT_STDERR_DEV uart_0
#define ALT_STDERR_IS_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_uart"
#define ALT_STDIN "/dev/uart_0"
#define ALT_STDIN_BASE 0x1002080
#define ALT_STDIN_DEV uart_0
#define ALT_STDIN_IS_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_uart"
#define ALT_STDOUT "/dev/uart_0"
#define ALT_STDOUT_BASE 0x1002080
#define ALT_STDOUT_DEV uart_0
#define ALT_STDOUT_IS_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_uart"
#define ALT_SYSTEM_NAME "mysystem"


/*
 * altpll_0 configuration
 *
 */

#define ALTPLL_0_BASE 0x10020c0
#define ALTPLL_0_IRQ -1
#define ALTPLL_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ALTPLL_0_NAME "/dev/altpll_0"
#define ALTPLL_0_SPAN 16
#define ALTPLL_0_TYPE "altpll"
#define ALT_MODULE_CLASS_altpll_0 altpll


/*
 * epcs configuration
 *
 */

#define ALT_MODULE_CLASS_epcs altera_avalon_epcs_flash_controller
#define EPCS_BASE 0x1001000
#define EPCS_IRQ 3
#define EPCS_IRQ_INTERRUPT_CONTROLLER_ID 0
#define EPCS_NAME "/dev/epcs"
#define EPCS_REGISTER_OFFSET 1024
#define EPCS_SPAN 2048
#define EPCS_TYPE "altera_avalon_epcs_flash_controller"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * ir_decode configuration
 *
 */

#define ALT_MODULE_CLASS_ir_decode ir_decode
#define IR_DECODE_BASE 0x10020e0
#define IR_DECODE_IRQ 2
#define IR_DECODE_IRQ_INTERRUPT_CONTROLLER_ID 0
#define IR_DECODE_NAME "/dev/ir_decode"
#define IR_DECODE_SPAN 8
#define IR_DECODE_TYPE "ir_decode"


/*
 * pio_key configuration
 *
 */

#define ALT_MODULE_CLASS_pio_key altera_avalon_pio
#define PIO_KEY_BASE 0x10020d0
#define PIO_KEY_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_KEY_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_KEY_CAPTURE 1
#define PIO_KEY_DATA_WIDTH 2
#define PIO_KEY_DO_TEST_BENCH_WIRING 0
#define PIO_KEY_DRIVEN_SIM_VALUE 0
#define PIO_KEY_EDGE_TYPE "FALLING"
#define PIO_KEY_FREQ 100000000
#define PIO_KEY_HAS_IN 1
#define PIO_KEY_HAS_OUT 0
#define PIO_KEY_HAS_TRI 0
#define PIO_KEY_IRQ 5
#define PIO_KEY_IRQ_INTERRUPT_CONTROLLER_ID 0
#define PIO_KEY_IRQ_TYPE "EDGE"
#define PIO_KEY_NAME "/dev/pio_key"
#define PIO_KEY_RESET_VALUE 0
#define PIO_KEY_SPAN 16
#define PIO_KEY_TYPE "altera_avalon_pio"


/*
 * pio_led configuration
 *
 */

#define ALT_MODULE_CLASS_pio_led altera_avalon_pio
#define PIO_LED_BASE 0x1002060
#define PIO_LED_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_LED_BIT_MODIFYING_OUTPUT_REGISTER 1
#define PIO_LED_CAPTURE 0
#define PIO_LED_DATA_WIDTH 4
#define PIO_LED_DO_TEST_BENCH_WIRING 0
#define PIO_LED_DRIVEN_SIM_VALUE 0
#define PIO_LED_EDGE_TYPE "NONE"
#define PIO_LED_FREQ 100000000
#define PIO_LED_HAS_IN 0
#define PIO_LED_HAS_OUT 1
#define PIO_LED_HAS_TRI 0
#define PIO_LED_IRQ -1
#define PIO_LED_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_LED_IRQ_TYPE "NONE"
#define PIO_LED_NAME "/dev/pio_led"
#define PIO_LED_RESET_VALUE 15
#define PIO_LED_SPAN 32
#define PIO_LED_TYPE "altera_avalon_pio"


/*
 * pio_seg7 configuration
 *
 */

#define ALT_MODULE_CLASS_pio_seg7 altera_avalon_pio
#define PIO_SEG7_BASE 0x10020a0
#define PIO_SEG7_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_SEG7_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_SEG7_CAPTURE 0
#define PIO_SEG7_DATA_WIDTH 32
#define PIO_SEG7_DO_TEST_BENCH_WIRING 0
#define PIO_SEG7_DRIVEN_SIM_VALUE 0
#define PIO_SEG7_EDGE_TYPE "NONE"
#define PIO_SEG7_FREQ 100000000
#define PIO_SEG7_HAS_IN 0
#define PIO_SEG7_HAS_OUT 1
#define PIO_SEG7_HAS_TRI 0
#define PIO_SEG7_IRQ -1
#define PIO_SEG7_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_SEG7_IRQ_TYPE "NONE"
#define PIO_SEG7_NAME "/dev/pio_seg7"
#define PIO_SEG7_RESET_VALUE -1
#define PIO_SEG7_SPAN 16
#define PIO_SEG7_TYPE "altera_avalon_pio"


/*
 * pio_seg7_en configuration
 *
 */

#define ALT_MODULE_CLASS_pio_seg7_en altera_avalon_pio
#define PIO_SEG7_EN_BASE 0x10020b0
#define PIO_SEG7_EN_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_SEG7_EN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_SEG7_EN_CAPTURE 0
#define PIO_SEG7_EN_DATA_WIDTH 1
#define PIO_SEG7_EN_DO_TEST_BENCH_WIRING 0
#define PIO_SEG7_EN_DRIVEN_SIM_VALUE 0
#define PIO_SEG7_EN_EDGE_TYPE "NONE"
#define PIO_SEG7_EN_FREQ 100000000
#define PIO_SEG7_EN_HAS_IN 0
#define PIO_SEG7_EN_HAS_OUT 1
#define PIO_SEG7_EN_HAS_TRI 0
#define PIO_SEG7_EN_IRQ -1
#define PIO_SEG7_EN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_SEG7_EN_IRQ_TYPE "NONE"
#define PIO_SEG7_EN_NAME "/dev/pio_seg7_en"
#define PIO_SEG7_EN_RESET_VALUE 0
#define PIO_SEG7_EN_SPAN 16
#define PIO_SEG7_EN_TYPE "altera_avalon_pio"


/*
 * sdram configuration
 *
 */

#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller
#define SDRAM_BASE 0x0
#define SDRAM_CAS_LATENCY 3
#define SDRAM_CONTENTS_INFO
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_IRQ -1
#define SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_IS_INITIALIZED 1
#define SDRAM_NAME "/dev/sdram"
#define SDRAM_POWERUP_DELAY 100.0
#define SDRAM_REFRESH_PERIOD 15.625
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SDRAM_ADDR_WIDTH 0x17
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_SDRAM_COL_WIDTH 9
#define SDRAM_SDRAM_DATA_WIDTH 16
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_ROW_WIDTH 12
#define SDRAM_SHARED_DATA 0
#define SDRAM_SIM_MODEL_BASE 0
#define SDRAM_SPAN 16777216
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_T_AC 5.5
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 20.0
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 20.0
#define SDRAM_T_WR 14.0


/*
 * sysclk_timer configuration
 *
 */

#define ALT_MODULE_CLASS_sysclk_timer altera_avalon_timer
#define SYSCLK_TIMER_ALWAYS_RUN 0
#define SYSCLK_TIMER_BASE 0x1002020
#define SYSCLK_TIMER_COUNTER_SIZE 32
#define SYSCLK_TIMER_FIXED_PERIOD 0
#define SYSCLK_TIMER_FREQ 100000000
#define SYSCLK_TIMER_IRQ 1
#define SYSCLK_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYSCLK_TIMER_LOAD_VALUE 999999
#define SYSCLK_TIMER_MULT 0.0010
#define SYSCLK_TIMER_NAME "/dev/sysclk_timer"
#define SYSCLK_TIMER_PERIOD 10
#define SYSCLK_TIMER_PERIOD_UNITS "ms"
#define SYSCLK_TIMER_RESET_OUTPUT 0
#define SYSCLK_TIMER_SNAPSHOT 1
#define SYSCLK_TIMER_SPAN 32
#define SYSCLK_TIMER_TICKS_PER_SEC 100.0
#define SYSCLK_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYSCLK_TIMER_TYPE "altera_avalon_timer"


/*
 * timestamp configuration
 *
 */

#define ALT_MODULE_CLASS_timestamp altera_avalon_timer
#define TIMESTAMP_ALWAYS_RUN 0
#define TIMESTAMP_BASE 0x1002000
#define TIMESTAMP_COUNTER_SIZE 32
#define TIMESTAMP_FIXED_PERIOD 0
#define TIMESTAMP_FREQ 100000000
#define TIMESTAMP_IRQ 6
#define TIMESTAMP_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMESTAMP_LOAD_VALUE 999999
#define TIMESTAMP_MULT 0.0010
#define TIMESTAMP_NAME "/dev/timestamp"
#define TIMESTAMP_PERIOD 10
#define TIMESTAMP_PERIOD_UNITS "ms"
#define TIMESTAMP_RESET_OUTPUT 0
#define TIMESTAMP_SNAPSHOT 1
#define TIMESTAMP_SPAN 32
#define TIMESTAMP_TICKS_PER_SEC 100.0
#define TIMESTAMP_TIMEOUT_PULSE_OUTPUT 0
#define TIMESTAMP_TYPE "altera_avalon_timer"


/*
 * uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_uart_0 altera_avalon_uart
#define UART_0_BASE 0x1002080
#define UART_0_BAUD 9600
#define UART_0_DATA_BITS 8
#define UART_0_FIXED_BAUD 0
#define UART_0_FREQ 100000000
#define UART_0_IRQ 0
#define UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UART_0_NAME "/dev/uart_0"
#define UART_0_PARITY 'N'
#define UART_0_SIM_CHAR_STREAM ""
#define UART_0_SIM_TRUE_BAUD 0
#define UART_0_SPAN 32
#define UART_0_STOP_BITS 1
#define UART_0_SYNC_REG_DEPTH 2
#define UART_0_TYPE "altera_avalon_uart"
#define UART_0_USE_CTS_RTS 0
#define UART_0_USE_EOP_REGISTER 0


/*
 * watchdog configuration
 *
 */

#define ALT_MODULE_CLASS_watchdog altera_avalon_timer
#define WATCHDOG_ALWAYS_RUN 1
#define WATCHDOG_BASE 0x1002040
#define WATCHDOG_COUNTER_SIZE 32
#define WATCHDOG_FIXED_PERIOD 1
#define WATCHDOG_FREQ 100000000
#define WATCHDOG_IRQ 4
#define WATCHDOG_IRQ_INTERRUPT_CONTROLLER_ID 0
#define WATCHDOG_LOAD_VALUE 99999999
#define WATCHDOG_MULT 1.0
#define WATCHDOG_NAME "/dev/watchdog"
#define WATCHDOG_PERIOD 1
#define WATCHDOG_PERIOD_UNITS "s"
#define WATCHDOG_RESET_OUTPUT 1
#define WATCHDOG_SNAPSHOT 1
#define WATCHDOG_SPAN 32
#define WATCHDOG_TICKS_PER_SEC 1.0
#define WATCHDOG_TIMEOUT_PULSE_OUTPUT 0
#define WATCHDOG_TYPE "altera_avalon_timer"

#endif /* __SYSTEM_H_ */
