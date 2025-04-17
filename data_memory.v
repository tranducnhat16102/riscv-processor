module data_memory #(
    parameter DATA_MEM_DEPTH = 256 // K�ch th??c b? nh? d? li?u (s? word 32-bit)
) (
    input wire        clk,
    input wire        mem_read_en, // Cho ph�p ??c (LW)
    input wire        mem_write_en, // Cho ph�p ghi (SW)
    input wire [31:0] address,     // ??a ch? truy c?p (t? ALU)
    input wire [31:0] write_data,  // D? li?u ghi (t? rs2 cho SW)
    output reg [31:0] read_data    // D? li?u ??c (cho LW)
);
    // B? nh? d? li?u th?c t?
    reg [31:0] data_mem [0:DATA_MEM_DEPTH-1];

    // Ghi ??ng b? v�o b? nh?
    always @(posedge clk) begin
        if (mem_write_en) begin
            data_mem[address >> 2] <= write_data; // Chia 4 cho ??a ch? byte
        end
    end

    // ??c (c� th? ??ng b? ho?c kh�ng ??ng b?, ? ?�y l�m kh�ng ??ng b?)
    always @(*) begin
         if (mem_read_en) begin
             read_data = data_mem[address >> 2];
         end else begin
             read_data = 32'hxxxxxxxx; // Kh�ng ??c th� kh�ng x�c ??nh
         end
    end

    // Kh?i t?o v? 0 khi reset (trong testbench ho?c initial block)
    // initial begin
    //     integer j;
    //     for (j=0; j<DATA_MEM_DEPTH; j=j+1) begin
    //         data_mem[j] = 32'b0;
    //     end
    // end

endmodule