`timescale 1ns / 1ps
`include "alu.v" // Bao g?m file DUT

module tb_alu_branch;

    // --- Inputs cho ALU ---
    reg  [31:0] test_operand_a; // Gia lap gia tri rs1
    reg  [31:0] test_operand_b; // Gia lap gia tri rs2
    reg  [3:0]  test_alu_op;    // Se dat la ma SUB de kiem tra Branch

    // --- Outputs tu ALU ---
    wire [31:0] result;       // Ket qua phep tru (khong qua quan trong cho branch)
    wire        zero_flag;    // Quan trong nhat cho BEQ

    // --- Instantiate ALU ---
    alu uut_alu (
        .operand_a(test_operand_a),
        .operand_b(test_operand_b),
        .alu_op(test_alu_op),
        .result(result),
        .zero_flag(zero_flag)
    );

    // --- Ma hoa ALUOp ---
    localparam ALU_SUB = 4'b0001; // Ma cho phep tru (dung cho BEQ)
    localparam ALU_ADD = 4'b0000; // De test truong hop khac neu muon

    // --- Trinh tu Test ---
    initial begin
        $display("--- Bat dau Test ALU cho Logic Branch/Compare ---");

        // Dat alu_op la SUB de gia lap truong hop Control Unit xu ly BEQ/BNE
        test_alu_op = ALU_SUB;

        // Test Case 1: BEQ - Du kien nhanh (rs1 == rs2)
        $display("[Test BEQ - Equal]");
        test_operand_a = 32'd100;
        test_operand_b = 32'd100;
        #1; // Cho logic to hop on dinh
        $display("  Input: A=%0d, B=%0d, Op=%b | Output: Result=%0d, Zero=%b",
                 test_operand_a, test_operand_b, test_alu_op, result, zero_flag);
        // Mong doi: Result=0, Zero=1 (Se kich hoat branch BEQ)

        // Test Case 2: BEQ - Du kien khong nhanh (rs1 != rs2)
        $display("[Test BEQ - Not Equal]");
        test_operand_a = 32'd100;
        test_operand_b = 32'd50;
        #1;
        $display("  Input: A=%0d, B=%0d, Op=%b | Output: Result=%0d, Zero=%b",
                 test_operand_a, test_operand_b, test_alu_op, result, zero_flag);
        // Mong doi: Result=50, Zero=0 (Se KHONG kich hoat branch BEQ)

        // Test Case 3: BEQ - Truong hop so am
        $display("[Test BEQ - Negative Numbers Equal]");
        test_operand_a = 32'hFFFFFFF0; // -16
        test_operand_b = 32'hFFFFFFF0; // -16
        #1;
        $display("  Input: A=%h, B=%h, Op=%b | Output: Result=%h, Zero=%b",
                 test_operand_a, test_operand_b, test_alu_op, result, zero_flag);
        // Mong doi: Result=0, Zero=1

        // Test Case 4: BEQ - Truong hop so am khac nhau
        $display("[Test BEQ - Negative Numbers Not Equal]");
        test_operand_a = 32'hFFFFFFF0; // -16
        test_operand_b = 32'hFFFFFFFE; // -2
        #1;
        $display("  Input: A=%h, B=%h, Op=%b | Output: Result=%h, Zero=%b",
                 test_operand_a, test_operand_b, test_alu_op, result, zero_flag);
        // Mong doi: Result=FFFFFFF2 (-14), Zero=0

        // Quan trong: Neu ban can test BNE (Branch if Not Equal),
        // ban cung dung ALU_SUB, nhung logic PC se kiem tra zero_flag == 0.
        // Testbench nay chi kiem tra ALU tao zero_flag dung hay khong.

        // Ban co the them test case cho cac phep toan khac neu muon o day
        // $display("--- Testing other ALU ops ---");
        // test_alu_op = ALU_ADD;
        // ...

        $display("--- Ket thuc Test ALU cho Logic Branch/Compare ---");
        $finish;
    end

endmodule