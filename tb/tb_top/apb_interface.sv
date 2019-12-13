`ifndef APB_INTERFACE__SV
`define APB_INTERFACE__SV

`include "./tb/defines/tb_defines.sv"
interface apb_inf(input logic clk, rst_n);

  logic psel;
  logic penable;
  logic pwrite;
  logic [`ADDR_WIDTH-1:0] paddr;
  logic [`DATA_WIDTH-1:0] pwdata;
  logic [`DATA_WIDTH-1:0] prdata;
  logic pready;
  logic pslverr;

  ///////// property check assertions ///////
  // apb_read transfer seq check
  property apb_read_seq_prop;
    @(posedge clk) disable iff(!rst_n)
	psel && !pwrite && paddr!='bx |=> penable ##[1:$] pready ##1 !penable |-> !psel;
  endproperty

  // apb_write transfer seq check
  property apb_write_seq_prop;
    @(posedge clk) disable iff(!rst_n)
	psel && pwrite && paddr!='bx |=> penable ##[1:$] pready ##1 !penable |-> !psel;
  endproperty

  // property check assertions
  assert property(apb_read_seq_prop);
  assert property(apb_write_seq_prop);

endinterface

`endif
