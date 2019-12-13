`ifndef APB_AGENT_PKG__SV
`define APB_AGENT_PKG__SV

package apb_agent_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "./tb/defines/tb_defines.sv"

  //include sv file
//  `include "./tb/tb_top/apb_interface.sv"
  `include "./tb/agents/apb_mstr_agent/apb_transaction.sv"
  `include "./tb/agents/apb_mstr_agent/apb_mstr_driver.sv"
  `include "./tb/agents/apb_mstr_agent/apb_mstr_monitor.sv"
  `include "./tb/agents/apb_mstr_agent/apb_sequencer.sv"
  `include "./tb/agents/apb_mstr_agent/apb_cov.sv"
  `include "./tb/agents/apb_mstr_agent/apb_agent.sv"

endpackage: apb_agent_pkg
`endif
