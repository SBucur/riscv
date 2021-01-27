// Author: Stefan Bucur
// Class: id_seq_item
// Description: UVM Sequence Item object for the instruction decoder testbench (id_env).

import uvm_pkg::*;
`include "uvm_macros.svh"

class id_seq_item extends uvm_sequence_item;

    rand bit [31:0] if_id_ir;
    rand bit [31:0] if_id_pc;
    rand bit [31:0] mem_wb_ir;
    rand bit [31:0] mem_wb_out;

    bit [31:0] id_ex_ir;
    bit [31:0] id_ex_pc;
    bit [31:0] id_ex_rs1;
    bit [31:0] id_ex_rs2;
    bit [31:0] id_ex_imm;

    // field macros to register them to the database
    `uvm_object_utils_begin(id_seq_item)
        `uvm_field_int(if_id_ir, UVM_ALL_ON)
        `uvm_field_int(if_id_pc, UVM_ALL_ON)
        `uvm_field_int(mem_wb_ir, UVM_ALL_ON)
        `uvm_field_int(mem_wb_out, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(input string name = "id_seq_item");
       super.new(name);
    endfunction //new()

    //add constraints


endclass : id_seq_item