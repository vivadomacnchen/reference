create_project mytestpr ./mytestpr -part xc7z020clg400-1
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
create_bd_design "ps7mysystem"
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {0} CONFIG.PCW_UIPARAM_DDR_ENABLE {0} CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB_RESET_ENABLE {0} CONFIG.PCW_I2C_RESET_ENABLE {0} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {2}] [get_bd_cells processing_system7_0]
delete_bd_objs [get_bd_intf_nets processing_system7_0_DDR]
endgroup
delete_bd_objs [get_bd_intf_ports DDR]
startgroup
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0
connect_bd_intf_net [get_bd_intf_pins processing_system7_0/GPIO_0] [get_bd_intf_ports GPIO_0]
endgroup
startgroup
create_bd_port -dir O -type clk FCLK_CLK0
connect_bd_net [get_bd_pins /processing_system7_0/FCLK_CLK0] [get_bd_ports FCLK_CLK0]
endgroup
startgroup
create_bd_port -dir O -type rst FCLK_RESET0_N
connect_bd_net [get_bd_pins /processing_system7_0/FCLK_RESET0_N] [get_bd_ports FCLK_RESET0_N]
endgroup
regenerate_bd_layout
validate_bd_design
make_wrapper -files [get_files ./uart_led_zed_lab/uart_led_zed_lab.srcs/sources_1/bd/system/system.bd] -top
add_files -norecurse ./uart_led_zed_lab/uart_led_zed_lab.srcs/sources_1/bd/system/hdl/system_wrapper.v
save_bd_design

