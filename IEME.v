`timescale 1ns / 1ps
module IEME (
    output reg [31:0] pc4o,AluOuto,PCImmo,
    output reg [2:0] fnc3o,
    // output reg [6:0] opcodeo,
    output reg regesterWo,
    output reg [1:0] regSrco,
    output reg memReado,memWriteo,pcImmtoRego,extendSigno,
    output reg [1:0] jumpSelo,
    output reg jumpOpno,
    output reg [31:0] Rs1o,
    output reg [4:0] Rdo,
    output reg [1:0] WLo,
    
    input [31:0] pc4,AluOut,PCImm,
    input [2:0] fnc3,
    // input [6:0] opcode,
    input regesterW,
    input [1:0] regSrc,
    input memRead,memWrite,pcImmtoReg,extendSign,
    input [1:0] jumpSel,
    input jumpOpn,
    input [31:0] Rs1,
    input [4:0] Rd,
    input [1:0] WL, 
    input clk,rst
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pc4o<=0;
            AluOuto<=0;
            fnc3o<=0;
            // opcodeo<=0;
            regesterWo <=0;
            regSrco <=0;
            memReado <=0;
            memWriteo <=0;
            pcImmtoRego<=0;
            extendSigno<=0;
            jumpSelo<=0;
            jumpOpno<=0;
            Rs1o<=0;
            Rdo<=0;
            WLo<=0;
            PCImmo<=0;
        end
        else begin
            pc4o<=pc4;
            AluOuto<=AluOut;
            fnc3o<=fnc3;
            // opcodeo<=opcode;
            regesterWo <=regesterW;
            regSrco <=regSrc;
            memReado <=memRead;
            memWriteo <=memWrite;
            pcImmtoRego<=pcImmtoReg;
            extendSigno<=extendSign;
            jumpSelo<=jumpSel;
            jumpOpno<=jumpOpn;
            Rs1o<=Rs1;
            Rdo<=Rd;
            WLo<=WL;
            PCImmo<=PCImm;
        end
    end
endmodule