import_files -norecurse {./Sources/static/uart_rx.v ./Sources/static/led_control.v ./Sources/static/uart_tx.v ./Sources/static/uart_tx_ctl.v ./Sources/static/uart_baud_gen.v ./Sources/static/meta_harden.v ./Sources/static/uart_rx_ctl.v ./Sources/static/control.vhd ./Sources/top/top_wrapper.v ./Sources/top/top.vhd}
update_compile_order -fileset sources_1
import_files  ./Sources/ip/char_fifo_zed/char_fifo.xci
update_compile_order -fileset sources_1
set_property top top_wrapper [current_fileset]
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
close_project
