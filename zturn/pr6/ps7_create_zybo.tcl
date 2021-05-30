start_gui
create_project prc_zybo_lab ./prc_zybo_lab -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
set_property ip_repo_paths  ./Sources/ip_repo [current_project]
update_ip_catalog
create_bd_design "system"
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {1}]] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.PCW_GPIO_EMIO_GPIO_IO {1}] [get_bd_cells processing_system7_0]
create_bd_port -dir O -from 0 -to 0 GPIO_O
connect_bd_net [get_bd_pins /processing_system7_0/GPIO_O] [get_bd_ports GPIO_O]
create_bd_cell -type ip -vlnv xilinx.com:XUP:math:1.0 math_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins math_0/S_AXI]
create_bd_cell -type ip -vlnv xilinx.com:ip:prc:1.1 prc_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_0]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Slave "/processing_system7_0/S_AXI_HP0" Clk "Auto" }  [get_bd_intf_pins prc_0/m_axi_mem]
set_property -dict [list CONFIG.ALL_PARAMS {HAS_AXI_LITE_IF 1 RESET_ACTIVE_LEVEL 0 CP_FIFO_DEPTH 32 CP_FIFO_TYPE lutram CDC_STAGES 2 VS {rp_math {ID 0 NAME rp_math RM {add {ID 0 NAME add BS {0 {ID 0 ADDR 2097152 SIZE 0 CLEAR 0}}} mult {ID 1 NAME mult BS {0 {ID 0 ADDR 3145728 SIZE 0 CLEAR 0}}} b_math {ID 2 NAME b_math BS {0 {ID 0 ADDR 6291456 SIZE 0 CLEAR 0}}}} POR_RM add RMS_ALLOCATED 4 NUM_HW_TRIGGERS 3 NUM_TRIGGERS_ALLOCATED 4} rp_shift {ID 1 NAME rp_shift RM {left {ID 0 NAME left BS {0 {ID 0 ADDR 4194304 SIZE 0 CLEAR 0}}} right {ID 1 NAME right BS {0 {ID 0 ADDR 5242880 SIZE 0 CLEAR 0}}} b_led {ID 2 NAME b_led BS {0 {ID 0 ADDR 7340032 SIZE 0 CLEAR 0}}}} RMS_ALLOCATED 4 NUM_HW_TRIGGERS 3 NUM_TRIGGERS_ALLOCATED 4}} CP_FAMILY 7series DIRTY 0 CP_ARBITRATION_PROTOCOL 1} CONFIG.GUI_CDC_STAGES {2} CONFIG.GUI_SELECT_VS {0} CONFIG.GUI_VS_NUM_HW_TRIGGERS {3} CONFIG.GUI_VS_NUM_TRIGGERS_ALLOCATED {4} CONFIG.GUI_VS_NUM_RMS_ALLOCATED {4} CONFIG.GUI_VS_POR_RM {0} CONFIG.GUI_SELECT_RM {0} CONFIG.GUI_BS_ADDRESS_0 {0x200000} CONFIG.GUI_SELECT_TRIGGER_0 {0} CONFIG.GUI_SELECT_TRIGGER_1 {1} CONFIG.GUI_SELECT_TRIGGER_2 {2} CONFIG.GUI_SELECT_TRIGGER_3 {0}] [get_bd_cells prc_0]
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:icap_rtl:1.0 ICAP
connect_bd_intf_net [get_bd_intf_pins prc_0/ICAP] [get_bd_intf_ports ICAP]
create_bd_port -dir I -type clk icap_clk
connect_bd_net [get_bd_pins /prc_0/icap_clk] [get_bd_ports icap_clk]
create_bd_port -dir I -from 2 -to 0 vsm_rp_math_hw_triggers
connect_bd_net [get_bd_pins /prc_0/vsm_rp_math_hw_triggers] [get_bd_ports vsm_rp_math_hw_triggers]
create_bd_port -dir I -from 2 -to 0 vsm_rp_shift_hw_triggers
connect_bd_net [get_bd_pins /prc_0/vsm_rp_shift_hw_triggers] [get_bd_ports vsm_rp_shift_hw_triggers]
create_bd_port -dir I icap_reset
connect_bd_net [get_bd_pins /prc_0/icap_reset] [get_bd_ports icap_reset]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins prc_0/s_axi_reg]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property name logic_1 [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.CONST_VAL {1}] [get_bd_cells logic_1]
connect_bd_net [get_bd_pins logic_1/dout] [get_bd_pins prc_0/vsm_rp_math_rm_shutdown_ack]
connect_bd_net -net [get_bd_nets logic_1_dout] [get_bd_pins prc_0/vsm_rp_shift_rm_shutdown_ack] [get_bd_pins logic_1/dout]
create_bd_port -dir O FCLK_CLK0
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_CLK0] [get_bd_ports FCLK_CLK0] [get_bd_pins processing_system7_0/FCLK_CLK0]
create_bd_port -dir O FCLK_RESET0_N
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_RESET0_N] [get_bd_ports FCLK_RESET0_N] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
save_bd_design
make_wrapper -files [get_files ./prc_zybo_lab/prc_zybo_lab.srcs/sources_1/bd/system/system.bd] -top
add_files -norecurse ./prc_zybo_lab/prc_zybo_lab.srcs/sources_1/bd/system/hdl/system_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files  ./prc_zybo_lab/prc_zybo_lab.srcs/sources_1/bd/system/system.bd]
import_files -norecurse {./Sources/Static/meta_harden.v ./Sources/Static/rp_led.v ./Sources/Static/led_control.v ./Sources/Static/top_zybo.v}
update_compile_order -fileset sources_1
# Disabling source management mode.  This is to allow the top design properties to be set without GUI intervention.
set_property source_mgmt_mode None [current_project]
set_property top top [current_fileset]
# Re-enabling previously disabled source management mode.
set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1

