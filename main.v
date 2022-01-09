`timescale 1ns / 1ps

// `include "memory.v"
// `include "instMemory.v"
// `include "pc.v"
// `include "IFID.v"
// `include "controller.v"
// `include "decoder.v"
// `include "register.v"
// `include "IDIE.v"
// `include "ALU.v"
// `include "IEME.v"
// `include "MEWB.v"
// `include "coprocessor0.v"



module processor (
    input clk, rst_n,
    output [15:0] ioout,
    input [15:0] ioin
);
    wire rst;
    assign rst = ~rst_n;
    wire regesterWs2,memtoRegs2,memReads2,memWrites2,pc4toRegs2,pcImmtoRegs2,extendSigns2;
    reg jumps4;
    wire regesterWs5;
    wire [1:0] Alu2opns2,jumpSels2,jumpSels4;
    wire [2:0] InstFormats2;
    wire [3:0] aluSelects2;

    wire [6:0] opcodes2,func7s2;
    wire [2:0] func3s2;

    wire [31:0] insts1,pcs1,pc4s1;
    wire [31:0] Imms2,pcs2,pc4s2,insts2,AluOuts4,PCImms4;


    wire [31:0] pcs3,pc4s3,imms3,Ras3,Rbs3,Ras2,Rbs2;
    wire [2:0] fnc3s3;
    wire [6:0] opcodes3;
    wire regesterWs3,memtoRegs3,memReads3,memWrites3;
    wire [1:0] Alu2opns3;
    wire [3:0] aluSelects3;

    

    wire [4:0] Rds5;
    reg [31:0] reg_write_datas5;

    
    // stage 1

    InstructionMem IM1(insts1,pcs1);  // stage 1

    programCounter pc1(pcs1,pc4s1,AluOuts4,PCImms4,jumpSels4,jumps4,clk,rst);  // stage 1

    IFID ifid1(pcs2,pc4s2,insts2,pcs1,pc4s1,insts1,clk,rst);  // stage 1 - 2

    // stage 2
    wire [4:0] Rds2;
    assign opcodes2 = insts2[6:0];
    assign func3s2 = insts2[14:12];
    assign func7s2 = insts2[31:25];
    assign Rds2 = insts2[11:7];
    wire [1:0] WLs2;

    controller cont1(regesterWs2,memtoRegs2,memReads2,memWrites2,pc4toRegs2,pcImmtoRegs2,extendSigns2,Alu2opns2,
        jumpSels2,aluSelects2,InstFormats2,WLs2,opcodes2,func3s2,func7s2);  // stage 2
 
    decoder dec1(Imms2,InstFormats2,insts2,1'b1); // stage 2
    wire [4:0] CP0rdouts5;
    Regester rg1(clk,rst,regesterWs5,Rds5,reg_write_datas5,  //(CP0toRegs5?CP0rdouts5:Rds5)
        insts2[19:15],Ras2,insts2[24:20],Rbs2);  // stage 2
    
    wire [1:0] jumpSels3,WLs3;
    wire [31:0] Rs2s3;
    wire [4:0] Rds3;

    IDIE idie1(pcs3,pc4s3,imms3,Ras3,Rbs3,fnc3s3,opcodes3,regesterWs3,memtoRegs3,memReads3,memWrites3,
        pc4toRegs3,pcImmtoRegs3,extendSigns3,jumpSels3,Alu2opns3,aluSelects3,Rs2s3,Rds3,WLs3,
        pcs2,pc4s2,Imms2,Ras2,Rbs2,func3s2,opcodes2,regesterWs2,memtoRegs2,memReads2,memWrites2,
        pc4toRegs2,pcImmtoRegs2,extendSigns2,jumpSels2,Alu2opns2,aluSelects2,Rbs2,Rds2,WLs2,clk,rst); // stage 2-3

    // stage 3

    wire [31:0] AluOuts3,PCImms3;
    reg [31:0] Alubs3;
    ALU alu1(AluOuts3,Ras3,Alubs3,aluSelects3);  // stage 3
    wire [31:0] CP0outs3;
    wire [4:0] CP0rdouts3;
    wire cp0regWrites3;

    // cop0 cp0 (CP0outs3,CP0rdouts3,cp0regWrites3,Ras3,Rbs3,Rds3,opcodes3,fnc3s3,clk,rst);
    
    assign PCImms3 = pcs3+imms3;


    parameter   PAluRb  = 2'd0,
                PAluImm = 2'd1,
                PAluPC  = 2'd2;

    always @(*) begin
        case(Alu2opns3)
            PAluRb: Alubs3<=Rbs3;
            PAluImm: Alubs3<=imms3;
            PAluPC: Alubs3<=pcs3;
            default: Alubs3<=Rbs3;
        endcase
    end

    wire [31:0] pc4s4;
    wire [2:0] fnc3s4;
    wire [6:0] opcodes4;
    wire regesterWs4,memtoRegs4,memReads4,memWrites4,pc4toRegs4,pcImmtoRegs4,extendSigns4;

    wire [1:0] WLs4;
    wire [31:0] Rs2s4;
    wire [4:0] Rds4;

    IEME ieme(pc4s4,AluOuts4,PCImms4,fnc3s4,opcodes4,regesterWs4,memtoRegs4,memReads4,memWrites4,pc4toRegs4,
    pcImmtoRegs4,extendSigns4,jumpSels4,Rs2s4,Rds4,WLs4,
    pc4s3,AluOuts3,PCImms3,fnc3s3,opcodes3,regesterWs3,memtoRegs3,memReads3,memWrites3,pc4toRegs3,pcImmtoRegs3,
    extendSigns3,jumpSels3,Rs2s3,Rds3,WLs3,clk,rst);

    // stage 4
    wire [31:0] Mouts4;
    Memory mem1(clk,AluOuts4,Rs2s4,memWrites4,memReads4,extendSigns4,
    WLs4,Mouts4,ioout,ioin); 

    parameter   InstJAL    = 7'b1101111, 
                InstJALR   = 7'b1100111,
                InstBranch = 7'b1100011;

    always @(*) begin
        case (opcodes4)
            InstJAL: jumps4<=1;
            InstJALR: jumps4<=1;
            InstBranch: jumps4<=(AluOuts4[0]^fnc3s4[0]);
            default: jumps4<=0;
        endcase
    end

    wire [31:0]pc4s5,AluOuts5,PCImms5,Mouts5,CP0outs5;
    wire memtoRegs5,pc4toRegs5,pcImmtoRegs5;
    MEWB mewb1(pc4s5,AluOuts5,PCImms5,Mouts5,CP0outs5,regesterWs5,memtoRegs5,pc4toRegs5,pcImmtoRegs5,CP0toRegs5,Rds5,CP0rdouts5,
    pc4s4,AluOuts4,PCImms4,Mouts4,CP0outs3,regesterWs4,memtoRegs4,pc4toRegs4,pcImmtoRegs4,cp0regWrites3,Rds4,CP0rdouts3,clk,rst);

    // stage 5

    // reg_write_datas5

    always @(*) begin
        if(CP0toRegs5) begin
            reg_write_datas5<=CP0outs5;
        end
        if(memtoRegs5) begin
            reg_write_datas5<=Mouts5;
        end
        else if (pc4toRegs4) begin
            reg_write_datas5<=pc4s5;
        end
        else if (pcImmtoRegs4) begin
            reg_write_datas5<=PCImms5;
        end
        else begin
            reg_write_datas5<=AluOuts5;
        end
    end

    
endmodule
