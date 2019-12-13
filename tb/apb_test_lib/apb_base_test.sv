`ifndef APB_BASE_TEST__SV
`define APB_BASE_TEST__SV

class apb_base_test extends uvm_test; 

  apb_env env;

  function new(string name="apb_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    $display({"build phase for: ", get_full_name()});
	super.build_phase(phase);
	env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  virtual function void report_phase(uvm_phase phase);
    uvm_report_server server;
	int err_num;
	
	super.report_phase(phase);
	server = get_report_server(); 
	err_num = server.get_severity_count(UVM_ERROR);

	if(err_num!=0) begin
	  $display("TEST CASE FAILED"); 
	end
	else begin
	  $display("TEST CASE PASSED");
	end
  endfunction: report_phase

  `uvm_component_utils(apb_base_test)
endclass: apb_base_test

`endif
