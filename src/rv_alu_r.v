//////////////////////////////////////////////////////////////////////////////////
// RISC-V: R-type ALU(EX)
// Author: Stefan Bucur
// 
// Description: implements all R-type instructions for the RV32I standard
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "rv_def.v"

module rv_alu_r(
    input unsigned [31:0] rs1_in,
    input unsigned [31:0] rs2_in,
    input           [2:0] funct3,
    input                 funct7_r,
    output         [31:0] rd_out
);


    // parameter format is based off of the following concatenation:
    // {funct7[5], funct3}
    localparam OP_ADD  = 4'b0_000;
    localparam OP_SUB  = 4'b1_000;
    localparam OP_SLL  = 4'b0_001;
    localparam OP_SLT  = 4'b0_010;
    localparam OP_SLTU = 4'b0_011;
    localparam OP_XOR  = 4'b0_100;
    localparam OP_SRL  = 4'b0_101;
    localparam OP_SRA  = 4'b1_101;
    localparam OP_OR   = 4'b0_110;
    localparam OP_AND  = 4'b0_111;

    wire signed [31:0]  rs1_signed;
    wire signed [31:0]  rs2_signed;
    wire        [3:0]   funct;    

    // force implication of signed arithmatic
    assign rs1_signed   = rs1_in;
    assign rs2_signed   = rs2_in;
    // concatenate funct3,7
    assign funct        = {funct7_r, funct3};

    // certain instructions require inverting a and/or b before calculating

    always @(*) begin
        rd_out = 32'h0;
        case (funct)
            OP_ADD:  rd_out = rs1_signed + rs2_signed;
            OP_SUB:  rd_out = rs1_signed - rs2_signed;
            // only use rs2_signed[4:0] for bit shifts becuase bit shifts >32 == bit shifts %32
            OP_SLL:  rd_out = rs1_in << rs2_in[4:0];
            OP_SLT:  rd_out = (rs1_signed < rs2_signed) ? 1 : 0;
            OP_SLTU: rd_out = (rs1_in < rs2_in) ? 1 : 0;
            OP_XOR:  rd_out = rs1_in ^ rs2_in;
            OP_SRL:  rd_out = rs1_in >> rs2_in[4:0];
            OP_SRA:  rd_out = rs1_signed >>> rs2_signed[4:0];
            OP_OR:   rd_out = rs1_in | rs2_in;
            OP_AND:  rd_out = rs1_in & rs2_in;
            // default to 0, funct/opcode is illegal/not implemented
            default: rd_out = 32'h0;
        endcase
    end

endmodule // rv_alu_r

// TODO: add overflow detection