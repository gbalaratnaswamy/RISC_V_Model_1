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

`endif



module processor (
    input clk, rst_n,
    output [11:0] ioout,
    input [15:0] ioin
);
    wire rst;
    assign rst = ~rst_n;
    wire regesterWs2,memReads2,memWrites2,pcImmtoRegs2,extendSigns2;
    wire [1:0] regSrcs2;
    wire jumps4;
    wire regesterWs5;
    wire [1:0] Alu2opns2,jumpSels2,jumpSels4,jumpOpn;
    wire [2:0] InstFormats2;
    wire [3:0] aluSelects2;

    wire [6:0] opcodes2,func7s2;
    wire [2:0] func3s2;

    wire [31:0] insts1,pcs1,pc4s1;
    wire [31:0] Imms2,pcs2,pc4s2,insts2,AluOuts4,PCImms4;


    wire [31:0] pcs3,pc4s3,imms3,Ras3,Rbs3,Ras2,Rbs2;
    wire [2:0] fnc3s3;
    wire regesterWs3,memReads3,memWrites3;
    wire [1:0] Alu2opns3,regSrcs3;
    wire [3:0] aluSelects3;

    

    wire [4:0] Rds5;
    reg [31:0] reg_write_datas5;

    
    // stage 1
    wire s_IFID;

    InstructionMem IM1(insts1,pcs1);  // stage 1

    programCounter pc1(pcs1,pc4s1,AluOuts4,PCImms4,jumpSels4,jumps4,clk,rst,s_IFID);  // stage 1



    // bubble and stall unit
    wire b_IFID,bubs2;

    IFID ifid1(pcs2,pc4s2,insts2,bubs2,pcs1,pc4s1,insts1,b_IFID,clk,rst,s_IFID);  // stage 1 - 2

    // stage 2
    wire [4:0] Rds2;
    assign opcodes2 = insts2[6:0];
    assign func3s2 = insts2[14:12];
    assign func7s2 = insts2[31:25];
    assign Rds2 = insts2[11:7];
    wire [1:0] WLs2;
    wire AluMulSels2;
    controller cont1(regesterWs2,regSrcs2,memReads2,memWrites2,pcImmtoRegs2,extendSigns2,Alu2opns2,
        jumpSels2,AluMulSels2,jumpOpns2,aluSelects2,InstFormats2,WLs2,opcodes2,func3s2,func7s2,bubs2);  // stage 2
 
    decoder dec1(Imms2,InstFormats2,insts2,1'b1); // stage 2
    wire [4:0] CP0rdouts5;
    wire [4:0] Raas2,Rbas2;
    assign Raas2=insts2[19:15];
    assign Rbas2=insts2[24:20];
    Regester rg1(clk,rst,regesterWs5,Rds5,reg_write_datas5,  //(CP0toRegs5?CP0rdouts5:Rds5)
        insts2[19:15],Ras2,insts2[24:20],Rbs2);  // stage 2
    
    wire [1:0] jumpSels3,WLs3;
    reg [31:0] Rs2s3;
    wire [4:0] Rds3,Raas3,Rbas3;
    wire AluMulSels3;

    // bubble and stall
    wire b_IDIE,s_IDIE;

    IDIE idie1(pcs3,pc4s3,imms3,Ras3,Rbs3,fnc3s3,regesterWs3,regSrcs3,memReads3,memWrites3,
        pcImmtoRegs3,extendSigns3,jumpSels3,jumpOpns3,AluMulSels3,Alu2opns3,aluSelects3,Rds3,Raas3,Rbas3,WLs3,
        pcs2,pc4s2,Imms2,Ras2,Rbs2,func3s2,{b_IDIE?1'b0:regesterWs2},regSrcs2,{b_IDIE?1'b0:memReads2},{b_IDIE?1'b0:memWrites2},
        pcImmtoRegs2,extendSigns2,jumpSels2,jumpOpns2,AluMulSels2,Alu2opns2,aluSelects2,Rds2,Raas2,Rbas2,WLs2,clk,rst,s_IDIE); // stage 2-3

    // stage 3  

    wire [31:0] AluOuts3,PCImms3,AOuts3;
    reg [31:0] Alubs3,Rafwd;
    // assign AluOuts3=AluMulSels3?CP0outs3:AOuts3;  // this is select for alu and mul
    assign AluOuts3=AOuts3;
    ALU alu1(AOuts3,Rafwd,Alubs3,aluSelects3);  // stage 3
    wire [31:0] CP0outs3;
    wire [4:0] CP0rdouts3;

    // cop0 cp0 (CP0outs3,Ras3,Rbs3,fnc3s3);
    
    assign PCImms3 = pcs3+imms3;


    parameter   PAluRb  = 2'd0,
                PAluImm = 2'd1,
                PAluPC  = 2'd2;


    // forwarding
    
    always @(*) begin // TODO: optimise and test 
        if(Rds4==Raas3&&regesterWs4&&(regSrcs4==0)&&(Rds4!=0))begin
            Rafwd=AluOuts4;
        end
        else if(Rds5==Raas3&&regesterWs5&&(regSrcs5==0)&&(Rds5!=0)) begin
            Rafwd=AluOuts5;
        end
        else if(Rds6==Raas3&&regesterWs6&&(Rds6!=0)) begin
            Rafwd=AluOuts6;
        end
        else begin
            Rafwd=Ras3;
        end
    end

    always @(*) begin  
        if(Rds4==Rbas3&&regesterWs4&&(regSrcs4==0)&&(Rds4!=0))begin
            Rs2s3=AluOuts4;
        end
        else if(Rds5==Rbas3&&regesterWs5&&(regSrcs5==0)&&(Rds5!=0)) begin
            Rs2s3=AluOuts5;
        end
        else if(Rds6==Rbas3&&regesterWs6&&(Rds6!=0)) begin
            Rs2s3=AluOuts6;
        end
        else begin
            Rs2s3=Rbs3;
        end
    end

    always @(*) begin 
        case(Alu2opns3)
            PAluImm: Alubs3=imms3;
            PAluPC: Alubs3=pcs3;
            default: begin
                Alubs3=Rs2s3;
                // if(Rds4==Rbas3&&regesterWs4&&(regSrcs4==0)&&(Rds4!=0))begin
                //     Alubs3=AluOuts4;
                // end
                // else if(Rds5==Rbas3&&regesterWs5&&(regSrcs5==0)&&(Rds5!=0)) begin
                //     Alubs3=AluOuts5;
                // end
                // else begin
                //     Alubs3=Rbs3;
                // end
            end
        endcase
    end

    wire [31:0] pc4s4;
    wire [2:0] fnc3s4;
    wire regesterWs4,memReads4,memWrites4,pcImmtoRegs4,extendSigns4;

    wire [1:0] WLs4,regSrcs4;
    wire [31:0] Rs2s4;
    wire [4:0] Rds4;


    //bubble and stall
    wire b_IEME,s_IEME;

    IEME ieme(pc4s4,AluOuts4,PCImms4,fnc3s4,regesterWs4,regSrcs4,memReads4,memWrites4,
    pcImmtoRegs4,extendSigns4,jumpSels4,jumpOpns4,Rs2s4,Rds4,WLs4,
    pc4s3,AluOuts3,PCImms3,fnc3s3,{b_IEME?1'b0:regesterWs3},regSrcs3,{b_IEME?1'b0:memReads3},{b_IEME?1'b0:memWrites3},pcImmtoRegs3,
    extendSigns3,jumpSels3,jumpOpns3,Rs2s3,Rds3,WLs3,clk,rst,s_IEME);

    // stage 4
    wire [31:0] Mouts4;
    Memory mem1(clk,AluOuts4,Rs2s4,memWrites4,memReads4,extendSigns4,
    WLs4,Mouts4,ioout,ioin); 
    
    assign jumps4 = (jumpOpns4)||(AluOuts4[0]^fnc3s4[0]); // TODO: test this modification needed triggers but not problem
    // always @(*) begin 
    //     case (opcodes4)
    //         InstJAL: jumps4<=1;
    //         InstJALR: jumps4<=1;
    //         InstBranch: jumps4<=(AluOuts4[0]^fnc3s4[0]);
    //         default: jumps4<=0;
    //     endcase
    // end

    wire [31:0]pc4s5,AluOuts5,PCImms5,Mouts5,CP0outs5;
    wire [1:0] regSrcs5;
    wire pcImmtoRegs5;

    //bubble and stall
    wire b_MEWB,s_MEWB;

    MEWB mewb1(pc4s5,AluOuts5,PCImms5,Mouts5,regesterWs5,regSrcs5,pcImmtoRegs5,Rds5,CP0rdouts5,
    pc4s4,AluOuts4,PCImms4,Mouts4,{b_MEWB?1'b0:regesterWs4},regSrcs4,pcImmtoRegs4,Rds4,CP0rdouts3,clk,rst,s_MEWB);

    // stage 5

    // reg_write_datas5

    always @(*) begin  // TODO: optimise this
        // if(regSrcs5==2) begin
        //     reg_write_datas5=CP0outs5;
        // end
        if(regSrcs5==1) begin
            reg_write_datas5=Mouts5;
        end
        else if (regSrcs5==3) begin
            reg_write_datas5=pc4s5;
        end
        else if (pcImmtoRegs4) begin
            reg_write_datas5=PCImms5;
        end
        else begin
            reg_write_datas5=AluOuts5;
        end
    end

    // stage 6 virtual used only for fully forwarded alu operation

    // stall
    wire s_S6,regesterWs6;
    wire [31:0]AluOuts6;
    wire [4:0]Rds6;
    s6_Forward fwds6( AluOuts6,Rds6,regesterWs6,AluOuts5,Rds5,{(regSrcs5==0)&&regesterWs5},clk,rst,s_S6);


    // stall control

    stall_Bpred stl(b_IFID,b_IDIE,b_IEME,b_MEWB,
    s_IFID,s_IDIE,s_IEME,s_MEWB,
    Rds3,Rds4,Rds5,
    Raas2,Rbas2,
    regesterWs3,regesterWs4,regesterWs5,
    regSrcs3,regSrcs4,regSrcs5,
    opcodes2,
    jumps4,
    jumpSels4);

    
    
endmodule



module s6_Forward (
    output reg [31:0] AluOuto,
    output reg [4:0] Rdo,
    output reg regesterWo,
    input [31:0] AluOut,
    input [4:0] Rd,
    input regesterW,
    input clk,rst,stall
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            AluOuto<=0;
            Rdo<=0;
            regesterWo<=0;
        end
        else begin
            if(stall) begin
                AluOuto<=AluOuto;
                Rdo<=Rdo;
                regesterWo<=regesterWo;
            end else begin
                AluOuto<=AluOut;
                Rdo<=Rd;
                regesterWo<=regesterW;
            end
        end
    end
endmodule
