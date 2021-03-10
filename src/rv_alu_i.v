//////////////////////////////////////////////////////////////////////////////////
// RISC-V: I-type ALU(EX)
// Author: Stefan Bucur
// 
// Description: implements (most) I-type instructions for the RV32I standard
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "rv_def.v"

module rv_alu_i(
    input unsigned [31:0] rs1_in,
    input unsigned [31:0] imm_in,
    input           [2:0] funct3,
    input                 funct7_r,
    output         [31:0] rd_out
);


    // parameter format is based off of the following concatenation:
    // {funct7[5], funct3}
    // ! Load/Store not implemented here, see rv_alu_ls.v
    localparam OP_ADDI  = 4'b0_000;
    localparam OP_SLLI  = 4'b0_001;
    localparam OP_SLTI  = 4'b0_010;
    localparam OP_SLTIU = 4'b0_011;
    localparam OP_XORI  = 4'b0_100;
    localparam OP_SRLI  = 4'b0_101;
    localparam OP_SRAI  = 4'b1_101;
    localparam OP_ORI   = 4'b0_110;
    localparam OP_ANDI  = 4'b0_111;

    wire signed [31:0]  rs1_signed;
    wire signed [31:0]  imm_signed;
    wire        [3:0]   funct;    

    // force implication of signed arithmatic
    assign rs1_signed   = rs1_in;
    assign imm_signed   = imm_in;
    // concatenate funct3,7
    assign funct        = {funct7_r, funct3};

    // certain instructions require inverting a and/or b before calculating

    always @(*) begin
        rd_out = 32'h0;
        case (funct)
            OP_ADDI:  rd_out = rs1_signed + imm_signed;
            // only use rs2_signed[4:0] for bit shifts becuase bit shifts >32 == bit shifts %32
            OP_SLLI:  rd_out = rs1_in << imm_in[4:0];
            OP_SLTI:  rd_out = (rs1_signed < imm_signed) ? 1 : 0;
            OP_SLTIU: rd_out = (rs1_in < imm_in) ? 1 : 0;
            OP_XORI:  rd_out = rs1_in ^ imm_in;
            OP_SRLI:  rd_out = rs1_in >> imm_in[4:0];
            OP_SRAI:  rd_out = rs1_signed >>> imm_signed[4:0];
            OP_ORI:   rd_out = rs1_in | imm_in;
            OP_ANDI:  rd_out = rs1_in & imm_in;
            // default to 0, funct/opcode is illegal/not implemented
            default: rd_out = 32'h0;
        endcase
    end

endmodule // rv_alu_r

// TODO: add overflow detection