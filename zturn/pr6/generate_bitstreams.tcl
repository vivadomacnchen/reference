open_checkpoint Implement/Config_add_left/top_route_design.dcp
write_bitstream -file Bitstreams/Config_addleft.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/Config_addleft_pblock_reconfig_leds_partial.bit" Bitstreams/left.bin
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/Config_addleft_pblock_rp_instance_partial.bit" Bitstreams/add.bin
close_project 

open_checkpoint Implement/Config_mult_right/top_route_design.dcp 
write_bitstream -file Bitstreams/Config_multright.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/Config_multright_pblock_reconfig_leds_partial.bit" Bitstreams/right.bin
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/Config_multright_pblock_rp_instance_partial.bit" Bitstreams/mult.bin
close_project 

open_checkpoint Checkpoint/static_route_design.dcp 
write_bitstream -file Bitstreams/blanking.bit -force
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/blanking_pblock_reconfig_leds_partial.bit" Bitstreams/b_led.bin
write_cfgmem -format BIN -interface SMAPx32 -disablebitswap -loadbit "up 0 Bitstreams/blanking_pblock_rp_instance_partial.bit" Bitstreams/b_math.bin
close_project 