`ifndef APB_MSTR_MONITOR__SV
`define APB_MSTR_MONITOR__SV

class apb_mstr_monitor extends uvm_monitor;

  `uvm_component_utils(apb_mstr_monitor)
  
  virtual apb_inf vif;
  uvm_analysis_port #(apb_transaction)  ap;
  uvm_analysis_port #(apb_transaction)  cov_ap;

  function new(string name="apb_mstr_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    $display({"build phase for: ", get_full_name()});
	super.build_phase(phase);
	if(!uvm_config_db#(virtual apb_inf)::get(this, "", "vif", vif))
	  `uvm_fatal("apb_mstr_monitor", {"virtual interface must be set for:", get_full_name(), ".vif!!!"})
    ap = new("ap", this);
	cov_ap = new("cov_ap", this);
	
  endfunction

  virtual task main_phase(uvm_phase phase);
    apb_transaction apb_tr;

	while(!vif.rst_n)@(posedge vif.clk);
	`uvm_info("apb_mstr_monitor", "start to collect packet...", UVM_LOW);
	@(posedge vif.clk);
	while(1) begin
   	  apb_tr = new();
  	  $display({"main phase for: ", get_full_name()});
	  collect_one_pkt(apb_tr);
      ap.write(apb_tr);
	  cov_ap.write(apb_tr);
    end
  endtask: main_phase

  virtual task collect_one_pkt(apb_transaction apb_tr);
    @(posedge vif.clk);
    //#10;
	while(vif.psel==0) #10;
	while(vif.penable==0)#10;
	@(posedge vif.clk);
	apb_tr.paddr = vif.paddr;
	apb_tr.pwrite = vif.pwrite;
	apb_tr.pwdata = vif.pwdata;
    repeat (1) @(posedge vif.clk);
	apb_tr.prdata = vif.prdata;
	if(apb_tr.pwrite==0)begin
      $display("Monitor abp_tr.prdata is %0h in addr: %0d", apb_tr.prdata, apb_tr.paddr);
	end
  endtask: collect_one_pkt
endclass
`endif
