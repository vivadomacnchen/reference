
# User Generated physical constraints 

create_pblock pblock_reconfig_addsub
add_cells_to_pblock [get_pblocks pblock_reconfig_addsub] [get_cells -quiet [list top_i/reconfig_addsub]]
resize_pblock [get_pblocks pblock_reconfig_addsub] -add {SLICE_X22Y36:SLICE_X25Y39}
create_pblock pblock_reconfig_leds
add_cells_to_pblock [get_pblocks pblock_reconfig_leds] [get_cells -quiet [list top_i/reconfig_leds]]
resize_pblock [get_pblocks pblock_reconfig_leds] -add {SLICE_X16Y20:SLICE_X19Y24}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_reconfig_leds]
set_property SNAPPING_MODE ON [get_pblocks pblock_reconfig_leds]

# User Generated miscellaneous constraints 

