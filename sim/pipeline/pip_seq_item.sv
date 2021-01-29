// Author: Stefan Bucur
// Class: pip_seq_item
// Description: UVM Sequence Item object for the pipeline testbench (pip_env).

import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_seq_item extends uvm_sequence_item;

    //add variables

    // field macros to register them to the database
    `uvm_object_utils_begin(pip_seq_item)
        //`uvm_field_int(<VAR>, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(input string name = "pip_seq_item");
       super.new(name);
    endfunction //new()

    //add constraints


endclass : pip_seq_item