module alu (
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    input  wire [3:0]  alu_op, // Ma hoa phep toan (vi du: 0000=ADD, 0001=SUB)
    output reg  [31:0] result,
    output reg         zero_flag // Co zero cho BEQ
);
    localparam OP_ADD = 4'b0000;
    localparam OP_SUB = 4'b0001; // Can cho BEQ

    always @(*) begin
        case (alu_op)
            OP_ADD: result = operand_a + operand_b;
            OP_SUB: result = operand_a - operand_b; // Dung cho BEQ
            // Them cac phep toan khac neu can
            default: result = 32'hxxxxxxxx; // Gia tri khong xac dinh
        endcase

        // Co Zero dung cho BEQ (neu ket qua phep tru bang 0)
        if (alu_op == OP_SUB && result == 32'b0) begin
            zero_flag = 1'b1;
        end else begin
            zero_flag = 1'b0;
        end
        // Luu y: Zero flag chinh xac hon nen dua vao (operand_a == operand_b)
        // zero_flag = (operand_a == operand_b); // Cach nay tot hon cho BEQ
    end
endmodule