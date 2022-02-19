`timescale 1ns / 1ps

module MEWB (
    output reg [31:0] pc4o,AluOuto,PCImmo,Mouto,
    output reg regesterWo,
    output reg [1:0] regSrco,
    output reg [4:0] Rdo,CP0Rdo,
    input [31:0] pc4,AluOut,PCImm,Mout,
    input regesterW,
    input [1:0] regSrc,
    input [4:0] Rd,CP0Rd,
    input clk,rst,stall
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pc4o<=0;
            AluOuto<=0;
            regesterWo <=0;
            regSrco <=0;
            Rdo<=0;
            PCImmo<=0;
            Mouto<=0;
            CP0Rdo<=0;
        end
        else begin
            if(stall) begin
                pc4o<=pc4o;
                AluOuto<=AluOuto;
                regesterWo <=regesterWo;
                regSrco <=regSrco;
                Rdo<=Rdo;
                PCImmo<=PCImmo;
                Mouto<=Mouto;
                CP0Rdo<=CP0Rdo;
            end else begin
                pc4o<=pc4;
                AluOuto<=AluOut;
                regesterWo <=regesterW;
                regSrco <=regSrc;
                Rdo<=Rd;
                PCImmo<=PCImm;
                Mouto<=Mout;
                CP0Rdo<=CP0Rd;
            end
            
        end
    end
endmodule