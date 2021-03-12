//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_seq_item
// Description: UVM Sequence Item object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

// TODO: add parameters for toggling Invalid instructions, different data coverage
class pip_seq_item extends uvm_sequence_item;

    typedef enum byte { 
        R_Type,
        I_Type,
        S_Type,
        B_Type,
        U_Type,
        J_Type,
        Invalid
    } OP_TYPE;
    
    rand OP_TYPE      opcode;
    rand logic [31:0] imm;
    rand logic [4:0]  rd;
    rand logic [4:0]  rs1;
    rand logic [4:0]  rs2;
    rand logic [4:0]  funct;

    rand bit op_valid;

    // field macros to register them to the database
    `uvm_object_utils_begin(pip_seq_item)
        `uvm_field_enum(OP_TYPE, opcode, UVM_ALL_ON)
        `uvm_field_int(imm, UVM_ALL_ON)
        `uvm_field_int(op_valid, UVM_ALL_ON)
        `uvm_field_int(rs1, UVM_ALL_ON|UVM_DEC)
        `uvm_field_int(rs2, UVM_ALL_ON|UVM_DEC)
    `uvm_object_utils_end

    function new(input string name = "pip_seq_item");
       super.new(name);
    endfunction : new

    // ? constraints can be improved to be more flexible
    constraint op_gencode {
        op_valid dist { 1:=99, 0:=1 };
        solve op_valid before opcode;
        if(!op_valid) opcode == Invalid;
        else opcode inside {R_Type, I_Type, S_Type, B_Type, U_Type, J_Type};
    };

    constraint rs_reg {
        rs1 dist { 0:=5, [1:31]:/95 };
        rs2 dist { 0:=5, [1:31]:/95 };
    };

    constraint imm_gen {
        imm dist { 0:=10, {imm != 0}:/90 };
    };

    // constraint funct_gen {
    //     if(op_valid) begin
    //         funct inside {};
    //     end
    // };

endclass : pip_seq_item
