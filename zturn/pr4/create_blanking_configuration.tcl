open_checkpoint Checkpoint/static_route_design.dcp
update_design -buffer_ports -cell system_i/math_0/inst/math_v1_0_S_AXI_inst/rp_instance
place_design
route_design
write_checkpoint -force Implement/Config_blank/top_route_design.dcp
close_project
