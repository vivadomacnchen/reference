
# User Generated physical constraints 

create_pblock pblock_rp_instance
add_cells_to_pblock [get_pblocks pblock_rp_instance] [get_cells -quiet [list system_i/math_0/inst/math_v1_0_S_AXI_inst/rp_instance]]
resize_pblock [get_pblocks pblock_rp_instance] -add {SLICE_X34Y109:SLICE_X39Y123}
resize_pblock [get_pblocks pblock_rp_instance] -add {DSP48_X2Y44:DSP48_X2Y47}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_rp_instance]
set_property SNAPPING_MODE ON [get_pblocks pblock_rp_instance]

# User Generated miscellaneous constraints 

