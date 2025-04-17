module control_unit (
    input wire [6:0] opcode,
    input wire [2:0] funct3, // Can cho mot so lenh nhu BEQ
    // input wire [6:0] funct7, // Can cho ADD/SUB R-type

    // Control Signals Outputs:
    output reg RegWrite,    // Cho phep ghi Register File
    output reg MemRead,     // Cho phep doc Data Memory (LW)
    output reg MemWrite,    // Cho phep ghi Data Memory (SW)
    output reg MemtoReg,    // Chon data cho WB MUX (0: ALU, 1: Memory)
    output reg ALUSrc,      // Chon toan hang 2 ALU (0: Reg, 1: Imm)
    output reg [3:0] ALUOp, // Ma hoa phep toan cho ALU
    output reg Branch       // La lenh BEQ (de chon PC tiep theo)
   // output reg Jump // Neu co JAL/JALR
);

    // Ma Opcode RV32I co ban
    localparam OPCODE_R    = 7'b0110011; // add
    localparam OPCODE_I_ALU= 7'b0010011; // addi
    localparam OPCODE_LOAD = 7'b0000011; // lw
    localparam OPCODE_STORE= 7'b0100011; // sw
    localparam OPCODE_BRANCH=7'b1100011; // beq

    // Ma hoa ALUOp (vi du)
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001; // Can cho BEQ

    always @(*) begin
        // Gia tri mac dinh (quan trong de tranh latch)
        RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; MemtoReg = 1'b0;
        ALUSrc = 1'b0; ALUOp = ALU_ADD; Branch = 1'b0;

        case (opcode)
            OPCODE_R: begin // ADD
                RegWrite = 1'b1; // Ghi ket qua vao rd
                ALUSrc = 1'b0;   // Toan hang 2 la tu reg (rs2)
                ALUOp = ALU_ADD;
                MemtoReg = 1'b0; // Ket qua tu ALU
            end
            OPCODE_I_ALU: begin // ADDI
                RegWrite = 1'b1; // Ghi ket qua vao rd
                ALUSrc = 1'b1;   // Toan hang 2 la immediate
                ALUOp = ALU_ADD;
                MemtoReg = 1'b0; // Ket qua tu ALU
            end
            OPCODE_LOAD: begin // LW
                RegWrite = 1'b1; // Ghi du lieu doc tu mem vao rd
                ALUSrc = 1'b1;   // Dung immediate de tinh dia chi (base + offset)
                ALUOp = ALU_ADD; // ALU cong de ra dia chi
                MemRead = 1'b1;  // Doc memory
                MemtoReg = 1'b1; // Ket qua tu Memory
            end
            OPCODE_STORE: begin // SW
                // RegWrite = 0 (mac dinh)
                ALUSrc = 1'b1;   // Dung immediate de tinh dia chi (base + offset)
                ALUOp = ALU_ADD; // ALU cong de ra dia chi
                MemWrite = 1'b1; // Ghi memory
                // MemtoReg khong quan trong
            end
            OPCODE_BRANCH: begin // BEQ
                // RegWrite = 0 (mac dinh)
                ALUSrc = 1'b0;   // So sanh rs1 va rs2
                ALUOp = ALU_SUB; // ALU tru de kiem tra bang nhau (qua co zero)
                Branch = 1'b1;   // Day la lenh branch
                // MemRead/Write = 0 (mac dinh)
                // MemtoReg khong quan trong
            end
            default: begin
                // Lenh khong xac dinh -> NOP (No Operation)
                RegWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; MemtoReg = 1'b0;
                ALUSrc = 1'b0; ALUOp = ALU_ADD; Branch = 1'b0;
            end
        endcase
    end
endmodule