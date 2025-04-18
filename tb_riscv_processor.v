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
        forever #5 clk = ~clk; // Chu ky clock 10ns
    end

    // Reset and Test Sequence
    initial begin
        rst = 1; // Kich hoat reset
        #12;     // Giu reset trong 12ns 
        rst = 0; // Huy kich hoat reset
        $display("Reset released at time %0t", $time); //  Se hien thi 512000

        // Cho chuong trinh chay xong
        #500; // Khoang thoi gian cho nay van giu nguyen hoac co the dieu chinh neu can

        // Kiem tra ket qua cuoi cung
        $display("Simulation finished at time %0t", $time); // Se hien thi 162000
        $display("Register Values:");
        $display("  x1 (5)  = %d", uut.REGFILE.registers[1]);
        $display("  x2 (10) = %d", uut.REGFILE.registers[2]);
        $display("  x3 (15) = %d", uut.REGFILE.registers[3]);
        $display("  x4 (256)= %d", uut.REGFILE.registers[4]);
        $display("  x5 (15) = %d", uut.REGFILE.registers[5]); // Doc tu mem
        $display("  x6 (0)  = %d", uut.REGFILE.registers[6]); // Bi bo qua do branch
        $display("  x7 (2)  = %d", uut.REGFILE.registers[7]); // Thuc thi trong nhanh 'equal'
        $display("Data Memory[256] = %d", uut.DMEM.data_mem[256>>2]); // Kiem tra gia tri da store

        $finish; // Ket thuc mo phong
    end

    // Load instruction memory from file
    initial begin
        // Duong dan den module bo nho lenh phai dung
        $readmemh("program.hex", uut.IMEM.mem);
        $display("Instruction memory loaded from program.hex");
    end

    // Optional: Monitor signals during simulation
     initial begin
         #1; // Cho mot chut de gia tri ban dau on dinh
         $monitor("Time=%0t PC=%h Inst=%h | RegWr=%b ALUSrc=%b MemRd=%b MemWr=%b Mem2Reg=%b Branch=%b | ALURes=%h WBData=%h",
                  $time, uut.pc_current, uut.instruction,
                  uut.RegWrite, uut.ALUSrc, uut.MemRead, uut.MemWrite, uut.MemtoReg, uut.Branch,
                  uut.alu_result, uut.write_back_data);
     end

endmodule