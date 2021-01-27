// Author: Stefan Bucur
// Class: id_scoreboard
// Description: UVM Scoreboard object for the instruction decoder testbench (id_env).

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "id_seq_item.sv"

class id_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(id_scoreboard)
    
    uvm_analysis_imp#(id_seq_item,id_scoreboard) item_collected_export;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
    endfunction : build_phase
    
    virtual function void write(id_seq_item pkt);
        $display("scoreboard:: pkt received");
        pkt.print();
    endfunction : write
    
endclass : id_scoreboard