module instruction_memory #(
    parameter MEM_DEPTH = 256 // ?? sâu b? nh? (s? l??ng l?nh 32-bit)
) (
    input  wire [31:0] address,
    output wire [31:0] instruction
);
    // B? nh? th?c t? (m?ng các thanh ghi)
    reg [31:0] mem [0:MEM_DEPTH-1];

    // Kh?i t?o b? nh? t? file hex (s? làm trong testbench)
    // initial begin
    //     $readmemh("program.hex", mem);
    // end

    // ??c b? nh? l?nh (không ??ng b?)
    // Chia ??a ch? cho 4 vì ??a ch? là byte address, còn l?nh là word (32-bit)
    assign instruction = mem[address >> 2];

endmodule