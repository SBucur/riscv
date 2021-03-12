//////////////////////////////////////////////////////////////////////////////////
// RISC-V: pipeline test
// Author: Stefan Bucur
// 
// Description: uvm_test module for the UVM testbench
//////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_test extends uvm_test;

    `uvm_component_utils(pip_test)

    pip_env inst_env;
    pip_seq inst_sequence;

    function new(string name="pip_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        inst_env = pip_env::type_id::create("inst_env", this);
        inst_sequence = pip_seq::type_id::create("inst_sequence");
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        inst_sequence.start(inst_env.inst_agent.inst_sequencer);
    endtask : run_phase

endclass : pip_test