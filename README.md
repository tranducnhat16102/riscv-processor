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
Use any Verilog simulator (ModelSim, Icarus Verilog, etc.)

## 🧪 Test
To run the testbench:
```bash
iverilog -o testbench tb_riscv_processor.v *.v
vvp testbench
