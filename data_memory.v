module data_memory #(
    parameter DATA_MEM_DEPTH = 256 // Kich thuoc bo nho du lieu (so word 32-bit)
) (
    input wire        clk,
    input wire        mem_read_en, // Cho phep doc (LW)
    input wire        mem_write_en, // Cho phep ghi (SW)
    input wire [31:0] address,     // Dia chi truy cap (tu ALU)
    input wire [31:0] write_data,  // Du lieu ghi (tu rs2 cho SW)
    output reg [31:0] read_data    // Du lieu doc (cho LW)
);
    // Bo nho du lieu thuc te
    reg [31:0] data_mem [0:DATA_MEM_DEPTH-1];

    // Ghi dong bo vao bo nho
    always @(posedge clk) begin
        if (mem_write_en) begin
            data_mem[address >> 2] <= write_data; // Chia 4 cho dia chi byte
        end
    end

    // Doc (co the dong bo hoac khong dong bo, o day lam khong dong bo)
    always @(*) begin
         if (mem_read_en) begin
             read_data = data_mem[address >> 2];
         end else begin
             read_data = 32'hxxxxxxxx; // Khong doc thi khong xac dinh
         end
    end

    // Khoi tao ve 0 khi reset (trong testbench hoac initial block)
    // initial begin
    //     integer j;
    //     for (j=0; j<DATA_MEM_DEPTH; j=j+1) begin
    //         data_mem[j] = 32'b0;
    //     end
    // end

endmodule