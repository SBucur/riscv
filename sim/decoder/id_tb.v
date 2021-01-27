//////////////////////////////////////////////////////////////////////////////////
// Author: Stefan Bucur 
// Module Name: id_tb
// Description: Simple Verilog testbench for the instruction decode module rv_decode.
// Additional Comments: Might migrate to using verilog testbenching for smaller components,
//  only moving to UVM once the whole pipeline is made.
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

// bit ranges of the instruction arguments
`define IR_RST  if_id_ir = 32'b0;
`define OPCODE  if_id_ir[6:0]
`define RS1     if_id_ir[19:15]
`define RS2     if_id_ir[24:20]
`define RD      if_id_ir[11:7]
`define IMM_R   if_id_ir[31:7]
`define IMM_I   if_id_ir[31:20]
`define IMM_S   {if_id_ir[31:25], if_id_ir[11:7]}
`define IMM_B   {if_id_ir[31], if_id_ir[7], if_id_ir[30:25], if_id_ir[11:8]}
`define IMM_U   if_id_ir[31:12]
`define IMM_J   {if_id_ir[31], if_id_ir[19:12], if_id_ir[20], if_id_ir[30:21]}
`define RD_WB   mem_wb_ir[11:7]

module id_tb();
    
    reg clk, rst;
    reg [31:0] if_id_ir;
    reg [31:0] if_id_pc;
    reg [31:0] mem_wb_ir;
    reg [31:0] mem_wb_out;
    wire [31:0] id_ex_ir;
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_rs1;
    wire [31:0] id_ex_rs2;
    wire [19:0] id_ex_imm;

    rv_decode DUT(
        .clk(clk),
        .rst(rst),
        .if_id_ir(if_id_ir),
        .if_id_pc(if_id_pc),
        .mem_wb_ir(mem_wb_ir),
        .mem_wb_out(mem_wb_out),
        .id_ex_ir(id_ex_ir),
        .id_ex_pc(id_ex_pc),
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .id_ex_imm(id_ex_imm)
    );

    // 10ns period clock cycle
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end //always

    initial begin

        //////////////////////////////////////////////////////
        // Initialize variables, reset DUT
        //////////////////////////////////////////////////////
                        rst = 1'b1;
        #1              rst = 1'b0;
        //NOP
        if_id_ir = 32'h0;
        if_id_pc = 32'h0;
        mem_wb_ir = 32'h0;
        mem_wb_out = 32'h0;

        @(posedge clk) rst = 1'b1;
        
        $display("##########################");
        $display("##   rv_decode BEGIN    ##");
        $display("##########################");
        

        //////////////////////////////////////////////////////
        // Test ID/EX imm to see if it extracts the entire immediate.
        // id_ex_imm should have all 1's from the imm field
        //  in the ID/EX IR.
        //////////////////////////////////////////////////////
        $display("-------- IMM_TEST --------");
        //I-type
        #1 if_id_pc = if_id_pc + 4;                             // next instruction fetch
        `OPCODE     = 7'b000_0011;                              // set opcode for specific type
        `IMM_I      = 12'hfff;                                  // imm field = all 1's
        @(posedge clk);                                         // flip-flop write
        #1 if(id_ex_imm == 20'hfff) $display("I_IMM: PASS");    // sign-extended imm
        else $display("I_IMM: FAIL");
        `IR_RST;                                                // clear IR

        //R-type
        if_id_pc = if_id_pc + 4;
        `OPCODE     = 7'b011_0011;
        `IMM_R      = 25'b1_1111_1111_1111_1111_1111_1111;
        @(posedge clk);
        #1 if(id_ex_imm == 20'h0) $display("R_IMM: PASS");
        else $display("R_IMM: FAIL");
        `IR_RST;
        
        //S-type
        if_id_pc = if_id_pc + 4;
        `OPCODE     = 7'b010_0011;
        `IMM_S      = 12'hfff;
        @(posedge clk);
        #1 if(id_ex_imm == 20'hfff) $display("S_IMM: PASS");
        else $display("S_IMM: FAIL");
        `IR_RST;
        
        //B-type
        if_id_pc = if_id_pc + 4;
        `OPCODE     = 7'b110_0011;
        `IMM_B      = 12'hfff;
        @(posedge clk);
        #1 if(id_ex_imm == 20'hfff) $display("B_IMM: PASS");
        else $display("B_IMM: FAIL");
        `IR_RST;
        
        //U-type
        if_id_pc = if_id_pc + 4;
        `OPCODE     = 7'b011_0111;
        `IMM_U      = 20'hfffff;
        @(posedge clk);
        #1 if(id_ex_imm == 20'hfffff) $display("U_IMM: PASS");
        else $display("U_IMM: FAIL");
        `IR_RST;
        
        //J-type
        if_id_pc = if_id_pc + 4;
        `OPCODE     = 7'b110_1111;
        `IMM_U      = 20'hfffff;
        @(posedge clk);
        #1 if(id_ex_imm == 20'hfffff) $display("J_IMM: PASS");
        else $display("J_IMM: FAIL");
        `IR_RST;
        
        //illegal
        if_id_pc = if_id_pc + 4;
        `OPCODE     = 7'b100_1100;
        `IMM_U      = 20'hfffff;
        @(posedge clk);
        #1 if(id_ex_imm != 20'hfffff) $display("ILL_IMM: PASS");
        else $display("ILL_IMM: FAIL");
        `IR_RST;

        //////////////////////////////////////////////////////
        // Test MEM_WB IR out for writing to regfile.
        // Test ID/EX rs1,rs2 for fetching register data.
        // id_ex_rs1/rs2 should have all 1's from the rs1/rs2
        //  field in the MEM/WB IR.
        //////////////////////////////////////////////////////
        $display("-------- REG_TEST --------");
        // write to x4 and read 0xdeadbeef
        @(posedge clk);
        #1 if_id_pc = if_id_pc + 4;
        `RD_WB = 5'h4;
        mem_wb_out = 32'hdeadbeef;
        @(posedge clk);
        #1 if_id_pc = if_id_pc + 4;
        `OPCODE = 7'b000_0011;
        `RS1    = 5'h4;
        @(posedge clk);
        #1 if(id_ex_rs1 == 32'hdeadbeef) $display("REG_RW_x4: PASS");
        else $display("REG_RW_x4: FAIL");
        `IR_RST;

        // write to x0 and read 0x00000000
        @(posedge clk);
        #1 if_id_pc = if_id_pc + 4;
        `RD_WB = 5'h0;
        mem_wb_out = 32'hdeadbeef;
        @(posedge clk);
        #1 if_id_pc = if_id_pc + 4;
        `OPCODE = 7'b000_0011;
        `RS1    = 5'h0;
        @(posedge clk);
        #1 if(id_ex_rs1 == 32'h0) $display("REG_RW_x0: PASS");
        else $display("REG_RW_x0: FAIL");
        `IR_RST;
    end //initial


endmodule
