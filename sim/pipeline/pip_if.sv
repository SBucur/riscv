//////////////////////////////////////////////////////////////////////////////////
// RISC-V: pipeline interface
// Author: Stefan Bucur
// 
// Description: DUT interface for the UVM testbench
//////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"

interface pip_if(input clk, rst);

    logic [31:0] in_instr_mem;
    logic [31:0] in_data_mem;
    logic [31:0] out_pc;
    logic [31:0] out_alu;
    logic [31:0] out_instr;
    logic [31:0] out_data_mem;

    // restrict direction of signals for driver
    modport driver (
    input   in_instr_mem,
            in_data_mem,
            rst,
    output  out_pc,
            out_alu,
            out_instr,
            out_data_mem
    );

    // monitor does not drive anything, only reads DUT signals
    modport monitor (
    input   in_instr_mem,
            in_data_mem,
            rst,
            out_pc,
            out_alu,
            out_instr,
            out_data_mem
    );
    
    // * input/output skew values default, look into nailing down specific values
    // tb clocking inputs are DUT outputs + vice versa
    clocking cb @(posedge clk);
        output   in_instr_mem,
                in_data_mem;
        output negedge rst;
        input  out_pc,
                out_alu,
                out_instr,
                out_data_mem;
    endclocking

    // TODO: define task(s) that simulates accessing instruction/data memory; requires test memory module
    // task memRead_instr ();
    // endtask
    // task memRead_data();
    // endtask
    // task memWrite_data();
    // endtask

endinterface : pip_if
