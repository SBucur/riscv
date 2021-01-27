// Author: Stefan Bucur
// Class: id_agent
// Description: UVM Agent object for the instruction decoder testbench (id_env).

import uvm_pkg::*;
`include "uvm_macros.svh"

class id_agent extends uvm_agent;
    `uvm_component_utils(id_agent)
    
    // UVM agent components
    id_driver       driver;
    id_sequencer    sequencer;
    id_monitor      monitor;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // only initialize driver+sequencer if agent is in Active mode
        if(get_is_active() == UVM_ACTIVE) begin
            driver = id_driver::type_id::create("driver",this);
            sequencer = id_sequencer::type_id::create("sequencer",this);
        end
        
        monitor = id_monitor::type_id::create("monitor",this);
    endfunction : build_phase
    
    function void connect_phase(uvm_phase phase);
        if(get_is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction : connect_phase
endclass : id_agent
