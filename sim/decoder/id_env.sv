// Author: Stefan Bucur
// Class: id_sequencer
// Description: UVM Environment object for the instruction decoder testbench (id_env).

import uvm_pkg::*;
`include "uvm_macros.svh"

class id_env extends uvm_env;
    `uvm_component_utils(id_env)
    
    id_agent agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = id_agent::type_id::create("agent", this);
    endfunction : build_phase

endclass : id_env