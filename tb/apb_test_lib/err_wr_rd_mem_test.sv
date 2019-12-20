`ifndef ERR_WR_RD_MEM_TEST__SV
`define ERR_WR_RD_MEM_TEST__SV

`include "tb_defines.sv"
class err_transaction extends apb_transaction;

  `uvm_object_utils(err_transaction)
  function new(string name = "err_transaction");
    super.new();
  endfunction

//  constraint constr1{paddr[1:0]==0; };
  constraint constr2{paddr > (`APB_SRAM_SIZE-1); };

endclass:err_transaction

class err_wr_rd_mem_sequence extends uvm_sequence #(apb_transaction);

  err_transaction err_tr;

  function new(string name = "err_wr_rd_mem_sequence");
    super.new(name);
  endfunction: new

  virtual task body();
    if(starting_phase != null)
	  starting_phase.raise_objection(this);
	repeat(5) begin
	  //write data to memory, but address exceeds the memory size, will trigger error signal 
	  `uvm_do_with(err_tr, {err_tr.pwrite == 1;})

      #500;
	  //read back memory data, but address exceeds the memory size, will trigger error signal
	  `uvm_do_with(err_tr, {err_tr.pwrite==0;})
	end

    #500;
	if(starting_phase != null)
	  starting_phase.drop_objection(this);
  endtask: body

  `uvm_object_utils(err_wr_rd_mem_sequence)
endclass: err_wr_rd_mem_sequence

class err_wr_rd_mem_test extends apb_base_test;
  function new(string name="err_wr_rd_mem_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

	uvm_config_db#(uvm_object_wrapper)::set(this,
											"env.i_agt.apb_sqr.main_phase",
											"default_sequence",
										    err_wr_rd_mem_sequence::type_id::get());
  endfunction: build_phase
  `uvm_component_utils(err_wr_rd_mem_test) 
endclass: err_wr_rd_mem_test
`endif
