
/////////////////////////////////////////////////
// include rtl directory
+incdir+../dut
// include testbench directory
+incdir+../tb
// include defines directory
+incdir+../tb/defines
// include agents directory
+incdir+../tb/agents
+incdir+../tb/agents/apb_mstr_agent
// include env directory
+incdir+../tb/env
+incdir+../tb/env/apb_mstr_env
// include sequence library directory 
+incdir+../tb/sequence_lib
//+incdir+../tb/sequence_lib/apb_mstr_sequence_lib
// include test library directory
+incdir+../tb/apb_test_lib
//+incdir+../tb/test_lib/apb_mstr_test_lib
// include tb_top directory
+incdir+../tb/tb_top

#+incdir+$UVM_HOME/src
#$UVM_HOME/src/uvm_pkg.sv

//////// RTL files ////////////
$WORK_HOME/uvm_apb_sram/dut/apb_v3_sram.v
$WORK_HOME/uvm_apb_sram/tb/tb_top/tb_top.sv


