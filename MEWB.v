`timescale 1ns / 1ps

module MEWB (
    output reg [31:0] reg_write_data_halfo,Mouto,
    output reg regesterWo,
    output reg [1:0] regSrco,
    output reg [4:0] Rdo,
    input [31:0] reg_write_data_half,Mout,
    input regesterW,
    input [1:0] regSrc,
    input [4:0] Rd,
    input clk,rst,stall
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            reg_write_data_halfo<=0;
            regesterWo <=0;
            regSrco <=0;
            Rdo<=0;
            Mouto<=0;
        end
        else begin
            if(stall) begin
                reg_write_data_halfo <= reg_write_data_halfo;
                regesterWo <=regesterWo;
                regSrco <=regSrco;
                Rdo<=Rdo;
                Mouto<=Mouto;

            end else begin
                reg_write_data_halfo<=reg_write_data_half;
                regesterWo <=regesterW;
                regSrco <=regSrc;
                Rdo<=Rd;
                Mouto<=Mout;
            end
            
        end
    end
endmodule