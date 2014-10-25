vlog *.v
vsim y86_min_sopc_tb
add wave -radix hexadecimal -r sim:/y86_min_sopc_tb/y86_min_sopc0/inst_rom0/*
add wave -radix hexadecimal -r sim:/y86_min_sopc_tb/y86_min_sopc0/inst_rom0/inst_mem
add wave -radix hexadecimal -r sim:/y86_min_sopc_tb/y86_min_sopc0/y86cpu0/*
add wave -radix hexadecimal sim:/y86_min_sopc_tb/y86_min_sopc0/y86cpu0/regfile0/regs
config wave -signalnamewidth 2
run -all
