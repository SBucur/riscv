// Author: Stefan Bucur
// Class: id_seq
// Description: UVM Sequence object for the instruction decoder testbench (id_env).

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "id_seq_item.sv"

class id_seq extends uvm_sequence#(id_seq_item);

    `uvm_object_utils(id_sequencer)

    function new(string name = "id_seq");
        super.new(name);
    endfunction //new()

    virtual task body();
        req = id_seq_item::type_id::create("req");
        wait_for_grant();
        assert(req.randomize());
        send_request(req);
        wait_for_item_done();
        get_response(rsp);
    endtask

endclass : id_seq