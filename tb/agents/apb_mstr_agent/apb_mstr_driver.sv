`ifndef APB_MSTR_DRIVER__SV
`define APB_MSTR_DRIVER__SV

`include "tb_defines.sv"

class apb_mstr_driver extends uvm_driver #(apb_transaction);

  `uvm_component_utils(apb_mstr_driver)
  virtual apb_inf vif;
//  uvm_analysis_port#(apb_transaction) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    $display({"build phase for: ", get_full_name()});
	super.build_phase(phase);
	if(!uvm_config_db#(virtual apb_inf)::get(this, "", "vif", vif))
	  `uvm_fatal("apb_mstr_driver", {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  //  ap = new("ap", this);
  endfunction:build_phase

  virtual task main_phase(uvm_phase phase);
//    phase.raise_objection(this);
    $display({"main phase for: ", get_full_name()});
	while(!vif.rst_n)@(posedge vif.clk);
	`uvm_info("apb_mstr_driver", "start to drive packet...", UVM_LOW);
	
	while(1) begin
      seq_item_port.get_next_item(req);
	  if(req.pwrite)begin
	    write_one_pkt(req);
	  end
	  else begin
	    read_one_pkt(req);
	  end
	  seq_item_port.item_done();
	end
//	phase.drop_objection(this);
  endtask: main_phase

  virtual task write_one_pkt(apb_transaction tr);
    @(posedge vif.clk);
    #10;
	vif.paddr <= tr.paddr;
	vif.pwrite <= tr.pwrite;
	vif.psel <= 1;
	vif.pwdata <= tr.pwdata;
	vif.penable <= 0;
	@(posedge vif.clk);
    #10;
	vif.penable <= 1;
	wait(vif.pready==1);
    @(posedge vif.clk);
	#10;
	vif.psel <= 0;
	vif.penable <= 0;
	repeat(1)@(posedge vif.clk);

  endtask: write_one_pkt
  
  virtual task read_one_pkt(apb_transaction tr);
    @(posedge vif.clk);
    //#10;
	vif.paddr <= tr.paddr;
	vif.pwrite <= tr.pwrite;
	vif.psel <= 1;
	vif.penable <= 0;
	@(posedge vif.clk);
   // #10;
	vif.penable <= 1;
	wait(vif.pready==1);
	@(posedge vif.clk);
//	#10;
	vif.psel <= 0;
	vif.penable <= 0;
//	tr.prdata = vif.prdata;
//	`uvm_info("apb_mstr_driver", $sformatf("tr.prdata is %0h in addr: %0d", tr.prdata, tr.paddr), UVM_LOW);
	repeat(1)@(posedge vif.clk);
  endtask: read_one_pkt
  
endclass: apb_mstr_driver

`endif

