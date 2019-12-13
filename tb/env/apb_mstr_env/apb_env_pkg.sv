`ifndef APB_ENV_PKG__SV
`define APB_ENV_PKG__SV

package apb_env_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "./tb/defines/tb_defines.sv"
  import apb_agent_pkg::*;
  //include sv file
//  `include "./tb/tb_top/apb_interface.sv"
  `include "./tb/env/apb_mstr_env/apb_model.sv"
  `include "./tb/env/apb_mstr_env/apb_scoreboard.sv"
  `include "./tb/env/apb_mstr_env/apb_env.sv"

endpackage: apb_env_pkg
`endif
