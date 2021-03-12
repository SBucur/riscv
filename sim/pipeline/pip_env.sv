//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_sequencer
// Description: UVM Environment object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_env extends uvm_env;
    `uvm_component_utils(pip_env)
    
    pip_agent inst_agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        inst_agent = pip_agent::type_id::create("inst_agent", this);
    endfunction : build_phase

endclass : pip_env