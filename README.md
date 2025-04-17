# RISC-V Single Cycle Processor

This project implements a simple **RISC-V single-cycle processor** using Verilog.

## 🧠 Features
- Implements basic RISC-V instructions (add, sub, lw, sw, beq, etc.)
- Follows the classical 5-stage pipeline logic:
  1. Instruction Fetch
  2. Instruction Decode
  3. Execute
  4. Memory Access
  5. Writeback
- Uses separate Instruction and Data memory
- Includes testbench with waveform monitoring

## 📂 Files
- `*.v` — Verilog modules
- `program.hex` — Sample program in machine code
- `tb_riscv_processor.v` — Testbench

## ▶️ How to Simulate
Use any Verilog simulator (ModelSim)

## 🧪 Test
•	Trong Transcript, cd D:/Test
•	Biên dịch lại: vlog *.v (Hoặc liệt kê tên file, đảm bảo testbench cuối cùng)
•	Chạy mô phỏng: vsim work.tb_riscv_processor
•	Thêm (một vài) tín hiệu vào Wave (ví dụ chỉ clk, rst, pc_current, instruction).
•	run 500 ns
