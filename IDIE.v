`timescale 1ns / 1ps
module IDIE (
    output reg [31:0] pco,pc4o,immo,Rao,Rbo,
    output reg [2:0] fnc3o,
    // output reg [6:0] opcodeo,
    output reg regesterWo,
    output reg [1:0] regSrco,
    output reg memReado,memWriteo,pcImmtoRego,extendSigno,
    output reg [1:0] jumpSelo,
    output reg jumpOpno,AluMulSelo,
    output reg [1:0] Alu2opno,
    output reg [3:0] aluSelecto,
    output reg [4:0] Rdo,Raao,Rbao,
    output reg [1:0] WLo,
    
    input [31:0]pc,pc4,imm,Ra,Rb,
    input [2:0] fnc3,
    // input [6:0] opcode,
    input regesterW,
    input [1:0] regSrc,
    input memRead,memWrite,pcImmtoReg,extendSign,
    input [1:0] jumpSel,
    input jumpOpn,AluMulSel,
    input [1:0] Alu2opn,
    input [3:0] aluSelect,
    input [4:0] Rd,Raa,Rba,
    input [1:0] WL, 
    input clk,rst,stall
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pco <=0;
            pc4o <=0;
            immo <=0;
            Rao <=0;
            Rbo <=0;
            Raao<=0;
            Rbao<=0;
            // opcodeo <=0;
            fnc3o <=0;
            regesterWo <=0;
            regSrco <=0;
            memReado <=0;
            memWriteo <=0;
            Alu2opno <=0;
            aluSelecto <=0;
            pcImmtoRego<=0;
            extendSigno<=0;
            jumpSelo<=0;
            jumpOpno<=0;
            AluMulSelo<=0;
            Rdo<=0;
            WLo<=0;
            
        end
        else begin
            if(stall) begin
                pco<=pco;
                pc4o<=pc4o;
                immo<=immo;
                Rao<=Rao;
                Rbo<=Rbo;
                Raao<=Raao;
                Rbao<=Rbao;
                fnc3o<=fnc3o;
                regesterWo <=regesterWo;
                regSrco <=regSrco;
                memReado <=memReado;
                memWriteo <=memWriteo;
                Alu2opno <=Alu2opno;
                aluSelecto <=aluSelecto;
                pcImmtoRego<=pcImmtoRego;
                extendSigno<=extendSigno;
                jumpSelo<=jumpSelo;
                jumpOpno<=jumpOpno;
                AluMulSelo<=AluMulSelo;
                Rdo<=Rdo;
                WLo<=WLo;
            end else begin
                pco<=pc;
                pc4o<=pc4;
                immo<=imm;
                Rao<=Ra;
                Rbo<=Rb;
                Raao<=Raa;
                Rbao<=Rba;
                fnc3o<=fnc3;
                // opcodeo<=opcode;
                regesterWo <=regesterW;
                regSrco <=regSrc;
                memReado <=memRead;
                memWriteo <=memWrite;
                Alu2opno <=Alu2opn;
                aluSelecto <=aluSelect;
                pcImmtoRego<=pcImmtoReg;
                extendSigno<=extendSign;
                jumpSelo<=jumpSel;
                jumpOpno<=jumpOpn;
                AluMulSelo<=AluMulSel;
                Rdo<=Rd;
                WLo<=WL;
            end
        end
    end
endmodule


