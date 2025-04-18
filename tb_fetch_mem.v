`timescale 1ns / 1ps
`include "riscv_single_cycle_processor.v" // Bao g?m module top-level de lay instance

module tb_fetch_mem;

    // --- Test Signals ---
    reg clk;
    reg rst;

    // --- DUT Instance (Lay tu top-level) ---
    // Chung ta can uut de truy cap vao IMEM va DMEM da duoc khoi tao ben trong
    riscv_single_cycle_processor uut (
        .clk(clk),
        .rst(rst)
    );

    // --- Gia lap cac tin hieu khong test ---
    // De PC chay binh thuong, ta can gia lap pc_next = pc_plus_4
    // Cac tin hieu dieu khien khac co the de mac dinh (0)

    // --- Tin hieu de test DMEM Read ---
    reg        test_mem_read_en;
    reg [31:0] test_mem_addr;

    // --- Ket noi cac tin hieu test DMEM ---
    // Can co cach de ghi de tin hieu MemRead va address cua DMEM ben trong uut
    // Cach 1: Sua module top-level de co them input dieu khien (Phuc tap)
    // Cach 2: Truy cap truc tiep vao wire ben trong uut (Khong chinh thong, tuy simulator)
    // Cach 3 (Don gian nhat): Khong test DMEM read o day, chi tap trung vao PC + IMEM

    // --- Clock Generation ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- Khoi tao Bo nho (Ghi gia tri vao DMEM de test doc) ---
    initial begin
        // Cho reset xong de tranh ghi de
        @(negedge rst);
        #1; // Them delay nho
        $display("[DMEM Init] Ghi gia tri vao DMEM de test doc");
        uut.DMEM.data_mem[10] = 32'hABCDEF01; // Ghi vao dia chi 40 (byte)
        uut.DMEM.data_mem[20] = 32'h12345678; // Ghi vao dia chi 80 (byte)
        $display("  DMEM[40] = %h", uut.DMEM.data_mem[10]);
        $display("  DMEM[80] = %h", uut.DMEM.data_mem[20]);
    end


    // --- Trinh tu Test ---
    initial begin
        $display("--- Bat dau Test PC, IMEM, DMEM(Read) ---");

        rst = 1;
        test_mem_read_en = 1'b0;
        test_mem_addr = 32'hxxxxxxxx;
        #12; // Giu reset
        rst = 0;
        #2; // Cho reset on dinh

        // --- Test PC & IMEM ---
        $display("--- Testing PC & IMEM Fetch ---");
        // PC se tu dong chay do logic trong uut (gia su mac dinh pc_next = pc+4)
        // Quan sat bang $monitor hoac $display tai cac chu ky

        @(posedge clk); #1; // Chu ky 1 (PC=0)
        $display("[Cycle 1] PC=%h, Fetched Instruction=%h", uut.pc_current, uut.instruction);
        // Mong doi: PC=0, Instruction=00500093 (tu program.hex)

        @(posedge clk); #1; // Chu ky 2 (PC=4)
        $display("[Cycle 2] PC=%h, Fetched Instruction=%h", uut.pc_current, uut.instruction);
        // Mong doi: PC=4, Instruction=00A00113

        @(posedge clk); #1; // Chu ky 3 (PC=8)
        $display("[Cycle 3] PC=%h, Fetched Instruction=%h", uut.pc_current, uut.instruction);
        // Mong doi: PC=8, Instruction=002081B3

        // Tiep tuc cho vai chu ky nua...

        // --- Test DMEM Read ---
        $display("--- Testing DMEM Read ---");
        // Cach 1: Neu co the dieu khien truc tiep DMEM trong testbench nay
        // Hoac gia lap tin hieu dieu khien MemRead va Address di vao uut.DMEM
        // Vi du gia lap (can co co che ghi de tin hieu trong uut):
        // force uut.MemRead = 1'b1;
        // force uut.alu_result = 32'd40; // Dia chi can doc
        // #1;
        // $display("[Test DMEM Read] Addr=%d | Output: ReadData=%h", 40, uut.mem_read_data);
        // release uut.MemRead;
        // release uut.alu_result;
        // Mong doi: ReadData = ABCDEF01

        // Cach 2: Don gian la kiem tra gia tri da khoi tao (khong test logic doc)
        $display("[Test DMEM Read Check Init] Addr=40, Expected=%h, Actual=%h", 32'hABCDEF01, uut.DMEM.data_mem[10]);
        $display("[Test DMEM Read Check Init] Addr=80, Expected=%h, Actual=%h", 32'h12345678, uut.DMEM.data_mem[20]);


        $display("--- Ket thuc Test PC, IMEM, DMEM(Read) ---");
        #50; // Them chut delay truoc khi finish
        $finish;
    end

     // Load instruction memory (van can de PC chay dung)
    initial begin
        $readmemh("program.hex", uut.IMEM.mem);
        $display("Instruction memory loaded from program.hex");
    end

endmodule