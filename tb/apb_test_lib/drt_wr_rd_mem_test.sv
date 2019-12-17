`ifndef DRT_WR_RD_MEM_TEST__SV
`define DRT_WR_RD_MEM_TEST__SV

class drt_wr_rd_mem_sequence extends uvm_sequence #(apb_transaction);

  apb_transaction apb_tr;

  function new(string name = "drt_wr_rd_mem_sequence");
    super.new(name);
  endfunction: new

  virtual task body();
    int i = 0;
	int my_data;
    if(starting_phase != null)
	  starting_phase.raise_objection(this);
	//read reset value of memory after POR.
    while(i<(`APB_SRAM_SIZE)) begin
	  `uvm_do_with(apb_tr, {apb_tr.pwrite==0; apb_tr.paddr == i;})
	  i++;
	end

	#500;
	//write 32'h55555555 and 32'haaaaaaaa to memory 
	i = 0;
	while(i<(`APB_SRAM_SIZE)) begin
      if(i%2==0)
	    my_data = 32'h55555555;
	    //my_data = 32'h00005555;
	  else
	    //my_data = 32'haaaa0000;
		my_data = 32'haaaaaaaa;
	  `uvm_do_with(apb_tr, {apb_tr.pwrite == 1; apb_tr.paddr == i;apb_tr.pwdata == my_data;})
	  i++;
	end

    #500;
	//read back all memory data.
	i = 0;
	while(i<(`APB_SRAM_SIZE)) begin
	  `uvm_do_with(apb_tr, {apb_tr.pwrite==0; apb_tr.paddr == i;})
	  i++;
	end

	#500;
	//write 32'h55555555 and 32'haaaaaaaa to memory 
	i = 0;
	while(i<(`APB_SRAM_SIZE)) begin
      if(i%2==0)
	    //my_data = 32'h00005555;
		my_data = 32'haaaaaaaa;
	  else
	    //my_data = 32'haaaa0000;
	    my_data = 32'h55555555;
	  `uvm_do_with(apb_tr, {apb_tr.pwrite == 1; apb_tr.paddr == i;apb_tr.pwdata == my_data;})
	  i++;
	end

    #500;
	//read back all memory data.
	i = 0;
	while(i<(`APB_SRAM_SIZE)) begin
	  `uvm_do_with(apb_tr, {apb_tr.pwrite==0; apb_tr.paddr == i;})
	  i++;
	end
    #500;
	if(starting_phase != null)
	  starting_phase.drop_objection(this);
  endtask: body

  `uvm_object_utils(drt_wr_rd_mem_sequence)
endclass: drt_wr_rd_mem_sequence

class drt_wr_rd_mem_test extends apb_base_test;
  function new(string name="drt_wr_rd_mem_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

	uvm_config_db#(uvm_object_wrapper)::set(this,
											"env.i_agt.apb_sqr.main_phase",
											"default_sequence",
										    drt_wr_rd_mem_sequence::type_id::get());
  endfunction: build_phase
  `uvm_component_utils(drt_wr_rd_mem_test) 
endclass: drt_wr_rd_mem_test
`endif
