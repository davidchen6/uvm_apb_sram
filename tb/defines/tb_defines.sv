`ifndef TB_DEFINES__SV
`define TB_DEFINES__SV

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name: tb_defines.sv
// Author: CCW
// Email: chengjiuweiye8@163.com
// Revision: 0.1
// Description: Contains testbench define Macros
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`define ADDR_WIDTH 32				 // APB PADDR BUS width
`define DATA_WIDTH 32				 // APB PWDATA and PRDATA Bus width
`define APB_CLK_FREQ_MHZ 100		 // 100MHz clock frequency for APB
`define APB_SRAM_SIZE 64		     // Size of memory in SRAM
`define APB_SRAM_MEM_BLOCK_SIZE 32   // Memory block size in SRAM
`define APB_SRAM_RESET_VAL 0         //SRAM_RESET_VALUE
// defines to be overwriten by command line defines
`define APB_SLV_WAIT_FUNC_EN 1       //enable APB SLV wait function
`ifndef APB_SLV_WAIT_FUNC_EN
  `define APB_SLV_WAIT_FUNC_EN 0  // APB slave wait delay insertion
`endif
`ifndef APB_SLV_MIN_WAIT_CYC         
  `define APB_SLV_MIN_WAIT_CYC 1  // Minimum slave wait delay cycle
`endif
`ifndef APB_SLV_MAX_WAIT_CYC
  `define APB_SLV_MAX_WAIT_CYC 2  // Minimum slave wait delay cycle
`endif 

`endif
