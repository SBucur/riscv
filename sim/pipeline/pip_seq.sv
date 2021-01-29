//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_seq
// Description: UVM Sequence object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "pip_seq_item.sv"

class pip_seq extends uvm_sequence#(pip_seq_item);

    `uvm_object_utils(pip_sequencer)

    function new(string name = "pip_seq");
        super.new(name);
    endfunction //new()

    virtual task body();
        req = pip_seq_item::type_id::create("req");
        wait_for_grant();
        assert(req.randomize());
        send_request(req);
        wait_for_item_done();
        get_response(rsp);
    endtask

endclass : pip_seq