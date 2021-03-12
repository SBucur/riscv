import uvm_pkg::*;
`include "uvm_macros.svh"

module test_top();

    bit clk;
    bit rst;

    initial begin
        rst = 1;
        #5 rst = 0;
    end

    pip_if pipeline(clk, rst);

    dut_dummy DUT(
        .clk(pipeline.clk),
        .rst(pipeline.rst),
        .in_instr(pipeline.in_instr_mem),
        .in_data(pipeline.in_data_mem),
        .pc(pipeline.out_pc),
        .alu_out(pipeline.out_alu),
        .out_instr(pipeline.out_instr),
        .out_data(pipeline.out_data_mem)
    );

    initial begin
        uvm_config_db #(virtual pip_if)::set(null,"*","vif",pipeline);
    end

endmodule