open_checkpoint Synth/Static/top.dcp

read_checkpoint -cell system_wrapper_i/system_i/processing_system7_0 Synth/Static/system_processing_system7_0_0.dcp
read_checkpoint -cell system_wrapper_i/system_i/ps7_0_axi_periph/s00_couplers/auto_pc Synth/Static/system_auto_pc_0.dcp
read_checkpoint -cell system_wrapper_i/system_i/axi_interconnect_0/s00_couplers/auto_pc Synth/Static/system_auto_pc_1.dcp
read_checkpoint -cell system_wrapper_i/system_i/math_0 Synth/Static/system_math_0_0.dcp
read_checkpoint -cell system_wrapper_i/system_i/prc_0 Synth/Static/system_prc_0_0.dcp
read_checkpoint -cell system_wrapper_i/system_i/rst_ps7_0_100M Synth/Static/system_rst_ps7_0_100M_0.dcp
read_checkpoint -cell system_wrapper_i/system_i/ps7_0_axi_periph/xbar Synth/Static/system_xbar_0.dcp
read_checkpoint -cell system_wrapper_i/system_i/logic_1 Synth/Static/system_xlconstant_0_0.dcp

read_checkpoint -cell system_wrapper_i/system_i/math_0/inst/math_v1_0_S_AXI_inst/rp_instance Synth/reconfig_modules/rp_add/add_mult_synth.dcp 
read_checkpoint -cell reconfig_leds Synth/rModule_leds/leftshift/shift_synth.dcp
set_property HD.RECONFIGURABLE 1 [get_cells system_wrapper_i/system_i/math_0/inst/math_v1_0_S_AXI_inst/rp_instance] 
set_property HD.RECONFIGURABLE 1 [get_cells reconfig_leds]
write_checkpoint Checkpoint/top_link_add_left.dcp

read_xdc Sources/xdc/fplan_zybo.xdc
read_xdc Sources/xdc/top_io_zybo.xdc
