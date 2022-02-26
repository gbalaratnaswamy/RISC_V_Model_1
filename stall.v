
module stall_Bpred(
    output reg b_IFID,b_IDIE,b_IEME,b_MEWB,b_CP0,
    output reg s_IFID,s_IDIE,s_IEME,s_MEWB,
    input [4:0] rds3,rds4,rds5,
    input [4:0] Raas2,Rbas2,
    input regesterWs3,regesterWs4,regesterWs5,
    input [1:0] regSrcs3,regSrcs4,regSrcs5,
    input [6:0] opcodes2,
    input jumps4,cp0stall
);
`include "parameters.vh"
// wire jumped;
// assign jumped = jumps4&&(jumpSels4!=PJumpPc4);
wire mem_s3st,mem_s4st,mem_s5st;
assign mem_s3st=((regSrcs3==1))&&regesterWs3&&(rds3!=0);
// assign mem_s4st=((regSrcs4==3)||(regSrcs4==1))&&regesterWs4&&(rds4!=0);
// assign mem_s5st=((regSrcs5==3)||(regSrcs5==1))&&regesterWs5&&(rds5!=0);
    always @(*) begin
        if (jumps4) begin
            b_IFID=1;
            b_IDIE=1;
            b_IEME=1;
            b_MEWB=0;
            b_CP0=1;
            s_IFID=0;
            s_IDIE=0;
            s_IEME=0;
            s_MEWB=0;
            
        end
        else if(cp0stall) begin
            b_IFID=0;
            b_IDIE=0;
            b_IEME=1;
            b_MEWB=0;
            b_CP0=0;
            s_IFID=1;
            s_IDIE=1;
            s_IEME=0;
            s_MEWB=0;
        end
        else if(mem_s3st)begin
            b_IFID=0;
            b_IDIE=1;
            b_IEME=0;
            b_MEWB=0;
            b_CP0=0;
            s_IFID=1;
            s_IDIE=0;
            s_IEME=0;
            s_MEWB=0;
        end
        else begin
            b_IFID=0;
            b_IDIE=0;
            b_IEME=0;
            b_MEWB=0;
            b_CP0=0;
            s_IFID=0;
            s_IDIE=0;
            s_IEME=0;
            s_MEWB=0;
        end
    end

endmodule

/*

stall for alu
stall for load
stall for jump/banch
stall for mul/div/rem
stall for cache miss


wire b_IFID,bubs2,s_IFID;
wire b_IDIE,s_IDIE;
wire b_IEME,s_IEME;
wire b_MEWB,s_MEWB;

*/