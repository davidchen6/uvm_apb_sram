`ifndef APB_MODEL__SV
`define APB_MODEL__SV

`include "./tb/defines/tb_defines.sv"

class apb_model extends uvm_component;

  uvm_blocking_get_port #(apb_transaction)  port;
  uvm_blocking_get_port #(apb_transaction)  mdl_port;
  uvm_analysis_port #(apb_transaction)  ap;
  reg [`APB_SRAM_MEM_BLOCK_SIZE-1:0] memory[`APB_SRAM_SIZE-1:0]; 

  `uvm_component_utils(apb_model)

  function new(string name, uvm_component parent);
	super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    $display({"build phase for: ", get_full_name()});
	super.build_phase(phase);
	port = new("port", this);
	mdl_port = new("mdl_port", this);
	ap = new("ap", this);
	foreach (memory[i]) begin
	  memory[i] = `APB_SRAM_RESET_VAL;
//	  $display("memory[%0d] is %0d.", i, memory[i]);
	end
  endfunction

  virtual task main_phase(uvm_phase phase);
	apb_transaction tr, mdl_tr;
	int i;
	while(1)begin
	  fork
		while(1)begin
		  //get tr from i_agent and save data to memory. question: could write and read happen at same time?
		  port.get(tr);
		  if(tr.pwrite==1) begin
		    memory[tr.paddr] = tr.pwdata;
		    $display("tr.pwdata: %h is written to address: %0d.", tr.pwdata, tr.paddr);
		  end
		end

		while(1) begin
		  //get tr from scb and send data to scb
		  mdl_port.get(mdl_tr);
		  i = int'(mdl_tr.paddr);
		  mdl_tr.prdata = memory[i];
		  $display("memory[%0d] is %h.", i, memory[i]);
		  `uvm_info("apb_model", "send tr to scb", UVM_LOW);
		  $display("mdl_tr.prdata is %h in addr: %0d", mdl_tr.prdata, mdl_tr.paddr);
		  ap.write(mdl_tr);
		end
	  join
	end
  endtask
endclass

`endif

