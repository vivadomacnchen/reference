#ZYBO
set_property PACKAGE_PIN M14 [get_ports led[0]]
set_property IOSTANDARD LVCMOS33 [get_ports led[0]]
set_property PACKAGE_PIN M15 [get_ports led[1]]
set_property IOSTANDARD LVCMOS33 [get_ports led[1]]
set_property PACKAGE_PIN G14 [get_ports led[2]]
set_property IOSTANDARD LVCMOS33 [get_ports led[2]]
set_property PACKAGE_PIN D18 [get_ports led[3]]
set_property IOSTANDARD LVCMOS33 [get_ports led[3]]

#BTN1
set_property PACKAGE_PIN P16 [get_ports button_r]
set_property IOSTANDARD LVCMOS33 [get_ports button_r]
#BTN0
set_property PACKAGE_PIN R18 [get_ports button_l]
set_property IOSTANDARD LVCMOS33 [get_ports button_l]
#BTN4 connected to MIO50
#set_property PACKAGE_PIN P16 [get_ports gpio_o[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports gpio_o[0]]
#BTN2
set_property PACKAGE_PIN V16 [get_ports button_u]
set_property IOSTANDARD LVCMOS33 [get_ports button_u]
#BTN3
set_property PACKAGE_PIN Y16 [get_ports button_d]
set_property IOSTANDARD LVCMOS33 [get_ports button_d]
#SW0
set_property PACKAGE_PIN G15 [get_ports SW0]
set_property IOSTANDARD LVCMOS33 [get_ports SW0]
#SW1
set_property PACKAGE_PIN P15 [get_ports SW1]
set_property IOSTANDARD LVCMOS33 [get_ports SW1]
