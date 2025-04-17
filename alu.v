module alu (
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    input  wire [3:0]  alu_op, // M� h�a ph�p to�n (v� d?: 0000=ADD, 0001=SUB)
    output reg  [31:0] result,
    output reg         zero_flag // C? zero cho BEQ
);
    localparam OP_ADD = 4'b0000;
    localparam OP_SUB = 4'b0001; // C?n cho BEQ

    always @(*) begin
        case (alu_op)
            OP_ADD: result = operand_a + operand_b;
            OP_SUB: result = operand_a - operand_b; // D�ng cho BEQ
            // Th�m c�c ph�p to�n kh�c n?u c?n
            default: result = 32'hxxxxxxxx; // Gi� tr? kh�ng x�c ??nh
        endcase

        // C? Zero d�ng cho BEQ (n?u k?t qu? ph�p tr? b?ng 0)
        if (alu_op == OP_SUB && result == 32'b0) begin
            zero_flag = 1'b1;
        end else begin
            zero_flag = 1'b0;
        end
        // L?u �: Zero flag ch�nh x�c h?n n�n d?a v�o (operand_a == operand_b)
        // zero_flag = (operand_a == operand_b); // C�ch n�y t?t h?n cho BEQ
    end
endmodule