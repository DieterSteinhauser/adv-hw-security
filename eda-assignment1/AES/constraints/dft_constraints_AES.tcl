###########################################
## File Name: dft.tcl
## File to include scan design
###########################################

set RESET_SE reset_se
set TEST_SE test_se
set TEST_MODE test_mode
set SI_PREFIX test_si
set SO_PREFIX test_so
set CHAIN_PREFIX chain

set MAX_CHAIN_LENGTH 64


######################################
set test_use_ctl2prot true
set test_default_period 100
set test_default_delay 0.0
set test_default_bidir_delay 0.0
set test_default_strobe 40.0
set test_default_strobe_width 1.0
######################################



set_scan_configuration -max_length $MAX_CHAIN_LENGTH\
        -create_dedicated_scan_out_ports true\
        -style multiplexed_flip_flop	


set_dft_signal -view exist -type ScanClock -timing [list 45 55] -port [get_ports clk]

set_dft_configuration -fix_reset enable


create_port -direction "in" $TEST_SE


set_dft_signal -view spec -type ScanEnable\
        -active 1 -port [get_port $TEST_SE]


set_autofix_configuration -type clock \
	-include_elements [get_object_name [all_registers]] \
	-method mux \
	-control_signal $TEST_MODE \
	-test_data clk

set_dft_insertion_configuration -map_effort high \
   -synthesis_optimization none

create_test_protocol
dft_drc 
preview_dft
insert_dft
report_test_model
dft_drc
                                                     
