//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_agent
// Description: UVM Agent object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_agent extends uvm_agent;
    `uvm_component_utils(pip_agent)
    
    // UVM agent components
    pip_driver       driver;
    pip_sequencer    sequencer;
    pip_monitor      monitor;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // only initialize driver+sequencer if agent is in Active mode
        if(get_is_active() == UVM_ACTIVE) begin
            driver = pip_driver::type_id::create("driver",this);
            sequencer = pip_sequencer::type_id::create("sequencer",this);
        end
        
        monitor = pip_monitor::type_id::create("monitor",this);
    endfunction : build_phase
    
    function void connect_phase(uvm_phase phase);
        if(get_is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction : connect_phase
endclass : pip_agent
