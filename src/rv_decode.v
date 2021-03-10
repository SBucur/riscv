//////////////////////////////////////////////////////////////////////////////////
// RISC-V: Instruction Decode Pipeline Phase(ID)
// Author: Stefan Bucur
// 
// Description: rv_decode contains the ID/EX pipeline registers to be
// carried over to the Execution phase (EX).
// rv_decode also contains the RV32 register file.
// * last testbench result: PASS
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module rv_decode (
    input   wire           clk,
    input   wire           rst,
    input   wire    [31:0] if_id_ir,
    input   wire    [31:0] if_id_pc,
    input   wire    [31:0] mem_wb_ir,
    input   wire    [31:0] mem_wb_out,
    output  reg     [31:0] id_ex_ir,
    output  reg     [31:0] id_ex_pc,
    output  reg     [31:0] id_ex_rs1,
    output  reg     [31:0] id_ex_rs2,
    output  reg     [19:0] id_ex_imm,
    output  reg     [2:0]  id_ex_funct3,
    output  reg     [6:0]  id_ex_funct7
);

    // The RV32 Register File. regfile[0] must always return 32'h0
    reg [31:0] regfile [31:0];

    // rd from MEM/WB instruction
    wire [6:0] mem_wb_rd = mem_wb_ir[11:7];

    // outputs for rv_decode_instr
    wire [19:0] imm_decode;
    wire [6:0]  op_decode;
    wire [6:0]  rd_decode;
    wire [4:0]  rs1_decode;
    wire [4:0]  rs2_decode;
    wire [2:0]  funct3_decode;
    wire [6:0]  funct7_decode;

    rv_decode_instr rdi(
        .instr_i(if_id_ir),
        .opcode(op_decode),
        .imm(imm_decode),
        .rd(rd_decode),
        .rs1(rs1_decode),
        .rs2(rs2_decode),
        .funct3(funct3_decode),
        .funct7(funct7_decode)
    );

    // push decoded values to ID/EX registers
    always @ (posedge clk or negedge rst) begin
        if(!rst) begin
            id_ex_ir    <= 32'b0;
            id_ex_pc    <= 32'b0;
            id_ex_rs1   <= 5'b0;
            id_ex_rs2   <= 5'b0;
            id_ex_imm   <= 32'b0;
            funct3      <= 3'b0;
            funct7      <= 7'b0;
        end
        else begin
            id_ex_ir    <= if_id_ir;
            id_ex_pc    <= if_id_pc;
            id_ex_rs1   <= regfile[rs1_decode];
            id_ex_rs2   <= regfile[rs2_decode];
            id_ex_imm   <= imm_decode;
            funct3      <= funct3_decode;
            funct7      <= funct7_decode;
        end
    end // always

    
    // update regfile
    // regfile[0] must always return 32'h0
    integer i;
    always @ (posedge clk or negedge rst) begin
        if(!rst) begin
            for(i=0;i<32;i=i+1) begin
                regfile[i] <= 32'b0;
            end
        end
        else begin
            if(mem_wb_rd != 0) begin
                regfile[mem_wb_rd] <= mem_wb_out;
            end
            else begin
                regfile[0] <= 0;
            end
        end
    end // always

endmodule // rv_decode
