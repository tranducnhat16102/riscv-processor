module instruction_memory #(
    parameter MEM_DEPTH = 256 // Do sau bo nho (so luong lenh 32-bit)
) (
    input  wire [31:0] address, // Dia chi tu PC (byte address)
    output wire [31:0] instruction // Lenh doc duoc
);
    // Bo nho thuc te (mang cac thanh ghi)
    reg [31:0] mem [0:MEM_DEPTH-1];

    // Khoi tao bo nho tu file hex (se lam trong testbench)
    // initial begin
    //     $readmemh("program.hex", mem);
    // end

    // Doc bo nho lenh (khong dong bo)
    // Chia dia chi cho 4 vi dia chi la byte address, con lenh la word (32-bit)
    assign instruction = mem[address >> 2];

endmodule