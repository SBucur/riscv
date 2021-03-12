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
    pip_driver       inst_driver;
    pip_sequencer    inst_sequencer;
    pip_monitor      inst_monitor;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // only initialize driver+sequencer if agent is in Active mode
        if(get_is_active() == UVM_ACTIVE) begin
            inst_driver = pip_driver::type_id::create("inst_driver",this);
            inst_driver.build_phase(phase);
            inst_sequencer = pip_sequencer::type_id::create("inst_sequencer",this);
            inst_sequencer.build_phase(phase);
        end
        
        inst_monitor = pip_monitor::type_id::create("inst_monitor",this);
        inst_monitor.build_phase(phase);
    endfunction : build_phase
    
    function void connect_phase(uvm_phase phase);
        if(get_is_active == UVM_ACTIVE) begin
            inst_driver.seq_item_port.connect(inst_sequencer.seq_item_port);
            p_driver.res_port.connect(inst_sequencer.res_port);
        end
    endfunction : connect_phase
endclass : pip_agent
