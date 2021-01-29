//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_sequencer
// Description: UVM Sequencer object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_sequencer extends uvm_sequencer;
    `uvm_component_utils(pip_sequencer)

    function new(string name = "pip_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction //new()
endclass : pip_sequencer