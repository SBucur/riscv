import uvm_pkg::*;
`include "uvm_macros.svh"

module test_top();

    bit blk;
    bit rst;

    always #10 clk = ~clk;

    initial begin
        rst = 1;
        #5 rst = 0;
    end

    pip_if pipeline;

    top DUT(
        // add I/O
    );

    initial begin
        
        uvm_config_db #(virtual pip_if)::set(null,"*","pipeline_if",pipeline);

    end

endmodule