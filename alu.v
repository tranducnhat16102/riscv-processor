module alu (
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    input  wire [3:0]  alu_op, // Mã hóa phép toán (ví d?: 0000=ADD, 0001=SUB)
    output reg  [31:0] result,
    output reg         zero_flag // C? zero cho BEQ
);
    localparam OP_ADD = 4'b0000;
    localparam OP_SUB = 4'b0001; // C?n cho BEQ

    always @(*) begin
        case (alu_op)
            OP_ADD: result = operand_a + operand_b;
            OP_SUB: result = operand_a - operand_b; // Dùng cho BEQ
            // Thêm các phép toán khác n?u c?n
            default: result = 32'hxxxxxxxx; // Giá tr? không xác ??nh
        endcase

        // C? Zero dùng cho BEQ (n?u k?t qu? phép tr? b?ng 0)
        if (alu_op == OP_SUB && result == 32'b0) begin
            zero_flag = 1'b1;
        end else begin
            zero_flag = 1'b0;
        end
        // L?u ý: Zero flag chính xác h?n nên d?a vào (operand_a == operand_b)
        // zero_flag = (operand_a == operand_b); // Cách này t?t h?n cho BEQ
    end
endmodule