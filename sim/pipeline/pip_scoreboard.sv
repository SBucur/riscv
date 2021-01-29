// Author: Stefan Bucur
// Class: pip_scoreboard
// Description: UVM Scoreboard object for the instruction decoder testbench (pip_env).

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "pip_seq_item.sv"

class pip_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(pip_scoreboard)
    
    uvm_analysis_imp#(pip_seq_item,pip_scoreboard) item_collected_export;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
    endfunction : build_phase
    
    virtual function void write(pip_seq_item pkt);
        $display("scoreboard:: pkt received");
        pkt.print();
    endfunction : write
    
endclass : pip_scoreboard