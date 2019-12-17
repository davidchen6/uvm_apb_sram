`ifndef APB_COV__SV
`define APB_COV__SV

class apb_cov extends uvm_component;
   `uvm_component_utils(apb_cov)
   apb_transaction cov_tr;
   uvm_blocking_get_port #(apb_transaction) cov_port;
//   uvm_blocking_put_imp #(my_transaction, my_cov) cov_imp;

   covergroup apb_fcov;
       COV_pwrite: coverpoint cov_tr.pwrite{
         bins a_cp = {0};
	     bins b_cp = {1};
       }
       COV_paddr: coverpoint cov_tr.paddr[5:0]{
         //bins a = {[0:127]};
         //bins b = {[130:227]};
         //bins c = {[228:255]};
       }
       COV_pwdata: coverpoint cov_tr.pwdata{
         bins a_cp = {[0:32'h55555554]};
         bins b_cp = {32'h55555555};
         bins c_cp = {[32'h55555556:32'haaaaaaa9]};
		 bins d_cp = {32'haaaaaaaa};
		 bins other_cp = {[32'haaaaaaab:32'hffffffff]};
       }
       WRxRD: cross COV_pwrite, COV_paddr;
       WRxDATA: cross COV_paddr, COV_pwdata;
   endgroup

   function new(string name = "apb_cov",uvm_component parent);
       super.new(name,parent);
       apb_fcov = new();
   endfunction

   virtual function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       cov_port = new("cov_port",this);
       //cov_imp = new("cov_imp",this);
   endfunction

   function void sample();
       apb_fcov.sample();
   endfunction

   task main_phase(uvm_phase phase);
       $display({"main phase for: ", get_full_name()});
	   while(1)begin
           cov_port.get(cov_tr);
		   `uvm_info("apb_cov", "start to sample", UVM_LOW);
           sample();
       end
   endtask
endclass
`endif

