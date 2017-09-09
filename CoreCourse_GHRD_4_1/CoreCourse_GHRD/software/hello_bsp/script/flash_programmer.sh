#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting SOF File: G:\XiaoMeige_fpga_System\class\sopc_class\CoreCourse_GHRD\output_files\CoreCourse_GHRD.sof to: "..\flash/CoreCourse_GHRD_epcs.flash"
#
sof2flash --input="G:/XiaoMeige_fpga_System/class/sopc_class/CoreCourse_GHRD/output_files/CoreCourse_GHRD.sof" --output="../flash/CoreCourse_GHRD_epcs.flash" --epcs 

#
# Programming File: "..\flash/CoreCourse_GHRD_epcs.flash" To Device: epcs
#
nios2-flash-programmer "../flash/CoreCourse_GHRD_epcs.flash" --base=0x1001000 --epcs --accept-bad-sysid --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program 

#
# Converting ELF File: G:\XiaoMeige_fpga_System\class\sopc_class\CoreCourse_GHRD\software\hello\hello.elf to: "..\flash/hello_epcs.flash"
#
elf2flash --input="G:/XiaoMeige_fpga_System/class/sopc_class/CoreCourse_GHRD/software/hello/hello.elf" --output="../flash/hello_epcs.flash" --epcs --after="../flash/CoreCourse_GHRD_epcs.flash" 

#
# Programming File: "..\flash/hello_epcs.flash" To Device: epcs
#
nios2-flash-programmer "../flash/hello_epcs.flash" --base=0x1001000 --epcs --accept-bad-sysid --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program 

