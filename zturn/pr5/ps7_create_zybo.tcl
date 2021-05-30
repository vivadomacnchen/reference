start_gui
create_project icap_processor_zybo_lab ./icap_processor_zybo_lab -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
set_property ip_repo_paths  ./Sources/ip_repo [current_project]
update_ip_catalog
create_bd_design "system"
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
startgroup
set_property -dict [list CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0}] [get_bd_cells processing_system7_0]
endgroup
regenerate_bd_layout
startgroup
create_bd_cell -type ip -vlnv xilinx.com:XUP:icap_interface:1.0 icap_interface_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins icap_interface_0/S00_AXI]
regenerate_bd_layout
startgroup
create_bd_cell -type ip -vlnv xilinx.com:XUP:icap_processor:1.0 icap_processor_0
endgroup
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_CLK0] [get_bd_pins icap_processor_0/clk] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_CLK0] [get_bd_pins icap_processor_0/icapclk] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net -net [get_bd_nets rst_ps7_0_100M_peripheral_aresetn] [get_bd_pins icap_processor_0/Rst_n] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
connect_bd_net [get_bd_pins icap_processor_0/we_en] [get_bd_pins icap_interface_0/ps72icap_processor_we]
connect_bd_net [get_bd_pins icap_processor_0/data] [get_bd_pins icap_interface_0/ps72icap_processor_data]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
startgroup
set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]
endgroup
connect_bd_net [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins icap_processor_0/bitstreamlength]
startgroup
create_bd_port -dir O -type rst RP_reset
connect_bd_net [get_bd_pins /icap_processor_0/RP_reset] [get_bd_ports RP_reset]
endgroup
startgroup
create_bd_port -dir O RP_enable
connect_bd_net [get_bd_pins /icap_processor_0/RP_enable] [get_bd_ports RP_enable]
endgroup
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins icap_processor_0/icap_go]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_1/S_AXI]
startgroup
set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_ALL_INPUTS {1}] [get_bd_cells axi_gpio_1]
endgroup
connect_bd_net [get_bd_pins icap_processor_0/reconfig_done] [get_bd_pins axi_gpio_1/gpio_io_i]
create_bd_port -dir O -type clk FCLK_CLK0
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_CLK0] [get_bd_ports FCLK_CLK0] [get_bd_pins processing_system7_0/FCLK_CLK0]
startgroup
create_bd_port -dir O -from 31 -to 0 ICAP_dataout
connect_bd_net [get_bd_pins /icap_processor_0/ICAP_dataout] [get_bd_ports ICAP_dataout]
endgroup
startgroup
create_bd_port -dir O ICAP_CE_n
connect_bd_net [get_bd_pins /icap_processor_0/ICAP_CE_n] [get_bd_ports ICAP_CE_n]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 bitreverseddata2ICAP
connect_bd_net [get_bd_pins /icap_processor_0/bitreverseddata2ICAP] [get_bd_ports bitreverseddata2ICAP]
endgroup
startgroup
create_bd_port -dir O empty
connect_bd_net [get_bd_pins /icap_processor_0/empty] [get_bd_ports empty]
endgroup
startgroup
create_bd_port -dir O full
connect_bd_net [get_bd_pins /icap_processor_0/full] [get_bd_ports full]
endgroup
create_bd_port -dir O reconfig_done
connect_bd_net -net [get_bd_nets icap_processor_0_reconfig_done] [get_bd_ports reconfig_done] [get_bd_pins icap_processor_0/reconfig_done]
create_bd_port -dir O icap_go
connect_bd_net -net [get_bd_nets axi_gpio_0_gpio_io_o] [get_bd_ports icap_go] [get_bd_pins axi_gpio_0/gpio_io_o]
create_bd_port -dir O we_en
connect_bd_net -net [get_bd_nets icap_interface_0_ps72icap_processor_we] [get_bd_ports we_en] [get_bd_pins icap_interface_0/ps72icap_processor_we]
create_bd_port -dir O -from 31 -to 0 Data2ICAP_processor
connect_bd_net -net [get_bd_nets icap_interface_0_ps72icap_processor_data] [get_bd_ports Data2ICAP_processor] [get_bd_pins icap_interface_0/ps72icap_processor_data]
create_bd_port -dir O -from 31 -to 0 bitstreamlength
connect_bd_net -net [get_bd_nets axi_gpio_0_gpio2_io_o] [get_bd_ports bitstreamlength] [get_bd_pins axi_gpio_0/gpio2_io_o]
startgroup
create_bd_port -dir O rd_en
connect_bd_net [get_bd_pins /icap_processor_0/rd_en] [get_bd_ports rd_en]
endgroup
save_bd_design
validate_bd_design
generate_target all [get_files  ./icap_processor_zybo_lab/icap_processor_zybo_lab.srcs/sources_1/bd/system/system.bd]
make_wrapper -files [get_files ./icap_processor_zybo_lab/icap_processor_zybo_lab.srcs/sources_1/bd/system/system.bd] -top
add_files -norecurse ./icap_processor_zybo_lab/icap_processor_zybo_lab.srcs/sources_1/bd/system/hdl/system_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
# import_files -norecurse {./Sources/Static/rp_led.v ./Sources/Static/top.v ./Sources/Static/led_control.v}
import_files -norecurse {./Sources/Static/rModule_leds.v ./Sources/Static/top.v ./Sources/Static/led_control.v}
update_compile_order -fileset sources_1
import_files -fileset constrs_1 C:/xup/PR/labs/icap_processor_lab/Sources/xdc/top_io_zybo.xdc
# Disabling source management mode.  This is to allow the top design properties to be set without GUI intervention.
set_property source_mgmt_mode None [current_project]
set_property top top [current_fileset]
# Re-enabling previously disabled source management mode.
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1
