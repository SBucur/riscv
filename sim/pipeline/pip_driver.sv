//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_driver
// Description: UVM Driver object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "pip_seq_item.sv"

`define DRIV_IF vif.DRIVER.driver_cb

class pip_driver extends uvm_driver#(pip_seq_item);
    
    virtual pip_if vif;                                  // reminder: make virtual interface pip_if
    `uvm_component_utils(pip_driver)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual pip_if)::get(this,"","vif",vif))
            `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction : build_phase
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.item_done();
        end // forever
    endtask : run_phase
    
    
    // driving logic for run_phase 
    virtual protected task drive();
        req.print();
        // finish driving logic
    endtask : drive
    
endclass : pip_driver
