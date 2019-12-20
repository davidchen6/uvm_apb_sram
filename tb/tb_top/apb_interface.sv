`ifndef APB_INTERFACE__SV
`define APB_INTERFACE__SV

`include "tb_defines.sv"
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
	//psel && !pwrite && paddr!=32'bx |=> penable;
	psel && !pwrite |=> penable ##[1:3] pready |=> !penable |-> !psel;
  endproperty

  // apb_write transfer seq check
  property apb_write_seq_prop;
    @(posedge clk) disable iff(!rst_n)
	psel && pwrite |=> penable ##[1:3] pready |=> !penable |-> !psel;//psel && pwrite && paddr!='bx |=> penable |=>##2 pready |=> !penable |-> !psel;
  endproperty
  
  //apb_read error check
  property read_error_prop;
    @(posedge clk) disable iff(!rst_n)
	psel && !pwrite && (paddr>=`APB_SRAM_SIZE)|=> penable ##[1:3] pready |-> pslverr |=> !penable |-> !psel;
  endproperty

  //apb_write error check
  property write_error_prop;
    @(posedge clk) disable iff(!rst_n)
	psel && pwrite && (paddr>=`APB_SRAM_SIZE)|=> penable ##[1:3] pready |-> pslverr |=> !penable |-> !psel;
  endproperty

  // property check assertions
  apb_read: assert property(apb_read_seq_prop);
  apb_write: assert property(apb_write_seq_prop);
  read_error: assert property(read_error_prop);
  write_error: assert property(write_error_prop);

endinterface

`endif
