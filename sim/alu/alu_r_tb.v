//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur 
// Module: alu_r_tb
// Description: Simple Verilog testbench for the R-type ALU rv_alu_r.
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

`define NUM_RAND_TESTS 5
`define OP_ADD  4'b0_000
`define OP_SUB  4'b1_000
`define OP_SLL  4'b0_001
`define OP_SLT  4'b0_010
`define OP_SLTU 4'b0_011
`define OP_XOR  4'b0_100
`define OP_SRL  4'b0_101
`define OP_SRA  4'b1_101
`define OP_OR   4'b0_110
`define OP_AND  4'b0_111

module id_tb();
    
    reg unsigned    [31:0] rs1_in;
    reg unsigned    [31:0] rs2_in;
    reg             [2:0]  funct3;
    reg                    funct7_r;
    wire            [31:0] rd_out;
    wire            [3:0]  funct;

    assign funct = {funct7_r, funct3};

    integer seed;

    rv_alu_r DUT(
        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .funct3(funct3),
        .funct7_r(funct7_r),
        .rd_out(rd_out)
    );

    initial begin

        //////////////////////////////////////////////////////
        // Initialize variables, reset DUT
        //////////////////////////////////////////////////////
        seed = $random();
        rs1_in = 32'h0;
        rs2_in = 32'h0;
        funct  = 4'h0;
        
        $display("##########################");
        $display("##    rv_alu_r BEGIN    ##");
        $display("##########################");
        

        //////////////////////////////////////////////////////
        /*  Loop through all funct options and pass random
            values to rs1/rs2. based on funct, check if the
            operation was correctly performed.        
        */ 
        //////////////////////////////////////////////////////
        $display("-------- ALU TEST --------");
        $display("seed: %d\nrandom tests per operand:%d", seed,NUM_RAND_TESTS);
        
        for(funct = 4'b0_000; funct<=4'b1_111; funct++) begin
            repeat(NUM_RAND_TESTS) begin
            rs1_in = $urandom(seed);
            rs2_in = $urandom(seed);
                case(funct)
                    OP_ADD:  rd_out = rs1_signed + rs2_signed;
                    OP_SUB:  rd_out = rs1_signed - rs2_signed;
                    OP_SLL:  rd_out = rs1_in << rs2_in[4:0];
                    OP_SLT:  rd_out = (rs1_signed < rs2_signed) ? 1 : 0;
                    OP_SLTU: rd_out = (rs1_in < rs2_in) ? 1 : 0;
                    OP_XOR:  rd_out = rs1_in ^ rs2_in;
                    OP_SRL:  rd_out = rs1_in >> rs2_in[4:0];
                    OP_SRA:  rd_out = rs1_signed >>> rs2_signed[4:0];
                    OP_OR:   rd_out = rs1_in | rs2_in;
                    OP_AND:  rd_out = rs1_in & rs2_in;
                endcase
            end
        end

    end //initial


endmodule
