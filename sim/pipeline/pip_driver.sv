//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur
// Class: pip_driver
// Description: UVM Driver object for the pipeline testbench (pip_env).
//////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"

`define INTF vif.DRIVER.driver_cb

class pip_driver extends uvm_driver#(pip_seq_item);
    
    virtual pip_if vif;
    
    `uvm_component_utils(pip_driver)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual pip_if)::get(this,"","vif",vif))
            `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction : build_phase
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.item_done();
        end // forever
    endtask : run_phase
    
    
    // driving logic for run_phase 
    virtual protected task drive();
        req.print();
        // finish driving logic
        // clk driving logic alrady defined in clocking block in pip_if.sv
        case(req.opcode)
            req.OP_TYPE.R_Type: begin
                `INTF.rst <= 1'b1;
                `INTF.in_instr_mem <= {
                    {1'b0, req.funct[4], 5'b0},
                    req.rs2,
                    req.rs1,
                    req.funct[3:0],
                    req.rd,
                    7'b011_0011
                };
                $display("Operation: R_Type x%d,x%d,x%d", req.rd, req.rs1, req.rs2);
                `INTF.in_data_mem <= 32'h0;
            end
            default: begin
                `INTF.rst <= 1'b1;
                `INTF.in_instr_mem <= 32'h0;
                `INTF.in_data_mem <= 32'h0;
            end
        endcase
        $display("Instruction: %h", `INTF.in_instr_mem);
        $display("-------------------------------------------------------");
    endtask : drive
    
endclass : pip_driver
