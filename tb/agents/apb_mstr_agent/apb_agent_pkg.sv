`ifndef APB_AGENT_PKG__SV
`define APB_AGENT_PKG__SV

package apb_agent_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "tb_defines.sv"

  //include sv file
//  `include "./tb/tb_top/apb_interface.sv"
  `include "apb_transaction.sv"
  `include "apb_mstr_driver.sv"
  `include "apb_mstr_monitor.sv"
  `include "apb_sequencer.sv"
  `include "apb_cov.sv"
  `include "apb_agent.sv"

endpackage: apb_agent_pkg
`endif
