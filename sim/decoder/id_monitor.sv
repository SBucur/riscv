// Author: Stefan Bucur
// Class: id_monitor
// Description: UVM Monitor object for the instruction decoder testbench (id_env).

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "id_seq_item.sv"

class id_monitor extends uvm_monitor;
    
    `uvm_component_utils(id_monitor)
    
    virtual id_if vif;
    uvm_analysis_port#(id_seq_item) item_collected_port;
    id_seq_item trans_collected;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
        trans_collected = new();
        item_collected_port = new("item_collected_port", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual id_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        item_collected_port.write(trans_collected);
    endtask : run_phase
    
endclass : id_monitor
