#  EDA Assignment 2
  Dieter Steinhauser
  
  Adv HW Security

  9/18/25

#  VCS
Open a terminal in the directory of this README file. run the following commands to execute the TCL language learning script. Delete the RTL folder and file_list.txt to observe generation.

`vcs -Mupdate -R -v {verilog-files.v ... verilog-tb.v} {/path/to/GSCLib3.0.v} -o out -debug_all`

`vcs -Mupdate -R -v s38584_syn.v tb_s38584_syn.v /home/UFAD/dsteinhauser/ece-sandbox/adv-hw-security/eda-assignment2/ref/GSCLib_3.0/verilog/GSCLib_3.0.v -o out -debug_all`

`vcs -Mupdate -R -v s38584_syn.v s38584-RN320.v tb_s38584-RN320.v /home/UFAD/dsteinhauser/ece-sandbox/adv-hw-security/eda-assignment2/ref/GSCLib_3.0/verilog/GSCLib_3.0.v -o out -debug_all`

`vcs tb_dff.v dff.v -R -debug_all`

# Design Compiler
Open a terminal in the directory of this README file. run the following commands.

`source /apps/settings`
`dc_shell -gui`

Within the console of the Design compiler GUI, run the the following command:

`source run_compile.tcl`

Run reports can be viewed after compilation.
