read_vhdl Sources/rModule_addsub/adder/adder.vhd
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_addsub -part xc7z020clg400-1
write_checkpoint Synth/rModule_addsub/adder/addsub_synth.dcp -force
close_design
read_vhdl Sources/rModule_addsub/subtractor/subtractor.vhd
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_addsub -part xc7z020clg400-1
write_checkpoint Synth/rModule_addsub/subtractor/addsub_synth.dcp -force
close_design
read_verilog Sources/rModule_leds/leftshift/rModule_leds.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds -part xc7z020clg400-1
write_checkpoint Synth/rModule_leds/leftshift/shift_synth.dcp -force
close_design
read_verilog Sources/rModule_leds/rightshift/rModule_leds.v
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top rModule_leds -part xc7z020clg400-1
write_checkpoint Synth/rModule_leds/rightshift/shift_synth.dcp -force
close_design
close_project

