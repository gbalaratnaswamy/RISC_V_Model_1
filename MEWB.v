`timescale 1ns / 1ps
// module MEWB (
//     output reg [31:0] pc4o,AluOuto,MemOuto,
//     output reg [2:0] fnc3o,
//     output reg [6:0] opcodeo,
//     output reg regesterWo,regSrco,memReado,memWriteo,
//     input [31:0] pc4,AluOut,MemOut,
//     input [2:0] fnc3,
//     input [6:0] opcode,
//     input regesterW,regSrc,memRead,memWrite,
//     input clk,rst
// );
//     always @(posedge clk, negedge rst) begin
//         if(rst)begin
//             pc4o<=0;
//             AluOuto<=0;
//             MemOuto<=0;
//             fnc3o<=0;
//             opcodeo<=0;
//             regesterWo <=0;
//             regSrco <=0;
//             memReado <=0;
//             memWriteo <=0;
//         end
//         else begin
//             pc4o<=pc4;
//             AluOuto<=AluOut;
//             MemOuto<=MemOut;
//             fnc3o<=fnc3;
//             opcodeo<=opcode;
//             regesterWo <=regesterW;
//             regSrco <=regSrc;
//             memReado <=memRead;
//             memWriteo <=memWrite;
//         end
//     end
// endmodule

module MEWB (
    output reg [31:0] pc4o,AluOuto,PCImmo,Mouto,
    output reg regesterWo,
    output reg [1:0] regSrco,
    output reg pcImmtoRego,
    output reg [4:0] Rdo,CP0Rdo,
    input [31:0] pc4,AluOut,PCImm,Mout,
    input regesterW,
    input [1:0] regSrc,
    input pcImmtoReg,
    input [4:0] Rd,CP0Rd,
    input clk,rst
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pc4o<=0;
            AluOuto<=0;
            regesterWo <=0;
            regSrco <=0;
            pcImmtoRego<=0;
            Rdo<=0;
            PCImmo<=0;
            Mouto<=0;
            CP0Rdo<=0;
        end
        else begin
            pc4o<=pc4;
            AluOuto<=AluOut;
            regesterWo <=regesterW;
            regSrco <=regSrc;
            pcImmtoRego<=pcImmtoReg;
            Rdo<=Rd;
            PCImmo<=PCImm;
            Mouto<=Mout;
            CP0Rdo<=CP0Rd;
        end
    end
endmodule