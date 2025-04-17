`timescale 1ns / 1ps

module tb_riscv_processor;

    reg clk;
    reg rst;

    // Instantiate the processor
    riscv_single_cycle_processor uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Reset and Test Sequence
    initial begin
        rst = 1; // Assert reset
        #12;     // GI? RESET TRONG 12ns (THAY VÌ 15ns)
        rst = 0; // Deassert reset
        $display("Reset released at time %0t", $time); // S? hi?n th? 12000

        // Ch? chuong trình ch?y xong
        #150; // Kho?ng th?i gian ch? này v?n gi? nguyên ho?c có th? di?u ch?nh n?u c?n

        // Ki?m tra k?t qu? cu?i cùng
        $display("Simulation finished at time %0t", $time); // S? hi?n th? 162000
        $display("Register Values:");
        $display("  x1 (5)  = %d", uut.REGFILE.registers[1]);
        $display("  x2 (10) = %d", uut.REGFILE.registers[2]);
        $display("  x3 (15) = %d", uut.REGFILE.registers[3]);
        $display("  x4 (256)= %d", uut.REGFILE.registers[4]);
        $display("  x5 (15) = %d", uut.REGFILE.registers[5]);
        $display("  x6 (0)  = %d", uut.REGFILE.registers[6]);
        $display("  x7 (2)  = %d", uut.REGFILE.registers[7]);
        $display("Data Memory[256] = %d", uut.DMEM.data_mem[256>>2]);

        $finish; // K?t thúc mô ph?ng
    end

    // Load instruction memory from file
    initial begin
        $readmemh("program.hex", uut.IMEM.mem);
        $display("Instruction memory loaded from program.hex");
    end

    // Optional: Monitor signals during simulation
     initial begin
         #1; // Ch? m?t chút d? giá tr? ban d?u ?n d?nh
         $monitor("Time=%0t PC=%h Inst=%h | RegWr=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b | ALURes=%h WBData=%h",
                  $time, uut.pc_current, uut.instruction,
                  uut.RegWrite, uut.ALUSrc, uut.MemRead, uut.MemWrite, uut.MemtoReg, uut.Branch,
                  uut.alu_result, uut.write_back_data);
     end

endmodule