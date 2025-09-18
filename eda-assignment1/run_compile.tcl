# File Name: run_compile.tcl
# File for synthesizing a design

# --------------------------------------------
# Dieter Steinhauser
# 9/4/25
# Adv HW Security
# --------------------------------------------

# --------------------------------------------

# Specifies directories that the tool searches for files
set search_path [list /home/UFAD/dsteinhauser/ece-sandbox/adv-hw-security/eda-assignment1] 

# The ASIC technology which the design is mapped
set target_library [list saed90nm_typ.db]

# Specifies the list of design files and libraries used to interpret the input files
set link_library [list saed90nm_typ.db]

# --------------------------------------------
# Define the working directory
# Creates a directory and stores intermediate representations of designs in that directory
define_design_lib work -path ./work

# --------------------------------------------
# read Verilog or VHDL files
# All the design files need to be read, otherwise the un-read designs will be used as black-box
analyze -format verilog /home/UFAD/dsteinhauser/ece-sandbox/adv-hw-security/eda-assignment1/s38584.v
# analyze -format verilog s38584.v

# --------------------------------------------
# Elaborate the top module

# $top is a tcl variable. Use set command to define it
set top "s38584"

# Elaborate command builds a design from its intermediate representation
elaborate -lib work $top

# current_design: command sets the name of top module
current_design $top

# Use link command to resolve design references
# link
# source /home/UFAD/dsteinhauser/ece-sandbox/adv-hw-security/eda_assignment1/AES/constraints/constraints_AES.tcl
# This file applies constraints into the synthesis process

# --------------------------------------------
# Constraint Commands

# Create clock for the current design
# create_clock

# Specifies the clock latency for clocks
# set_clock_latency

# Sets input delay on pins or input ports relative to a clock signal
# set_input_delay

# sets attributes on the specified input to associate an external driving cell with the ports
# set_driving_cell

# sets the max_capacitance attribute to a specified value on the specified clocks, ports or designs
# set_max_capacitance

# Defines the operating conditions for the current design.
# Set_operating_conditions

# --------------------------------------------
# Flatten Netlist

# set_flatten true
# uniquify -force
# ungroup -all -flatten

# NOTE: REMOVE -hierarchy from output save file area if using flattened netlist.

# --------------------------------------------

# compile command performs logic-level and gate-level synthesis and optimization on the current design
compile 

# Options:
# -power_effort Effort for power optimization
# -area_effort Effort for area optimization
# -scan  Replaces all sequential elements with scan elements (DfT) during optimization

# --------------------------------------------

# Scan Chain Insertion
# compile -scan
# source /home/UFAD/dsteinhauser/Desktop/ECE-linux-sandbox/AdvHWSecurity/EDA_assignment1/AES/constraints_AES.tcl
# write_test_protocol -output "aes_128_netlist.spf" 

# Scan Chain Insertion Commands:
# Replace sequential elements with its scan equivalent elements
# compile -scan

# Specifies the scan chain design. 
# set_scan_configuration

# specifies the DFT signal types for DFT insertion
# set_dft_signal

# Sets the DFT configuration for the current design
# set_dft_configuration

# Creates a test protocol based on user specifications
# create_test_protocol

# checks the current design against test design rules
# dft_drc

# inserts DFT logic in the current design
#insert_dft


# --------------------------------------------
# Save Files Commands

# Always use the below command whenever you want to write out a Verilog/VHDL
# change_names-rules [verilog|vhdl] -hierarchy 

#  Use write_file command to save the following files:

# v: gate-level netlist
# NOTE: REMOVE -hierarchy if netlist is flattened
write -format verilog -hierarchy -output "s38584_netlist.v"

# .sdf: timing file for Verilog simulation
write_sdf -version 1.0 s38584_netlist.sdf

# .sdc: timing constraint file for P&R
write_sdc s38584_netlist.sdc

# .spf: test protocol file for Tetramax (for DfT design)


# --------------------------------------------
# Reports Commands

# Reports Area
report_area -hierarchy > "s38584_report.out"

# Reports Reference
report_reference >> "s38584_report.out"

# Reports Dynamic and Static design power
report_power >> "s38584_report.out"

# Reports design timing infomation
report_timing >> "s38584_report.out"


# Report Fanin and Fanout
all_fanin -to [get_ports g27831] > "g27831_fanin_report.out"
all_fanout -from [get_ports g29219] > "g29219_fanout_report.out"

# report switching power for each net
report_power -net -analysis_effort high -nosplit > report.txt

# --------------------------------------------
# Useful Commands

# Returns a list of names of the objects in a collection
# get_object_name 

# Reports pins, ports, or cells in the fanin of specified sinks
# all_fanin

# Returns a set of pins, ports, or cells in the fanout of the specified sources
# all_fanout

# Returns a collection of sequential cells or pins in the current design
# all_registers

# You can use the following commands to get approximated switching activity
report_power -net -analysis_effort high -nosplit > s38584_switching_power.txt

