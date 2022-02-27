`timescale 1ns / 1ps
`ifndef FILES_INCLUDED
    `define FILES_INCLUDED

    `include "memory.v"
    `include "instMemory.v"
    `include "pc.v"
    `include "IFID.v"
    `include "controller.v"
    `include "decoder.v"
    `include "register.v"
    `include "IDIE.v"
    `include "ALU.v"
    `include "IEME.v"
    `include "MEWB.v"
    `include "coprocessor0.v"
    `include "stall.v"
    `include "stage6.v"
`endif


module processor (
    input clk, rst_n,
    output [11:0] ioout,
    input [15:0] ioin
);
    wire rst;

    wire regesterWs2,regesterWs3,regesterWs4,regesterWs5,regesterWs6;
    wire memReads2,memReads3,memReads4;
    wire memWrites2,memWrites3,memWrites4;
    wire extendSigns2,extendSigns3,extendSigns4;
    wire jumps4;
    wire [1:0] Alu2opns2,Alu2opns3;
    wire [1:0] jumpSels2,jumpSels3,jumpSels4;
    wire [3:0] aluSelects2,aluSelects3;
    wire AluMulSels2,AluMulSels3;
    wire [2:0] InstFormats2;
    wire [6:0] opcodes2,func7s2;
    wire [2:0] func3s2,fnc3s3;
    wire [31:0] insts1,insts2;
    wire [1:0] regSrcs4,regSrcs5,regSrcs3,regSrcs2;

    wire [31:0] pc4s1,pc4s2,pc4s3,pc4s4;
    wire [31:0] pcs1,pcs3,pcs2;
    wire [31:0] PCImms3,PCImms4;

    wire [31:0] Imms2,imms3;
    wire [31:0] AluOuts3,AluOuts4;
    reg [31:0] Alubs3;
    // wire [31:0] CP0outs3;
    wire [31:0] reg_write_data_halfs5,reg_write_datas6;
    reg [31:0] reg_write_datas5;
    reg [31:0] reg_write_data_halfs4;

    wire [31:0] Ras3,Rbs3,Ras2,Rbs2;
    wire [4:0] Raas2,Rbas2,Raas3,Rbas3;
    reg [31:0] Rs2s3;
    reg [31:0] Rafwd;
    wire [31:0] Rs2s4;
    wire [4:0] Rds2,Rds3,Rds4,Rds5,Rds6;

    wire [1:0] WLs2,WLs3,WLs4;
    wire [31:0] Mouts4,Mouts5;
    
    wire s_IFID,b_IFID,bubs2,b_IDIE,s_IDIE,b_IEME,s_IEME,b_MEWB,s_MEWB,s_S6;

    wire [2:0] fnc3s4;
    wire cp0ok,b_CP0;
    wire [31:0] CP0outs3,CP0outs4;


    assign rst = ~rst_n;


    // stage 1  IF stage

    InstructionMem IM1(insts1,pcs1); // stage 1

    programCounter pc1(pcs1,pc4s1,AluOuts4,PCImms4,jumpSels4,jumps4,clk,rst,s_IFID);  // stage 1 and 4

    IFID ifid1(pcs2,pc4s2,insts2,bubs2,pcs1,pc4s1,insts1,b_IFID,clk,rst,s_IFID);  // stage 1 - 2

    // stage 2 ID stage
    
    // seperating instruction
    assign opcodes2 = insts2[6:0];
    assign func3s2  = insts2[14:12];
    assign func7s2  = insts2[31:25];
    assign Rds2     = insts2[11:7];
    assign Raas2    = insts2[19:15];
    assign Rbas2    = insts2[24:20];
    
    controller cont1(regesterWs2,regSrcs2,memReads2,memWrites2,extendSigns2,Alu2opns2,
        jumpSels2,AluMulSels2,jumpOpns2,aluSelects2,InstFormats2,WLs2,opcodes2,func3s2,func7s2,bubs2);  // stage 2
 
    decoder dec1(Imms2,InstFormats2,insts2,1'b1); // stage 2
    
    Regester rg1(clk,rst,regesterWs5,Rds5,reg_write_datas5,  
        Raas2,Ras2,Rbas2,Rbs2);  // stage 2 and stage 5

    IDIE idie1(pcs3,pc4s3,imms3,Ras3,Rbs3,fnc3s3,regesterWs3,regSrcs3,memReads3,memWrites3,
        extendSigns3,jumpSels3,jumpOpns3,AluMulSels3,Alu2opns3,aluSelects3,Rds3,Raas3,Rbas3,WLs3,
        pcs2,pc4s2,Imms2,Ras2,Rbs2,func3s2,{b_IDIE?1'b0:regesterWs2},regSrcs2,{b_IDIE?1'b0:memReads2},{b_IDIE?1'b0:memWrites2},
        extendSigns2,jumpSels2,jumpOpns2,AluMulSels2,Alu2opns2,aluSelects2,Rds2,Raas2,Rbas2,WLs2,clk,rst,s_IDIE); // stage 2-3


    // stage 3  IE unit

    assign PCImms3 = pcs3+imms3; // seperate adder for calculating PC + Imm


    ALU alu1(AluOuts3,Rafwd,Alubs3,aluSelects3);  // stage 3

    cop0 cp0 (CP0outs3,cp0ok,Rafwd,Alubs3,fnc3s3,{b_CP0?1'b0:AluMulSels3},clk,rst); // TODO: implemet bubble
    `include "parameters.vh"

    // Data forwarding unit
    always @(*) begin // TODO: optimise and test 
        if(Rds4==Raas3&&regesterWs4&&(regSrcs4==0)&&(Rds4!=0))begin
            Rafwd=reg_write_data_halfs4;
        end
        else if(Rds5==Raas3&&regesterWs5&&(Rds5!=0)) begin
            Rafwd=reg_write_datas5;
        end
        else if(Rds6==Raas3&&regesterWs6&&(Rds6!=0)) begin
            Rafwd=reg_write_datas6;
        end
        else begin
            Rafwd=Ras3;
        end
    end

    always @(*) begin  
        if(Rds4==Rbas3&&regesterWs4&&(regSrcs4!=1)&&(Rds4!=0))begin
            Rs2s3=reg_write_data_halfs4;
        end
        else if(Rds5==Rbas3&&regesterWs5&&(Rds5!=0)) begin
            Rs2s3=reg_write_datas5;
        end
        else if(Rds6==Rbas3&&regesterWs6&&(Rds6!=0)) begin
            Rs2s3=reg_write_datas6;
        end
        else begin
            Rs2s3=Rbs3;
        end
    end

    // ALU 2nd input select
    always @(*) begin 
        case(Alu2opns3)
            PAluImm: Alubs3=imms3;
            PAluPC: Alubs3=pcs3;
            default: begin
                Alubs3=Rs2s3;
            end
        endcase
    end
    

    IEME ieme(pc4s4,AluOuts4,PCImms4,CP0outs4,fnc3s4,regesterWs4,regSrcs4,memReads4,memWrites4,
    extendSigns4,AluMulSels4,jumpSels4,jumpOpns4,Rs2s4,Rds4,WLs4,
    pc4s3,AluOuts3,PCImms3,CP0outs3,fnc3s3,{b_IEME?1'b0:regesterWs3},regSrcs3,{b_IEME?1'b0:memReads3},{b_IEME?1'b0:memWrites3},
    extendSigns3,AluMulSels3,jumpSels3,jumpOpns3,Rs2s3,Rds3,WLs3,clk,rst,s_IEME);  // stage 3-4

    // stage 4
    
    Memory mem1(clk,AluOuts4,Rs2s4,memWrites4,memReads4,extendSigns4,
    WLs4,Mouts4,ioout,ioin); 
    
    assign jumps4 = ((jumpOpns4)||(AluOuts4[0]^fnc3s4[0]))&&(jumpSels4!=PJumpPc4);  //TODO: test this

    // reg input select
    always @(*) begin 
        case(regSrcs4)
            2'd3: reg_write_data_halfs4=pc4s4;
            2'd2: reg_write_data_halfs4=PCImms4;
            // 2'd0: reg_write_data_halfs4=AluMulSels4?CP0outs4:AluOuts4; //or other optimal method
            // default: reg_write_data_halfs4=AluOuts4;
            default: reg_write_data_halfs4=AluMulSels4?CP0outs4:AluOuts4;
        endcase
    end

    MEWB mewb1(reg_write_data_halfs5,Mouts5,regesterWs5,regSrcs5,Rds5,
    reg_write_data_halfs4,Mouts4,{b_MEWB?1'b0:regesterWs4},regSrcs4,Rds4,clk,rst,s_MEWB); // stage 4-5

    // stage 5

    // reg input select
    always @(*) begin
        case(regSrcs5)
            2'd1:reg_write_datas5=Mouts5;
            default: reg_write_datas5=reg_write_data_halfs5;
        endcase
    end

    // stage 6 (virtual) used only for fully forwarded alu operation
    s6_Forward fwds6( reg_write_datas6,Rds6,regesterWs6,reg_write_datas5,Rds5,regesterWs5,clk,rst,s_S6);

    // stall control
    stall_Bpred stl(b_IFID,b_IDIE,b_IEME,b_MEWB,b_CP0,s_IFID,s_IDIE,s_IEME,s_MEWB,
    Rds3,Rds4,Rds5,Raas2,Rbas2,regesterWs3,regesterWs4,regesterWs5,
    regSrcs3,regSrcs4,regSrcs5,opcodes2,jumps4,cp0ok);
    
endmodule