start_gui
#create_project hwicap_zed_lab ./hwicap_zed_lab -part xc7z020clg484-1
create_project mytestpr ./mytestpr -part xc7z020clg400-1
#set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property board_part myir.com:mys-7z020:part0:2.1 [current_project]
set_property ip_repo_paths ./Sources/ip_repo [current_project]
update_ip_catalog
create_bd_design "system"
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
#
#ori start
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
#startgroup
#set_property -dict [list CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0}] [get_bd_cells processing_system7_0]
#set_property -dict [list CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {1}] [get_bd_cells processing_system7_0]
#endgroup
#ori end
#zturn
startgroup
set_property -dict [list CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.0} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.25} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.25} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.25} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.25} CONFIG.PCW_USE_M_AXI_GP0 {1} CONFIG.PCW_EN_CLK0_PORT {1} CONFIG.PCW_EN_CLK1_PORT {0} CONFIG.PCW_EN_RST0_PORT {1} CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {1} CONFIG.PCW_USE_S_AXI_HP0 {0}] [get_bd_cells processing_system7_0]
endgroup
#
startgroup
create_bd_cell -type ip -vlnv xilinx.com:XUP:math:1.0 math_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins math_0/S_AXI]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_hwicap:3.0 axi_hwicap_0
endgroup
startgroup
set_property -dict [list CONFIG.C_INCLUDE_STARTUP {1}] [get_bd_cells axi_hwicap_0]
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_hwicap_0/S_AXI_LITE]
connect_bd_net -net [get_bd_nets processing_system7_0_FCLK_CLK0] [get_bd_pins axi_hwicap_0/icap_clk] [get_bd_pins processing_system7_0/FCLK_CLK0]
create_bd_cell -type ip -vlnv xilinx.com:ip:pr_decoupler:1.0 pr_decoupler_0
startgroup
set_property -dict [list CONFIG.ALL_PARAMS {HAS_SIGNAL_STATUS 0 INTF {intf_0 {ID 0 VLNV xilinx.com:interface:aximm_rtl:1.0 PROTOCOL axi4lite SIGNALS {ARVALID {PRESENT 1} ARREADY {PRESENT 1} AWVALID {PRESENT 1} AWREADY {PRESENT 1} BVALID {PRESENT 1} BREADY {PRESENT 1} RVALID {PRESENT 1} RREADY {PRESENT 1} WVALID {PRESENT 1} WREADY {PRESENT 1} AWADDR {PRESENT 1} AWLEN {PRESENT 0} AWSIZE {PRESENT 0} AWBURST {PRESENT 0} AWLOCK {PRESENT 0} AWCACHE {PRESENT 0} AWPROT {PRESENT 1} WDATA {PRESENT 1} WSTRB {PRESENT 1} WLAST {PRESENT 0} BRESP {PRESENT 1} ARADDR {PRESENT 1} ARLEN {PRESENT 0} ARSIZE {PRESENT 0} ARBURST {PRESENT 0} ARLOCK {PRESENT 0} ARCACHE {PRESENT 0} ARPROT {PRESENT 1} RDATA {PRESENT 1} RRESP {PRESENT 1} RLAST {PRESENT 0}} MODE slave}}} CONFIG.GUI_SELECT_VLNV {xilinx.com:interface:aximm_rtl:1.0} CONFIG.GUI_INTERFACE_PROTOCOL {axi4lite} CONFIG.GUI_SELECT_MODE {slave} CONFIG.GUI_HAS_SIGNAL_STATUS {0} CONFIG.GUI_SELECT_INTERFACE {0} CONFIG.GUI_INTERFACE_NAME {intf_0} CONFIG.GUI_SIGNAL_SELECT_0 {ARVALID} CONFIG.GUI_SIGNAL_SELECT_1 {ARREADY} CONFIG.GUI_SIGNAL_SELECT_2 {AWVALID} CONFIG.GUI_SIGNAL_SELECT_3 {AWREADY} CONFIG.GUI_SIGNAL_SELECT_4 {BVALID} CONFIG.GUI_SIGNAL_SELECT_5 {BREADY} CONFIG.GUI_SIGNAL_SELECT_6 {RVALID} CONFIG.GUI_SIGNAL_SELECT_7 {RREADY} CONFIG.GUI_SIGNAL_SELECT_8 {WVALID} CONFIG.GUI_SIGNAL_SELECT_9 {WREADY} CONFIG.GUI_SIGNAL_DECOUPLED_0 {true} CONFIG.GUI_SIGNAL_DECOUPLED_1 {true} CONFIG.GUI_SIGNAL_DECOUPLED_2 {true} CONFIG.GUI_SIGNAL_DECOUPLED_3 {true} CONFIG.GUI_SIGNAL_DECOUPLED_4 {true} CONFIG.GUI_SIGNAL_DECOUPLED_5 {true} CONFIG.GUI_SIGNAL_DECOUPLED_6 {true} CONFIG.GUI_SIGNAL_DECOUPLED_7 {true} CONFIG.GUI_SIGNAL_DECOUPLED_8 {true} CONFIG.GUI_SIGNAL_DECOUPLED_9 {true} CONFIG.GUI_SIGNAL_PRESENT_0 {true} CONFIG.GUI_SIGNAL_PRESENT_1 {true} CONFIG.GUI_SIGNAL_PRESENT_2 {true} CONFIG.GUI_SIGNAL_PRESENT_3 {true} CONFIG.GUI_SIGNAL_PRESENT_4 {true} CONFIG.GUI_SIGNAL_PRESENT_5 {true} CONFIG.GUI_SIGNAL_PRESENT_6 {true} CONFIG.GUI_SIGNAL_PRESENT_7 {true} CONFIG.GUI_SIGNAL_PRESENT_8 {true} CONFIG.GUI_SIGNAL_PRESENT_9 {true}] [get_bd_cells pr_decoupler_0]
endgroup
delete_bd_objs [get_bd_intf_nets ps7_0_axi_periph_M00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps7_0_axi_periph/M00_AXI] [get_bd_intf_pins pr_decoupler_0/s_intf_0]
connect_bd_intf_net [get_bd_intf_pins pr_decoupler_0/rp_intf_0] [get_bd_intf_pins math_0/S_AXI]
connect_bd_net [get_bd_pins processing_system7_0/GPIO_O] [get_bd_pins pr_decoupler_0/decouple]
assign_bd_address
validate_bd_design
regenerate_bd_layout
#make_wrapper -files [get_files ./hwicap_zed_lab/hwicap_zed_lab.srcs/sources_1/bd/system/system.bd] -top
make_wrapper -files [get_files ./mytestpr/mytestpr.srcs/sources_1/bd/system/system.bd] -top
#add_files -norecurse ./hwicap_zed_lab/hwicap_zed_lab.srcs/sources_1/bd/system/hdl/system_wrapper.v
add_files -norecurse ./mytestpr/mytestpr.srcs/sources_1/bd/system/hdl/system_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
save_bd_design
# set_property generate_synth_checkpoint true [get_files  ./hwicap_zed_lab/hwicap_zed_lab.srcs/sources_1/bd/system/system.bd]
# launch_runs synth_1 -jobs 4
# wait_on_run synth_1
# close_project
