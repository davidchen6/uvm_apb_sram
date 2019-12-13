`ifndef APB_SCOREBOARD__SV
`define APB_SCOREBOARD__SV

`include "./tb/defines/tb_defines.sv"

class apb_scoreboard extends uvm_scoreboard;

//  apb_transaction expect_queue[$];
  uvm_blocking_get_port #(apb_transaction)  exp_port;
  uvm_blocking_get_port #(apb_transaction)  act_port;
  uvm_analysis_port #(apb_transaction)  rd_port;
  `uvm_component_utils(apb_scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
endclass

function void apb_scoreboard::build_phase(uvm_phase phase);
  int i;
  $display({"build phase for: ", get_full_name()});
  super.build_phase(phase);
  exp_port = new("exp_port", this);
  act_port = new("act_port", this);
  rd_port = new("rd_port", this);
endfunction

task apb_scoreboard::main_phase(uvm_phase phase);
  apb_transaction get_actual, get_expect, tmp_tr;

  super.main_phase(phase);
  get_actual = new();
  get_expect = new();
  tmp_tr = new();
  while(1)begin
    act_port.get(tmp_tr);
    get_actual.copy(tmp_tr) ;
    if(tmp_tr.pwrite==0) begin
	  `uvm_info("apb_scoreboard", "send tr to mdl", UVM_LOW);
      rd_port.write(tmp_tr);
	  $display("tmp_tr.prdata is %0h in addr: %0d", tmp_tr.prdata, tmp_tr.paddr);

      exp_port.get(get_expect);
	  `uvm_info("apb_scoreboard", "get tr from mdl", UVM_LOW);
	  $display("get_expect.prdata is %0h in addr: %0d", get_expect.prdata, get_expect.paddr);
	  $display("get_actual.prdata is %0h in addr: %0d", get_actual.prdata, get_actual.paddr);
      if((get_expect.paddr == get_actual.paddr)&&(get_expect.prdata == get_actual.prdata)) begin
        `uvm_info("apb_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
      end
      else begin
        `uvm_error("apb_scoreboard", "Compare FAILED");
        $display("the expect pkt is");
        get_expect.print();
        $display("the actual pkt is");
        get_actual.print();
      end
    end
  end

endtask
`endif
