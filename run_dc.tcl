#### Script to run Design Compiler with Different Scenarios#####
##
##################################
#Scenario :
##################################
#
set PDK_PATH ./../ref
set DESIGN_NAME                   "dma_top"
#
source -echo -verbose ./rm_setup/dc_setup.tcl
set RTL_SOURCE_FILES ./../rtl/dma_top.v

define_design_lib WORK -path ./WORK

#set_dont_use [get_lib_cells */FADD*]
#set_dont_use [get_lib_cells */HADD*]
#set_dont_use [get_lib_cells */AO*]
#set_dont_use [get_lib_cells */OA*]
#set_dont_use [get_lib_cells */NAND*]
#set_dont_use [get_lib_cells */XOR*]
#set_dont_use [get_lib_cells */NOR*]
#set_dont_use [get_lib_cells */XNOR*]
#set_dont_use [get_lib_cells */MUX*]

analyze -format verilog ${RTL_SOURCE_FILES}
elaborate ${DESIGN_NAME}
current_design


read_sdc -echo ./../CONSTRAINTS/dma_top.sdc

#compile

compile_ultra
#report_timing
report_area -hierarchy > results/dma_top_area.rpt
report_timing -path full > results/dma_top_timing.rpt
report_power > results/dma_top_power.rpt
#
### To write results
write -format verilog -hierarchy -output ${RESULTS_DIR}/${DCRM_FINAL_VERILOG_OUTPUT_FILE}
#
write_sdc ./${RESULTS_DIR}/${DCRM_FINAL_SDC_OUTPUT_FILE}
#
#### To write the files needed to to load the design in IC Compiler II.
write_icc2_files -output icc2_files -force
