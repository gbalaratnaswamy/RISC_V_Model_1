`timescale 1ns / 1ps
// module MEWB (
//     output reg [31:0] pc4o,AluOuto,MemOuto,
//     output reg [2:0] fnc3o,
//     output reg [6:0] opcodeo,
//     output reg regesterWo,memtoRego,memReado,memWriteo,
//     input [31:0] pc4,AluOut,MemOut,
//     input [2:0] fnc3,
//     input [6:0] opcode,
//     input regesterW,memtoReg,memRead,memWrite,
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
//             memtoRego <=0;
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
//             memtoRego <=memtoReg;
//             memReado <=memRead;
//             memWriteo <=memWrite;
//         end
//     end
// endmodule

module MEWB (
    output reg [31:0] pc4o,AluOuto,PCImmo,Mouto,CP0outo,
    output reg regesterWo,memtoRego,pc4toRego,pcImmtoRego,CP0toRego,
    output reg [4:0] Rdo,CP0Rdo,
    input [31:0] pc4,AluOut,PCImm,Mout,CP0out,
    input regesterW,memtoReg,pc4toReg,pcImmtoReg,CP0toReg,
    input [4:0] Rd,CP0Rd,
    input clk,rst
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pc4o<=0;
            AluOuto<=0;
            regesterWo <=0;
            memtoRego <=0;
            pc4toRego<=0;
            pcImmtoRego<=0;
            Rdo<=0;
            PCImmo<=0;
            Mouto<=0;
            CP0outo<=0;
            CP0Rdo<=0;
            CP0toRego<=0;
        end
        else begin
            pc4o<=pc4;
            AluOuto<=AluOut;
            regesterWo <=regesterW;
            memtoRego <=memtoReg;
            pc4toRego<=pc4toReg;
            pcImmtoRego<=pcImmtoReg;
            Rdo<=Rd;
            PCImmo<=PCImm;
            Mouto<=Mout;
            CP0outo<=CP0out;
            CP0Rdo<=CP0Rd;
            CP0toRego<=CP0toReg;
        end
    end
endmodule