`timescale 1ns / 1ps
`include "register_file.v"
`include "immediate_generator.v"

module tb_regfile_immgen;

    // --- Test Signals ---
    reg clk;
    reg rst;

    // --- Inputs cho Register File ---
    reg        test_reg_write_en;
    reg [4:0]  test_read_addr1;
    reg [4:0]  test_read_addr2;
    reg [4:0]  test_write_addr;
    reg [31:0] test_write_data;

    // --- Outputs tu Register File ---
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // --- Input cho Immediate Generator ---
    reg [31:0] test_instruction;

    // --- Output tu Immediate Generator ---
    wire [31:0] imm_extended;

    // --- Instantiate DUTs ---
    register_file uut_regfile (
        .clk(clk), .rst(rst),
        .reg_write_en(test_reg_write_en),
        .read_addr1(test_read_addr1),   .read_addr2(test_read_addr2),
        .write_addr(test_write_addr),   .write_data(test_write_data),
        .read_data1(read_data1),       .read_data2(read_data2)
    );

    immediate_generator uut_immgen (
        .instruction(test_instruction),
        .imm_extended(imm_extended)
    );

    // --- Clock Generation ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- Trinh tu Test ---
    initial begin
        $display("--- Bat dau Test Register File & Immediate Generator ---");

        // --- Test Register File ---
        $display("--- Testing Register File ---");
        rst = 1;
        test_reg_write_en = 0;
        test_read_addr1 = 0;
        test_read_addr2 = 0;
        test_write_addr = 0;
        test_write_data = 32'hxxxxxxxx;
        #12; // Giu reset
        rst = 0;
        #2; // Cho reset on dinh

        // Test Case RF 1: Ghi vao x5
        $display("[Test RF Write x5]");
        test_reg_write_en = 1'b1;
        test_write_addr   = 5'd5; // Dia chi x5
        test_write_data   = 32'hABCDEFFF;
        $display("  Input: WrEn=%b, WrAddr=%d, WrData=%h", test_reg_write_en, test_write_addr, test_write_data);
        @(posedge clk); // Cho 1 chu ky de ghi
        #1; // Delay nho de quan sat output
        test_reg_write_en = 1'b0; // Tat ghi de chuan bi doc

        // Test Case RF 2: Doc tu x5
        $display("[Test RF Read x5]");
        test_read_addr1 = 5'd5;
        test_read_addr2 = 5'd0; // Doc them x0
        $display("  Input: RdAddr1=%d, RdAddr2=%d", test_read_addr1, test_read_addr2);
        #1;
        $display("  Output: RdData1=%h, RdData2=%h", read_data1, read_data2);
        // Mong doi: RdData1=ABCDEFFF, RdData2=00000000

        // Test Case RF 3: Doc x0
        $display("[Test RF Read x0]");
        test_read_addr1 = 5'd0;
        test_read_addr2 = 5'd0;
        $display("  Input: RdAddr1=%d, RdAddr2=%d", test_read_addr1, test_read_addr2);
        #1;
        $display("  Output: RdData1=%h, RdData2=%h", read_data1, read_data2);
        // Mong doi: RdData1=00000000, RdData2=00000000

        // Test Case RF 4: Thu ghi vao x0
        $display("[Test RF Write x0]");
        test_reg_write_en = 1'b1;
        test_write_addr   = 5'd0; // Dia chi x0
        test_write_data   = 32'h12345678;
        $display("  Input: WrEn=%b, WrAddr=%d, WrData=%h", test_reg_write_en, test_write_addr, test_write_data);
        @(posedge clk);
        #1;
        test_reg_write_en = 1'b0;
        test_read_addr1 = 5'd0; // Doc lai x0
        $display("  Input (Read After Write): RdAddr1=%d", test_read_addr1);
        #1;
        $display("  Output: RdData1=%h", read_data1);
        // Mong doi: RdData1=00000000 (Ghi vao x0 khong co tac dung)

        // --- Test Immediate Generator ---
        $display("--- Testing Immediate Generator ---");

        // Test Case IG 1: I-type (addi x1, x0, -5)
        $display("[Test ImmGen I-type]");
        test_instruction = 32'hFFB00093; // Ma hex cho addi x1, x0, -5
        $display("  Input: Instruction=%h", test_instruction);
        #1;
        $display("  Output: ImmExtended=%h (%d)", imm_extended, $signed(imm_extended));
        // Mong doi: ImmExtended=FFFFFFFF FFFFFFFB (-5)

        // Test Case IG 2: S-type (sw x1, 20(x2)) - gia su x1=1, x2=2
        $display("[Test ImmGen S-type]");
        test_instruction = 32'h00112A23; // Ma hex cho sw x1, 20(x2)
        $display("  Input: Instruction=%h", test_instruction);
        #1;
        $display("  Output: ImmExtended=%h (%d)", imm_extended, $signed(imm_extended));
        // Mong doi: ImmExtended=00000000 00000014 (20)

        // Test Case IG 3: B-type (beq x1, x0, target) - gia su offset +28 bytes
        $display("[Test ImmGen B-type]");
        test_instruction = 32'h00008E63; // Ma hex cho beq x1, x0, +28
        $display("  Input: Instruction=%h", test_instruction);
        #1;
        $display("  Output: ImmExtended=%h (%d)", imm_extended, $signed(imm_extended));
        // Mong doi: ImmExtended=00000000 0000001C (28 - da dich trai 1)

        $display("--- Ket thuc Test Register File & Immediate Generator ---");
        $finish;
    end

endmodule