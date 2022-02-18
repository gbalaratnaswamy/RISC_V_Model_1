`timescale 1ns / 1ps

`define FILES_INCLUDED

//module InstructionMem(
//    output [31:0] instruction,
//    input [31:0] address
//    );    
//    reg [31:0] instrmem [1023:0];
//    assign instruction = instrmem[address[31:2]];

//    initial begin
//        $readmemb("instr.txt", instrmem);
//    end
//endmodule


module InstructionMem(
    output reg [31:0] instruction,
    input [31:0] address
    );    
    wire [5:0] shaddr;
    assign shaddr = address[7:2];
    // reg [31:0] instrmem [1023:0];
    // assign instruction = instrmem[address[31:2]];
    always @(*) begin
        case (shaddr)
            6'b000000: instruction <= 32'b00000000000000000000000000010011;
            6'b000001: instruction <= 32'b00000000000000000001000010110111;
            6'b000010: instruction <= 32'b00000000000000001010000110000011;
            6'b000011: instruction <= 32'b11100000000000000000000100010011;
            6'b000100: instruction <= 32'b00000001000000011101001000010011;
            6'b000101: instruction <= 32'b00000000001000100110001010110011;
            6'b000110: instruction <= 32'b00000000010100001010000000100011;
            6'b000111: instruction <= 32'b11111110010111111111000001101111;
            6'b001000: instruction <= 32'b00000000000000001010000000100011;
            6'b001001: instruction <= 32'b00000000000000000000000000010011;
            6'b001010: instruction <= 32'b00000000000000000000000000010011;
            default: instruction <= 32'b00000000000000000000000000000000;

        endcase 
    end
endmodule