`timescale 1ns / 1ps
`include "control_unit.v" // Bao g?m file DUT

module tb_control_unit;

    // --- Inputs cho Control Unit ---
    reg [6:0] test_opcode;
    reg [2:0] test_funct3;
    reg [6:0] test_funct7; // Co the khong can neu CU don gian

    // --- Outputs tu Control Unit ---
    wire RegWrite, MemRead, MemWrite, MemtoReg, ALUSrc, Branch;
    wire [3:0] ALUOp;

    // --- Instantiate Control Unit ---
    control_unit uut_cu (
        .opcode(test_opcode),
        .funct3(test_funct3),
        .funct7(test_funct7), // Ket noi du khong dung het
        // Ket noi outputs
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .MemtoReg(MemtoReg), .ALUSrc(ALUSrc),   .ALUOp(ALUOp),
        .Branch(Branch)
    );

    // --- Trinh tu Test ---
    initial begin
        $display("--- Bat dau Test Control Unit ---");

        // Test Case 1: Lenh R-type (ADD)
        test_opcode = 7'b0110011; // OPCODE_R
        test_funct3 = 3'b000;    // Vi du cho ADD
        test_funct7 = 7'b0000000; // Vi du cho ADD
        #1;
        $display("[Test R-type(ADD)] Op=%b | Outputs: RegW=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b ALUOp=%b",
                 test_opcode, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp);
        // Mong doi: RegW=1, ALUSrc=0, MemRd=0, MemWr=0, Mem2Reg=0, Branch=0, ALUOp=ADD_CODE (0000)

        // Test Case 2: Lenh I-type ALU (ADDI)
        test_opcode = 7'b0010011; // OPCODE_I_ALU
        test_funct3 = 3'b000;    // Cho ADDI
        test_funct7 = 7'bxxxxxxx; // Khong dung cho ADDI
        #1;
        $display("[Test I-ALU(ADDI)] Op=%b | Outputs: RegW=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b ALUOp=%b",
                 test_opcode, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp);
        // Mong doi: RegW=1, ALUSrc=1, MemRd=0, MemWr=0, Mem2Reg=0, Branch=0, ALUOp=ADD_CODE (0000)

        // Test Case 3: Lenh Load (LW)
        test_opcode = 7'b0000011; // OPCODE_LOAD
        test_funct3 = 3'b010;    // Cho LW (word)
        test_funct7 = 7'bxxxxxxx;
        #1;
        $display("[Test Load(LW)] Op=%b | Outputs: RegW=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b ALUOp=%b",
                 test_opcode, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp);
        // Mong doi: RegW=1, ALUSrc=1, MemRd=1, MemWr=0, Mem2Reg=1, Branch=0, ALUOp=ADD_CODE (0000)

        // Test Case 4: Lenh Store (SW)
        test_opcode = 7'b0100011; // OPCODE_STORE
        test_funct3 = 3'b010;    // Cho SW (word)
        test_funct7 = 7'bxxxxxxx;
        #1;
        $display("[Test Store(SW)] Op=%b | Outputs: RegW=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b ALUOp=%b",
                 test_opcode, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp);
        // Mong doi: RegW=0, ALUSrc=1, MemRd=0, MemWr=1, Mem2Reg=X(ko qtrong), Branch=0, ALUOp=ADD_CODE (0000)

        // Test Case 5: Lenh Branch (BEQ)
        test_opcode = 7'b1100011; // OPCODE_BRANCH
        test_funct3 = 3'b000;    // Cho BEQ
        test_funct7 = 7'bxxxxxxx;
        #1;
        $display("[Test Branch(BEQ)] Op=%b | Outputs: RegW=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b ALUOp=%b",
                 test_opcode, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp);
        // Mong doi: RegW=0, ALUSrc=0, MemRd=0, MemWr=0, Mem2Reg=X, Branch=1, ALUOp=SUB_CODE (0001)

        // Test Case 6: Opcode khong hop le
        test_opcode = 7'b1111111; // Vi du opcode sai
        test_funct3 = 3'bxxx;
        test_funct7 = 7'bxxxxxxx;
        #1;
        $display("[Test Invalid Op] Op=%b | Outputs: RegW=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b ALUOp=%b",
                 test_opcode, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp);
        // Mong doi: Cac tin hieu dieu khien o gia tri mac dinh (thuong la 0 hoac trang thai NOP)

        $display("--- Ket thuc Test Control Unit ---");
        $finish;
    end

endmodule