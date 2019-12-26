`timescale 1ns/1ps
// include and import uvm_pkg
//`include "uvm_macros.svh"
import uvm_pkg::*;
`include "tb_defines.sv"
`include "apb_interface.sv"
//`include "./tb/agents/apb_mstr_agent/apb_transaction.sv"
//`include "./tb/agents/apb_mstr_agent/apb_mstr_driver.sv"
`include "apb_agent_pkg.sv"
`include "apb_env_pkg.sv"
`include "apb_test_pkg.sv"

import apb_test_pkg::*;

module tb_top;
  // clock declaration
  bit clk;
  bit rst_n;
  
  apb_inf apb_sram_if(clk, rst_n);

  apb_v3_sram #( // parameters
			.ADDR_BUS_WIDTH(`ADDR_WIDTH),					// ADDR_BUS_WIDTH
			.DATA_BUS_WIDTH(`DATA_WIDTH),                   // DATA_BUS_WIDTH
			.MEMSIZE(`APB_SRAM_SIZE),						// RAM_SIZE
			.MEM_BLOCK_SIZE(`APB_SRAM_MEM_BLOCK_SIZE),      //MEM_BLOCK_SIZE
			.RESET_VAL(`APB_SRAM_RESET_VAL),									// RESET_VALUE
			.EN_WAIT_DELAY_FUNC(`APB_SLV_WAIT_FUNC_EN),		// Enable Slv wait state
			.MIN_RAND_WAIT_CYC(`APB_SLV_MIN_WAIT_CYC),		// Min Slv wait delay in clock cycles
			.MAX_RAND_WAIT_CYC(`APB_SLV_MAX_WAIT_CYC)		// Max Slv wait delay
		)dut(
			.PCLK(apb_sram_if.clk),
			.PRESETn(apb_sram_if.rst_n),
			.PSEL(apb_sram_if.psel),
			.PENABLE(apb_sram_if.penable),
			.PWRITE(apb_sram_if.pwrite),
			.PADDR(apb_sram_if.paddr),
			.PWDATA(apb_sram_if.pwdata),
			.PRDATA(apb_sram_if.prdata),
			.PREADY(apb_sram_if.pready),
			.PSLVERR(apb_sram_if.pslverr));

  initial begin
    uvm_config_db#(virtual apb_inf)::set(uvm_root::get(), "*", "vif", apb_sram_if);
	$display(" clk is %0dMHz", (1000/((0.5/(`APB_CLK_FREQ_MHZ*1000000)) * 1s*2)));
  end


  always #100 clk = ~clk;
  //always #((0.5/(`APB_CLK_FREQ_MHZ*1000000)) * 1s) clk_100MHz = ~clk_100MHz;
  initial begin
    rst_n = 0;
    #1000 rst_n = 1;
  end


  initial begin
    run_test();
  end

  initial begin
    //$dumpfile("top_tb.vcd");
    //$dumpvars(0, top_tb);
    $fsdbDumpfile("test.fsdb");
    $fsdbDumpvars(0,tb_top);
    $fsdbDumpon;
	$fsdbDumpSVA;//
  end
//produce VCS DVE waveform
  initial begin
    $vcdpluson;
  end

endmodule





