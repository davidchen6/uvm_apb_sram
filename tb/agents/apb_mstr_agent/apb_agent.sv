`ifndef APB_AGENT__SV
`define APB_AGENT__SV

class apb_agent extends uvm_agent;
  apb_mstr_driver apb_drv;
  apb_mstr_monitor apb_mon;
  apb_sequencer apb_sqr;
  apb_cov cov;

  uvm_analysis_port #(apb_transaction)  ap;
  uvm_tlm_analysis_fifo #(apb_transaction) mon_cov_fifo;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    $display({"build phase for: ", get_full_name()});
	super.build_phase(phase);
	if(is_active==UVM_ACTIVE) begin
	  apb_drv = apb_mstr_driver::type_id::create("apb_drv", this);
	  apb_sqr = apb_sequencer::type_id::create("apb_sqr", this);
	  cov = apb_cov::type_id::create("cov", this);
	  mon_cov_fifo = new("mon_cov_fifo", this);
	end
	apb_mon = apb_mstr_monitor::type_id::create("apb_mon", this);

  endfunction

  extern virtual function void connect_phase(uvm_phase phase);
  
  `uvm_component_utils(apb_agent)

endclass

function void apb_agent::connect_phase(uvm_phase phase);
  $display({"connect phase for: ", get_full_name()});
  super.connect_phase(phase);
  if(is_active==UVM_ACTIVE) begin
    apb_drv.seq_item_port.connect(apb_sqr.seq_item_export);
    apb_mon.cov_ap.connect(mon_cov_fifo.analysis_export);
	cov.cov_port.connect(mon_cov_fifo.blocking_get_export);
  end
  ap = apb_mon.ap;
endfunction:connect_phase

`endif
