module instruction_memory #(
    parameter MEM_DEPTH = 256 // ?? s�u b? nh? (s? l??ng l?nh 32-bit)
) (
    input  wire [31:0] address,
    output wire [31:0] instruction
);
    // B? nh? th?c t? (m?ng c�c thanh ghi)
    reg [31:0] mem [0:MEM_DEPTH-1];

    // Kh?i t?o b? nh? t? file hex (s? l�m trong testbench)
    // initial begin
    //     $readmemh("program.hex", mem);
    // end

    // ??c b? nh? l?nh (kh�ng ??ng b?)
    // Chia ??a ch? cho 4 v� ??a ch? l� byte address, c�n l?nh l� word (32-bit)
    assign instruction = mem[address >> 2];

endmodule