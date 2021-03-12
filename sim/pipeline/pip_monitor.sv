//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_monitor
// Description: UVM Monitor object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_monitor extends uvm_monitor;
    
    `uvm_component_utils(pip_monitor)
    
    virtual pip_if vif;
    uvm_analysis_port#(pip_seq_item) item_collected_port;
    pip_seq_item rsp_received;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
        rsp_received = new();
        item_collected_port = new("item_collected_port", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual pip_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        item_collected_port.write(rsp_received);
    endtask : run_phase
    
endclass : pip_monitor
