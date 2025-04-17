# Bộ Xử Lý RISC-V Single-Cycle 

## 📝 Mô Tả

Repository này chứa mã nguồn Verilog cho việc triển khai một bộ xử lý RISC-V 32-bit đơn giản, dựa trên tập lệnh cơ bản RV32I. Thiết kế này tuân theo kiến trúc **đơn xung nhịp (single-cycle)**.

## ✨ Tính Năng

*   Hiện thực một tập con của tập lệnh RV32I, bao gồm:
    *   Số học: `add`, `addi`
    *   Truy cập bộ nhớ: `lw`, `sw`
    *   Luồng điều khiển: `beq`
    *   *(Có thể dễ dàng mở rộng để hỗ trợ thêm các lệnh khác)*
*   **Thực thi đơn xung nhịp:** Mỗi lệnh hoàn thành toàn bộ trong một chu kỳ clock duy nhất.
*   Sử dụng các khối bộ nhớ riêng biệt cho Lệnh (Instruction Memory) và Dữ liệu (Data Memory).
*   Bao gồm một testbench (`tb_riscv_processor.v`) cơ bản để mô phỏng.
*   Cung cấp khả năng giám sát dạng sóng thông qua lệnh `$monitor` trong testbench.

## 🏗️ Kiến Trúc

Bộ xử lý được thiết kế theo phương pháp **đơn xung nhịp (single-cycle)**. Điều này có nghĩa là toàn bộ quá trình thực thi một lệnh, từ giai đoạn Nạp lệnh (Fetch) đến Ghi kết quả (Writeback), diễn ra trong một chu kỳ clock (có thể dài).

Các thành phần chính bao gồm:

*   **Program Counter (PC):** Thanh ghi chứa địa chỉ lệnh tiếp theo.
*   **Instruction Memory (IMEM):** Lưu trữ mã máy của chương trình.
*   **Register File:** Khối chứa 32 thanh ghi đa dụng (x0-x31).
*   **ALU (Arithmetic Logic Unit):** Thực hiện các phép toán số học và logic.
*   **Data Memory (DMEM):** Lưu trữ dữ liệu chương trình thao tác.
*   **Control Unit:** Tạo tín hiệu điều khiển dựa trên lệnh được giải mã.
*   **Immediate Generator:** Tạo giá trị tức thời và mở rộng dấu.
*   **Các thành phần phụ trợ:** MUXes, Adders được định nghĩa trong module top-level.

## 📂 Cấu Trúc File

*   `alu.v`: Module Đơn vị Luận lý Số học (ALU).
*   `control_unit.v`: Module tạo logic điều khiển.
*   `data_memory.v`: Module Bộ nhớ Dữ liệu.
*   `immediate_generator.v`: Module tạo giá trị tức thời.
*   `instruction_memory.v`: Module Bộ nhớ Lệnh.
*   `register_file.v`: Module Khối Thanh ghi.
*   `riscv_single_cycle_processor.v`: Module top-level, tích hợp các thành phần và định nghĩa logic phụ trợ (PC, Adders, MUXes).
*   `tb_riscv_processor.v`: Testbench để mô phỏng bộ xử lý.
*   `program.hex`: Chương trình mẫu dưới dạng mã máy hệ thập lục phân, được sử dụng bởi testbench.
*   `.gitignore`: Cấu hình bỏ qua các file khi dùng Git.
*   `README.md`: File mô tả này.

## ▶️ Hướng Dẫn Mô Phỏng (Sử dụng ModelSim)

1.  **Chuẩn bị:**
    *   Cài đặt ModelSim (Intel FPGA Edition hoặc phiên bản khác).
    *   Clone hoặc tải về repository này.
    *   Tạo một thư mục làm việc riêng (ví dụ: `D:\Test`) và sao chép tất cả các file cần thiết (`*.v`, `program.hex`) vào thư mục đó. **Không** nên chạy trực tiếp trong thư mục cài đặt ModelSim.

2.  **Mở ModelSim:** Khởi chạy ứng dụng ModelSim.

3.  **Chuyển Thư Mục:** Trong cửa sổ ModelSim **Transcript**, sử dụng lệnh `cd` để điều hướng đến thư mục làm việc của bạn. Sử dụng dấu `/` và đặt đường dẫn trong dấu ngoặc kép nếu có dấu cách:
    ```tcl
    cd D:/Test
    # Hoặc ví dụ: cd "D:/My Projects/RISCV Proc"

4.  **Tạo Thư Viện Work:** (Chỉ thực hiện lần đầu cho thư mục mới)
    ```tcl
    vlib work

5.  **Biên Dịch Mã Verilog:** Biên dịch tất cả các file Verilog. Đảm bảo liệt kê đúng thứ tự phụ thuộc hoặc sử dụng wildcard (ít khuyến khích hơn):
    ```tcl
    # Cách khuyến khích: Liệt kê tường minh
    vlog alu.v control_unit.v data_memory.v immediate_generator.v instruction_memory.v register_file.v riscv_single_cycle_processor.v tb_riscv_processor.v

    # Cách khác (có thể dùng cho dự án nhỏ):
    # vlog *.v

6.  **Bắt Đầu Mô Phỏng:** Nạp module testbench:
    vsim work.tb_riscv_processor

7.  **Thêm Tín Hiệu vào Wave:**
    *   Sử dụng cửa sổ **Objects** (hoặc **sim**): Duyệt đến instance `uut`, nhấn chuột phải vào tín hiệu/instance con -> Add To -> Wave (hoặc Add Wave).
    *   Hoặc sử dụng lệnh trong **Transcript**:
        ```tcl
        add wave sim:/tb_riscv_processor/clk
        add wave sim:/tb_riscv_processor/rst
        add wave sim:/tb_riscv_processor/uut/pc_current
        add wave sim:/tb_riscv_processor/uut/instruction
        # Thêm các tín hiệu điều khiển, ALU, dữ liệu khác nếu cần
        add wave -r sim:/tb_riscv_processor/uut/CONTROL/*
        add wave sim:/tb_riscv_processor/uut/alu_result
        ```

8.  **Chạy Mô Phỏng:** Thực thi mô phỏng trong một khoảng thời gian xác định. **Khuyến nghị dùng thời gian cụ thể** thay vì `run -all` nếu chương trình của bạn có vòng lặp vô hạn ở cuối để tránh khả năng crash bộ mô phỏng.
    ```tcl
    run 50 ns  # Chạy trong 50 nanoseconds (điều chỉnh nếu cần)
    ```


## 🧪 Test

Testbench `tb_riscv_processor.v` nạp chương trình `program.hex` thực hiện các thao tác cơ bản:

*   Tính toán số học (`addi`, `add`).
*   Lưu giá trị vào bộ nhớ dữ liệu (`sw`).
*   Đọc giá trị từ bộ nhớ dữ liệu (`lw`).
*   Thực hiện rẽ nhánh có điều kiện (`beq`).
*   Kết thúc bằng vòng lặp vô hạn (có thể gây crash khi dùng `run -all` trên một số phiên bản ModelSim, nên dùng `run <time>`).

Kết quả mong đợi được hiển thị qua các lệnh `$display` trong testbench sau khi mô phỏng chạy đủ thời gian.