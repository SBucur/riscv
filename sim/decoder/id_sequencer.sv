// Author: Stefan Bucur
// Class: id_sequencer
// Description: UVM Sequencer object for the instruction decoder testbench (id_env).

import uvm_pkg::*;
`include "uvm_macros.svh"

class id_sequencer extends uvm_sequencer;
    `uvm_component_utils(id_sequencer)

    function new(string name = "id_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction //new()
endclass : id_sequencer