module register_file (
    input  wire        clk,
    input  wire        rst,
    input  wire        reg_write_en, // Tin hieu cho phep ghi
    input  wire [4:0]  read_addr1,   // Dia chi rs1
    input  wire [4:0]  read_addr2,   // Dia chi rs2
    input  wire [4:0]  write_addr,   // Dia chi rd
    input  wire [31:0] write_data,   // Du lieu ghi vao rd
    output wire [31:0] read_data1,   // Du lieu doc tu rs1
    output wire [31:0] read_data2    // Du lieu doc tu rs2
);

    reg [31:0] registers [0:31]; // Mang 32 thanh ghi 32-bit

    integer i;
    // Khoi tao (reset) hoac ghi dong bo
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset tat ca thanh ghi ve 0
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else begin
            // Ghi vao thanh ghi neu duoc phep va dia chi khong phai x0
            if (reg_write_en && write_addr != 5'b00000) begin
                registers[write_addr] <= write_data;
            end
        end
    end

    // Doc khong dong bo (combinational read)
    // Thanh ghi x0 luon tra ve 0
    assign read_data1 = (read_addr1 == 5'b00000) ? 32'b0 : registers[read_addr1];
    assign read_data2 = (read_addr2 == 5'b00000) ? 32'b0 : registers[read_addr2];

endmodule