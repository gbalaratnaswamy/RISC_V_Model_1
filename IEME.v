`timescale 1ns / 1ps
module IEME (
    output reg [31:0] pc4o,AluOuto,PCImmo,CP0outo,
    output reg [2:0] fnc3o,
    // output reg [6:0] opcodeo,
    output reg regesterWo,
    output reg [1:0] regSrco,
    output reg memReado,memWriteo,extendSigno,AluMulSelo,
    output reg [1:0] jumpSelo,
    output reg jumpOpno,
    output reg [31:0] Rs1o,
    output reg [4:0] Rdo,
    output reg [1:0] WLo,
    
    input [31:0] pc4,AluOut,PCImm,CP0out,
    input [2:0] fnc3,
    // input [6:0] opcode,
    input regesterW,
    input [1:0] regSrc,
    input memRead,memWrite,extendSign,AluMulSel,
    input [1:0] jumpSel,
    input jumpOpn,
    input [31:0] Rs1,
    input [4:0] Rd,
    input [1:0] WL, 
    input clk,rst,stall
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
            extendSigno<=0;
            AluMulSelo<=0;
            jumpSelo<=0;
            jumpOpno<=0;
            Rs1o<=0;
            Rdo<=0;
            WLo<=0;
            PCImmo<=0;
            CP0outo<=0;
        end
        else begin
            if(stall) begin
                pc4o<=pc4o;
                AluOuto<=AluOuto;
                fnc3o<=fnc3o;
                // opcodeo<=opcode;
                regesterWo <=regesterWo;
                regSrco <=regSrco;
                memReado <=memReado;
                memWriteo <=memWriteo;
                extendSigno<=extendSigno;
                AluMulSelo<=AluMulSelo;
                jumpSelo<=jumpSelo;
                jumpOpno<=jumpOpno;
                Rs1o<=Rs1o;
                Rdo<=Rdo;
                WLo<=WLo;
                PCImmo<=PCImmo;
                CP0outo<=CP0outo;
            end else begin
                pc4o<=pc4;
                AluOuto<=AluOut;
                fnc3o<=fnc3;
                // opcodeo<=opcode;
                regesterWo <=regesterW;
                regSrco <=regSrc;
                memReado <=memRead;
                memWriteo <=memWrite;
                extendSigno<=extendSign;
                AluMulSelo<=AluMulSel;
                jumpSelo<=jumpSel;
                jumpOpno<=jumpOpn;
                Rs1o<=Rs1;
                Rdo<=Rd;
                WLo<=WL;
                PCImmo<=PCImm;
                CP0outo<=CP0out;
            end
        end
    end
endmodule