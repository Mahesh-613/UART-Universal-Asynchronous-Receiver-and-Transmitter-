# read modules from Verilog file
read_verilog top.v Transmitter.v Receiver.v baud_rate_generator.v

# elaborate design hierarchy
hierarchy -check -top top
check

synth -top top

show -format dot -prefix uart_schematic top
flatten

# mapping to internal cell library
techmap

# mapping flip-flops to NangateOpenCellLibrary_typical.lib 
# for eg. always block
dfflibmap -liberty NangateOpenCellLibrary_low_temp.lib
# mapping logic to NangateOpenCellLibrary_typical.lib 
# for eg. assign block
abc -liberty NangateOpenCellLibrary_low_temp.lib
 
# remove unused cells and wires
clean
stat -liberty NangateOpenCellLibrary_low_temp.lib


# Write the current design to a Verilog file
write_verilog -noattr -noexpr UART_synth.v 
