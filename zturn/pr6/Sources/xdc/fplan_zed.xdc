
# User Generated physical constraints 

create_pblock pblock_rp_instance
add_cells_to_pblock [get_pblocks pblock_rp_instance] [get_cells -quiet [list system_wrapper_i/system_i/math_0/inst/math_v1_0_S_AXI_inst/rp_instance]]
resize_pblock [get_pblocks pblock_rp_instance] -add {SLICE_X34Y109:SLICE_X39Y123}
resize_pblock [get_pblocks pblock_rp_instance] -add {DSP48_X2Y44:DSP48_X2Y47}
create_pblock pblock_reconfig_leds
add_cells_to_pblock [get_pblocks pblock_reconfig_leds] [get_cells -quiet [list reconfig_leds]]
resize_pblock [get_pblocks pblock_reconfig_leds] -add {SLICE_X16Y20:SLICE_X19Y24}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_reconfig_leds]
set_property SNAPPING_MODE ON [get_pblocks pblock_reconfig_leds]

# User Generated miscellaneous constraints 

