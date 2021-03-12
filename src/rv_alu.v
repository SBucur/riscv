//////////////////////////////////////////////////////////////////////////////////
// RISC-V: ALU Execution Pipeline Phase(EX)
// Author: Stefan Bucur
// 
// Description: rv_alu performs the operation requested in the IR. Submodules are created for each type of intruction (R,I,S,B,U,J)
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "rv_def.v"

module rv_alu(
    input  wire             clk,
    input  wire             rst,
    input  wire     [31:0]  id_ex_ir,
    input  wire     [31:0]  id_ex_pc,
    input  wire     [31:0]  id_ex_rs1,
    input  wire     [31:0]  id_ex_rs2,
    input  wire     [19:0]  id_ex_imm,
    input  wire     [2:0]   id_ex_funct3,
    input  wire     [6:0]   id_ex_funct7,
    output  reg     [31:0]  ex_mem_ir,
    output  reg     [31:0]  ex_mem_alu_out,
    output  reg     [31:0]  ex_mem_rs2,
    output  reg             ex_if_cond_br
);

    wire inv_a, inv_b;
    wire [31:0] mux_alu_r;
    wire [31:0] mux_alu_i;
    wire [31:0] mux_alu_s;
    wire [31:0] mux_alu_b;
    wire [31:0] mux_alu_u;
    wire [31:0] mux_alu_j;
    wire [6:0]  opcode;
    
    reg [31:0] mux_alu_out;

    assign opcode = id_ex_ir[6:0];

    // R-type ALU
    rv_alu_r alu_r(
        .rs1_in(id_ex_rs1),
        .rs2_in(id_ex_rs2),
        .funct3(id_ex_funct3),
        .funct7_r(id_ex_funct7[5]),
        .rd_out(mux_alu_r)
    );

    // I-type ALU
    rv_alu_i alu_i(
        .rs1_in(rs1_in),
        .imm_in(imm_in),
        .funct3(funct3),
        .funct7_r(id_ex_funct7[5]),
        .rd_out(mux_alu_i)
    );

    // TODO: add I,S,B,U,J ALU

    // push to MEM stage
    always @ (posedge clk or negedge rst) begin
        if(!rst) begin
            ex_mem_ir       <= 32'b0;
            ex_mem_alu_out  <= 32'b0;
            ex_mem_rs2      <= 32'b0;
        end
        else begin
            ex_mem_ir       <= id_ex_ir;
            ex_mem_alu_out  <= mux_alu_out;
            ex_mem_rs2      <= id_ex_rs2;
            ex_if_cond_br   <= 1'b0; // TODO: add branch logic
        end
    end // always

    // select the ALU output
    always @(*) begin
        case(opcode)
            `R_TYPE:    mux_alu_out = mux_alu_r;
            `I_TYPE:    mux_alu_out = mux_alu_i;
            // `S_TYPE:	mux_alu_out = mux_alu_s;
            // `B_TYPE:	mux_alu_out = mux_alu_b;
            // `U_TYPE:	mux_alu_out = mux_alu_u;
            // `J_TYPE:	mux_alu_out = mux_alu_j;
            // default to 0, opcode is illegal/not implemented
            default:    mux_alu_out = 32'b0;
        endcase
    end

endmodule // rv_alu