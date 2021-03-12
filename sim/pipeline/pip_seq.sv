//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_seq
// Description: UVM Sequence object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_seq extends uvm_sequence#(pip_seq_item);

    `uvm_object_utils(pip_seq)

    function new(string name = "pip_seq");
        super.new(name);
    endfunction //new()

    virtual task body();
        /** this is what is executed on `uvm_do(item)
        // create pip_seq_item, req is a standard data member for UVM sequences
        req = pip_seq_item::type_id::create("req");
        // wait until next sequence was needed
        wait_for_grant();
        // sequence item randomization
        assert(req.randomize());
        // give sequence item to sequencer
        send_request(req);
        // wait until sequence item is processed
        wait_for_item_done();
        // get DUT output from driver->sequencer
        get_response(rsp);
        */
        `uvm_do(req)
    endtask

endclass : pip_seq