module register_file (
    input  wire        clk,
    input  wire        rst,
    input  wire        reg_write_en, // Tín hi?u cho phép ghi
    input  wire [4:0]  read_addr1,
    input  wire [4:0]  read_addr2,
    input  wire [4:0]  write_addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    reg [31:0] registers [0:31]; // M?ng 32 thanh ghi 32-bit

    integer i;
    // Kh?i t?o (reset) ho?c ghi ??ng b?
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset t?t c? thanh ghi v? 0
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else begin
            // Ghi vào thanh ghi n?u ???c phép và ??a ch? không ph?i x0
            if (reg_write_en && write_addr != 5'b00000) begin
                registers[write_addr] <= write_data;
            end
        end
    end

    // ??c không ??ng b? (combinational read)
    // Thanh ghi x0 luôn tr? v? 0
    assign read_data1 = (read_addr1 == 5'b00000) ? 32'b0 : registers[read_addr1];
    assign read_data2 = (read_addr2 == 5'b00000) ? 32'b0 : registers[read_addr2];

endmodule