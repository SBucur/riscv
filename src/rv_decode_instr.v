`timescale 1ns/1ps

// opcode mappings
`define R_TYPE 7'b011_0011
`define I_TYPE 7'b000_0011, 7'b001_0011
`define S_TYPE 7'b010_0011
`define B_TYPE 7'b110_0011
`define U_TYPE 7'b011_0111, 7'b001_0111
`define J_TYPE 7'b110_1111, 7'b110_0111

module rv_decode_instr (
    input   wire [31:0] instr_i,
    output  wire [6:0]  opcode,
    output  wire [19:0] imm,
    output  wire [6:0]  rd,
    output  wire [4:0]  rs1,
    output  wire [4:0]  rs2,
    output  wire [2:0]  funct3,
    output  wire [6:0]  funct7
);
    
    reg [19:0] imm_comb;
    
    assign opcode   = instr_i[6:0];
    assign imm      = imm_comb;
    assign rd       = instr_i[11:7];
    assign rs1      = instr_i[19:15];
    assign rs2      = instr_i[24:20];
    assign funct3   = instr_i[14:12];
    assign funct7   = instr_i[31:25];

    always @(*) begin
        imm_comb = 20'b0;
        case(opcode)
            `R_TYPE:    imm_comb = 20'b0;
            `I_TYPE:    imm_comb = {8'h0, instr_i[31:20]};
            `S_TYPE:	imm_comb = {8'h0, instr_i[31:25], instr_i[11:7]};
            `B_TYPE:	imm_comb = {8'h0, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};
            `U_TYPE:	imm_comb = {instr_i[31:12]};
            `J_TYPE:	imm_comb = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21]};
            // default to 0, opcode is illegal
            default:    imm_comb = 20'b0;
        endcase
    end
endmodule // rv_decode_instr