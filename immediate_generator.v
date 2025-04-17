module immediate_generator (
    input wire [31:0] instruction,
    output reg [31:0] imm_extended
);
    wire [6:0] opcode = instruction[6:0];
    // ??nh d?ng l?nh c? b?n
    localparam OPCODE_I_ALU= 7'b0010011; // addi
    localparam OPCODE_LOAD = 7'b0000011; // lw
    localparam OPCODE_STORE= 7'b0100011; // sw
    localparam OPCODE_BRANCH=7'b1100011; // beq

    always @(*) begin
        case (opcode)
            OPCODE_I_ALU, OPCODE_LOAD: begin // I-type immediate [11:0]
                imm_extended = {{20{instruction[31]}}, instruction[31:20]}; // Sign extend
            end
            OPCODE_STORE: begin // S-type immediate [11:5], [4:0]
                imm_extended = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // Sign extend
            end
            OPCODE_BRANCH: begin // B-type immediate [12], [10:5], [4:1], [11] -> shifted left 1
                imm_extended = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // Sign extend and shift
            end
            // Thêm các lo?i immediate khác n?u c?n (J-type, U-type)
            default: imm_extended = 32'hxxxxxxxx; // Không xác dinh
        endcase
    end
endmodule