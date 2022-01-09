`timescale 1ns / 1ps
module IDIE (
    output reg [31:0] pco,pc4o,immo,Rao,Rbo,
    output reg [2:0] fnc3o,
    output reg [6:0] opcodeo,
    output reg regesterWo,memtoRego,memReado,memWriteo,pc4toRego,pcImmtoRego,extendSigno,
    output reg [1:0] jumpSelo,Alu2opno,
    output reg [3:0] aluSelecto,
    output reg [31:0] Rs1o,
    output reg [4:0] Rdo,
    output reg [1:0] WLo,
    
    input [31:0]pc,pc4,imm,Ra,Rb,
    input [2:0] fnc3,
    input [6:0] opcode,
    input regesterW,memtoReg,memRead,memWrite,pc4toReg,pcImmtoReg,extendSign,
    input [1:0] jumpSel,Alu2opn,
    input [3:0] aluSelect,
    input [31:0] Rs1,
    input [4:0] Rd,
    input [1:0] WL, 
    input clk,rst
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pco <=0;
            pc4o <=0;
            immo <=0;
            Rao <=0;
            Rbo <=0;
            opcodeo <=0;
            fnc3o <=0;
            regesterWo <=0;
            memtoRego <=0;
            memReado <=0;
            memWriteo <=0;
            Alu2opno <=0;
            aluSelecto <=0;
            pc4toRego<=0;
            pcImmtoRego<=0;
            extendSigno<=0;
            jumpSelo<=0;
            Rs1o<=0;
            Rdo<=0;
            WLo<=0;
            
        end
        else begin
            pco<=pc;
            pc4o<=pc4;
            immo<=imm;
            Rao<=Ra;
            Rbo<=Rb;
            fnc3o<=fnc3;
            opcodeo<=opcode;
            regesterWo <=regesterW;
            memtoRego <=memtoReg;
            memReado <=memRead;
            memWriteo <=memWrite;
            Alu2opno <=Alu2opn;
            aluSelecto <=aluSelect;
            pc4toRego<=pc4toReg;
            pcImmtoRego<=pcImmtoReg;
            extendSigno<=extendSign;
            jumpSelo<=jumpSel;
            Rs1o<=Rs1;
            Rdo<=Rd;
            WLo<=WL;
        end
    end
endmodule


