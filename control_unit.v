module control_unit (
    input wire [6:0] opcode,
    input wire [2:0] funct3, // C?n cho m?t s? l?nh nh? BEQ
    // input wire [6:0] funct7, // C?n cho ADD/SUB R-type

    // Control Signals Outputs:
    output reg RegWrite,    // Cho phép ghi Register File
    output reg MemRead,     // Cho phép ??c Data Memory (LW)
    output reg MemWrite,    // Cho phép ghi Data Memory (SW)
    output reg MemtoReg,    // Ch?n data cho WB MUX (0: ALU, 1: Memory)
    output reg ALUSrc,      // Ch?n toán h?ng 2 ALU (0: Reg, 1: Imm)
    output reg [3:0] ALUOp, // Mã hóa phép toán cho ALU
    output reg Branch       // Là l?nh BEQ (?? ch?n PC ti?p theo)
   // output reg Jump // N?u có JAL/JALR
);

    // Mã Opcode RV32I c? b?n
    localparam OPCODE_R    = 7'b0110011; // add
    localparam OPCODE_I_ALU= 7'b0010011; // addi
    localparam OPCODE_LOAD = 7'b0000011; // lw
    localparam OPCODE_STORE= 7'b0100011; // sw
    localparam OPCODE_BRANCH=7'b1100011; // beq

    // Mã hóa ALUOp (ví d?)
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001; // C?n cho BEQ

    always @(*) begin
        // Giá tr? m?c ??nh (quan tr?ng ?? tránh latch)
        RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; MemtoReg = 1'b0;
        ALUSrc = 1'b0; ALUOp = ALU_ADD; Branch = 1'b0;

        case (opcode)
            OPCODE_R: begin // ADD
                RegWrite = 1'b1; // Ghi k?t qu? vào rd
                ALUSrc = 1'b0;   // Toán h?ng 2 là t? reg (rs2)
                ALUOp = ALU_ADD;
                MemtoReg = 1'b0; // K?t qu? t? ALU
            end
            OPCODE_I_ALU: begin // ADDI
                RegWrite = 1'b1; // Ghi k?t qu? vào rd
                ALUSrc = 1'b1;   // Toán h?ng 2 là immediate
                ALUOp = ALU_ADD;
                MemtoReg = 1'b0; // K?t qu? t? ALU
            end
            OPCODE_LOAD: begin // LW
                RegWrite = 1'b1; // Ghi d? li?u ??c t? mem vào rd
                ALUSrc = 1'b1;   // Dùng immediate ?? tính ??a ch? (base + offset)
                ALUOp = ALU_ADD; // ALU c?ng ?? ra ??a ch?
                MemRead = 1'b1;  // ??c memory
                MemtoReg = 1'b1; // K?t qu? t? Memory
            end
            OPCODE_STORE: begin // SW
                // RegWrite = 0 (m?c ??nh)
                ALUSrc = 1'b1;   // Dùng immediate ?? tính ??a ch? (base + offset)
                ALUOp = ALU_ADD; // ALU c?ng ?? ra ??a ch?
                MemWrite = 1'b1; // Ghi memory
                // MemtoReg không quan tr?ng
            end
            OPCODE_BRANCH: begin // BEQ
                // RegWrite = 0 (m?c ??nh)
                ALUSrc = 1'b0;   // So sánh rs1 và rs2
                ALUOp = ALU_SUB; // ALU tr? ?? ki?m tra b?ng nhau (qua c? zero)
                Branch = 1'b1;   // ?ây là l?nh branch
                // MemRead/Write = 0 (m?c ??nh)
                // MemtoReg không quan tr?ng
            end
            default: begin
                // L?nh không xác ??nh -> NOP (No Operation)
                RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; MemtoReg = 1'b0;
                ALUSrc = 1'b0; ALUOp = ALU_ADD; Branch = 1'b0;
            end
        endcase
    end
endmodule