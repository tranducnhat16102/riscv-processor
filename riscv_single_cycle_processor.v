module riscv_single_cycle_processor (
    input clk,
    input rst
);

   // Tin hieu dieu khien
    wire        RegWrite, MemRead, MemWrite, MemtoReg, ALUSrc, Branch;
    wire [3:0]  ALUOp;

    // Du lieu và dia chi
    wire [31:0] pc_current;
    wire [31:0] pc_next, pc_plus_4;
    wire [31:0] instruction;
    wire [31:0] imm_extended;
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire        alu_zero_flag;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;
    wire [31:0] branch_target_addr;
    wire        pc_src; // 0: PC+4, 1: Branch Target

    //--- Instantiate Modules ---

    // Program Counter
    pc_reg PC_REG (
        .clk(clk), .rst(rst), .pc_in(pc_next), .pc_out(pc_current)
    );

    // Adder for PC+4
    adder PC_ADDER (
        .operand_a(pc_current), .operand_b(32'd4), .result(pc_plus_4)
    );

    // Instruction Memory
    instruction_memory #( .MEM_DEPTH(256) ) IMEM (
        .address(pc_current), .instruction(instruction)
    );

    // Control Unit
    control_unit CONTROL (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        //.funct7(instruction[31:25]), // Uncomment if needed for R-type differentiation
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .MemtoReg(MemtoReg), .ALUSrc(ALUSrc), .ALUOp(ALUOp),
        .Branch(Branch)
    );

    // Register File
    register_file REGFILE (
        .clk(clk), .rst(rst),
        .reg_write_en(RegWrite),
        .read_addr1(instruction[19:15]), // rs1
        .read_addr2(instruction[24:20]), // rs2
        .write_addr(instruction[11:7]),  // rd
        .write_data(write_back_data),
        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );

    // Immediate Generator
    immediate_generator IMM_GEN (
        .instruction(instruction),
        .imm_extended(imm_extended)
    );

    // MUX for ALU Operand B
    mux2to1 #(32) ALU_SRC_MUX (
        .select(ALUSrc),
        .in0(rs2_data),
        .in1(imm_extended),
        .out(alu_operand_b)
    );

    // ALU
    alu ALU_UNIT (
        .operand_a(rs1_data),
        .operand_b(alu_operand_b),
        .alu_op(ALUOp),
        .result(alu_result),
        .zero_flag(alu_zero_flag)
    );

    // Data Memory
    data_memory #( .DATA_MEM_DEPTH(256) ) DMEM (
        .clk(clk),
        .mem_read_en(MemRead),
        .mem_write_en(MemWrite),
        .address(alu_result), // Address from ALU
        .write_data(rs2_data), // Data to write from rs2
        .read_data(mem_read_data)
    );

    // MUX for Write Back data
    mux2to1 #(32) WB_MUX (
        .select(MemtoReg),
        .in0(alu_result),
        .in1(mem_read_data),
        .out(write_back_data)
    );

    // Adder for Branch Target Address
    adder BRANCH_ADDER (
        .operand_a(pc_current),
        .operand_b(imm_extended), // Immediate for B-type (already shifted)
        .result(branch_target_addr)
    );

    // PC Source Selection Logic (BEQ condition)
    // Branch happens if Branch signal is active AND zero flag is active
    assign pc_src = Branch & alu_zero_flag;

    // MUX for Next PC
    mux2to1 #(32) PC_MUX (
        .select(pc_src),
        .in0(pc_plus_4),
        .in1(branch_target_addr),
        .out(pc_next)
    );

    // --- Helper Modules (Need to be defined) ---
    // Example: pc_reg, adder, mux2to1
 // --- TASKS FOR EACH STAGE ---

    // Instruction Fetch
    task fetch;
        begin
            $display("[FETCH] PC = %h", pc_current);
            $display("[FETCH] Instruction = %h", instruction);
        end
    endtask

    // Instruction Decode
    task decode;
        begin
            $display("[DECODE] rs1 = x%0d = %h", instruction[19:15], rs1_data);
            $display("[DECODE] rs2 = x%0d = %h", instruction[24:20], rs2_data);
            $display("[DECODE] imm = %h", imm_extended);
            $display("[DECODE] ALUOp = %b, ALUSrc = %b", ALUOp, ALUSrc);
        end
    endtask

    // Execute
    task execute;
        begin
            $display("[EXECUTE] ALU Operand A = %h", rs1_data);
            $display("[EXECUTE] ALU Operand B = %h", alu_operand_b);
            $display("[EXECUTE] Result = %h, Zero = %b", alu_result, alu_zero_flag);
        end
    endtask

    // Writeback
    task writeback;
        begin
            $display("[WRITEBACK] Write back to x%0d = %h", instruction[11:7], write_back_data);
        end
    endtask

endmodule

//--- Helper Module Definitions ---
module pc_reg ( input clk, rst, input [31:0] pc_in, output reg [31:0] pc_out );
    always @(posedge clk or posedge rst) begin
        if (rst) pc_out <= 32'b0;
        else pc_out <= pc_in;
    end
endmodule

module adder ( input [31:0] operand_a, input [31:0] operand_b, output [31:0] result );
    assign result = operand_a + operand_b;
endmodule

module mux2to1 #(parameter WIDTH = 32) ( input select, input [WIDTH-1:0] in0, input [WIDTH-1:0] in1, output [WIDTH-1:0] out );
    assign out = select ? in1 : in0;
endmodule