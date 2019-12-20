`ifndef APB_ENV__SV
`define APB_ENV__SV

class apb_env extends uvm_component;
  apb_agent i_agt;
  apb_agent o_agt;
  apb_scoreboard scb;
  apb_model mdl;

  uvm_tlm_analysis_fifo #(apb_transaction) agt_scb_fifo;
  uvm_tlm_analysis_fifo #(apb_transaction) agt_mdl_fifo;
  //uvm_tlm_analysis_fifo #(apb_transaction) mdl_scb_fifo;
//  uvm_tlm_analysis_fifo #(apb_transaction) scb_mdl_fifo;

  function new(string name = "apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    $display({"build phase for: ", get_full_name()});
	super.build_phase(phase);
	i_agt = apb_agent::type_id::create("i_agt", this);
	o_agt = apb_agent::type_id::create("o_agt", this);
	i_agt.is_active = UVM_ACTIVE;
	o_agt.is_active = UVM_PASSIVE;
	scb = apb_scoreboard::type_id::create("scb", this);
	mdl = apb_model::type_id::create("mdl", this);

	agt_scb_fifo = new("agt_scb_fifo", this);
	agt_mdl_fifo = new("agt_mdl_fifo", this);
	//mdl_scb_fifo = new("mdl_scb_fifo", this);
//	scb_mdl_fifo = new("scb_mdl_fifo", this);
  endfunction

  extern virtual function void connect_phase(uvm_phase phase);
  `uvm_component_utils(apb_env)
endclass

function void apb_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase); 
  i_agt.ap.connect(agt_mdl_fifo.analysis_export);
  mdl.port.connect(agt_mdl_fifo.blocking_get_export);
  //mdl.ap.connect(mdl_scb_fifo.analysis_export);
  //scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
  scb.rd_transport.connect(mdl.mdl_imp);
  //mdl.mdl_port.connect(scb_mdl_fifo.blocking_get_export);
  o_agt.ap.connect(agt_scb_fifo.analysis_export);
  scb.act_port.connect(agt_scb_fifo.blocking_get_export);
endfunction


`endif
