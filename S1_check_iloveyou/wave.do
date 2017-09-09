onerror {resume}
quietly set dataset_list [list sim vsim1 vsim]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -label sim:/tb_check_iloveyou/Group1 -group {Region: sim:/tb_check_iloveyou} sim:/tb_check_iloveyou/rst_n
add wave -noupdate -expand -label sim:/tb_check_iloveyou/Group1 -group {Region: sim:/tb_check_iloveyou} sim:/tb_check_iloveyou/clk
add wave -noupdate -expand -label sim:/tb_check_iloveyou/Group1 -group {Region: sim:/tb_check_iloveyou} sim:/tb_check_iloveyou/data_in
add wave -noupdate -expand -label sim:/tb_check_iloveyou/Group1 -group {Region: sim:/tb_check_iloveyou} sim:/tb_check_iloveyou/check_out
add wave -noupdate -expand -label sim:/tb_check_iloveyou/Group1 -group {Region: sim:/tb_check_iloveyou} sim:/tb_check_iloveyou/flag_check
add wave -noupdate -expand -label sim:/tb_check_iloveyou/inst_check_iloveyou/Group1 -group {Region: sim:/tb_check_iloveyou/inst_check_iloveyou} -radix unsigned sim:/tb_check_iloveyou/inst_check_iloveyou/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {916790 ps} 1} {{Cursor 2} {528192 ps} 1}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {116041 ps} {1163619 ps}
