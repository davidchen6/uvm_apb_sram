`ifndef APB_BASE_SEQUENCE__SV
`define APB_BASE_SEQUENCE__SV

`include "./tb/defines/tb_defines.sv"

class apb_base_sequence extends uvm_sequence #(apb_transaction);

  `uvm_object_utils(apb_base_sequence)
  
  apb_transaction apb_tran;

  function new(string name="apb_base_sequence");
    super.new(name);
  endfunction: new

  virtual task body();

  endtask: body

endclass: apb_base_sequence
`endif

