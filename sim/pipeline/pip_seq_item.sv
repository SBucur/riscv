//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_seq_item
// Description: UVM Sequence Item object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

class pip_seq_item extends uvm_sequence_item;

    //add variables
    typedef enum int { 
        R_TYPE,
        I_TYPE,
        S_TYPE,
        B_TYPE,
        U_TYPE,
        J_TYPE,
        INVALID
    } OP_TYPE;
    
    rand OP_TYPE opcode;
    rand logic [31:0] imm;

    rand bit OPCODE_VALID;

    // field macros to register them to the database
    `uvm_object_utils_begin(pip_seq_item)
        `uvm_field_int(opcode, UVM_ALL_ON)
        `uvm_field_int(imm, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(input string name = "pip_seq_item");
       super.new(name);
    endfunction //new()

    //add constraints
    constraint op_valid { OPCODE_VALID dist { 1:=99, 0:=1 } };
    constraint op_gencode {
        if(!OPCODE_VALID) begin
            opcode = INVALID;
        end
        else begin
            opcode inside {R_TYPE, I_TYPE, S_TYPE, B_TYPE, U_TYPE, J_TYPE};
        end
    };

    solve OPCODE_VALID before opcode;


endclass : pip_seq_item