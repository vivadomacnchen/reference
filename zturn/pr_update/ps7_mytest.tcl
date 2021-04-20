create_project mytestpr ./mytestpr -part xc7z020clg400-1
set_property board_part myir.com:mys-7z020:part0:2.1 [current_project]
create_bd_design "ps7mysystem"
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_USE_M_AXI_GP0 {0} CONFIG.PCW_EN_CLK0_PORT {0} CONFIG.PCW_EN_RST0_PORT {0} CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1}] [get_bd_cells processing_system7_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.0} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.25} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.25} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.25} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.25} CONFIG.PCW_USE_M_AXI_GP0 {1} CONFIG.PCW_EN_CLK0_PORT {1} CONFIG.PCW_EN_CLK1_PORT {0} CONFIG.PCW_EN_RST0_PORT {1} CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0} CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {2}] [get_bd_cells processing_system7_0]
set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {0}] [get_bd_cells processing_system7_0]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/S00_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins axi_interconnect_0/M00_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
endgroup
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
generate_target all [get_files  /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/bd/ps7mysystem/ps7mysystem.bd]
regenerate_bd_layout
validate_bd_design
make_wrapper -files [get_files /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/bd/ps7mysystem/ps7mysystem.bd] -top
add_files -norecurse /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/bd/ps7mysystem/hdl/ps7mysystem_wrapper.v
save_bd_design
import_files -norecurse {./Sources/static/uart_rx.v ./Sources/static/led_control.v ./Sources/static/uart_tx.v ./Sources/static/uart_tx_ctl.v ./Sources/static/uart_baud_gen.v ./Sources/static/meta_harden.v ./Sources/static/uart_rx_ctl.v ./Sources/static/control.vhd ./Sources/top/top_wrapper.v ./Sources/top/top.vhd}
##import_files -norecurse {./Sources/static/uart_rx.v ./Sources/static/led_control.v ./Sources/static/uart_tx.v ./Sources/static/uart_tx_ctl.v ./Sources/static/uart_baud_gen.v ./Sources/static/meta_harden.v ./Sources/static/uart_rx_ctl.v ./Sources/static/control.vhd}
update_compile_order -fileset sources_1
import_files  ./Sources/ip/char_fifo_zed/char_fifo.xci
update_compile_order -fileset sources_1
set_property top top_wrapper [current_fileset]
update_compile_order -fileset sources_1
#set_property top ps7mysystem_wrapper [current_fileset]
#update_compile_order -fileset sources_1
save_bd_design
update_compile_order -fileset sources_1
upgrade_ip -vlnv xilinx.com:ip:fifo_generator:13.2 [get_ips  char_fifo] -log ip_upgrade.log
export_ip_user_files -of_objects [get_ips char_fifo] -no_script -sync -force -quiet
convert_ips [get_files  /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/ip/char_fifo/char_fifo.xci]
export_ip_user_files -of_objects  [get_files  /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/ip/char_fifo/char_fifo.xci] -sync -lib_map_path [list {modelsim=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/modelsim} {questa=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/questa} {ies=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/ies} {xcelium=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/xcelium} {vcs=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/vcs} {riviera=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/riviera}] -force -quiet
set_property coreContainer.enable 1 [current_project]
generate_target all [get_files  /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/ip/char_fifo/char_fifo.xci]
export_ip_user_files -of_objects [get_files /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/ip/char_fifo/char_fifo.xci] -no_script -sync -force -quiet
export_simulation -of_objects [get_files /home/user/Downloads/pr/mytestpr/mytestpr.srcs/sources_1/ip/char_fifo/char_fifo.xci] -directory /home/user/Downloads/pr/mytestpr/mytestpr.ip_user_files/sim_scripts -ip_user_files_dir /home/user/Downloads/pr/mytestpr/mytestpr.ip_user_files -ipstatic_source_dir /home/user/Downloads/pr/mytestpr/mytestpr.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/modelsim} {questa=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/questa} {ies=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/ies} {xcelium=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/xcelium} {vcs=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/vcs} {riviera=/home/user/Downloads/pr/mytestpr/mytestpr.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
launch_runs synth_1 -jobs 4
wait_on_run synth_1
#
#launch_runs impl_1 -to_step write_bitstream
#read_vhdl Sources/rModule_addsub/adder/adder.vhd
#synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_addsub -part xc7z020clg400-1
#write_checkpoint Synth/rModule_addsub/adder/addsub_synth.dcp -force
#close_design

