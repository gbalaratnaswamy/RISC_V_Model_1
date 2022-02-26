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


// module D_forward(
//     output reg [31:0] Rafwd,Rs2s3,
//     input [31:0] reg_write_data_halfs4,reg_write_datas5,reg_write_datas6,Ras3,Rbs3,
//     input [4:0] Rds4,Raas3,Rbas3,Rds5,Rds6,
//     input regesterWs4,regesterWs5,regesterWs6,
//     input [1:0] regSrcs4);

//     always @(*) begin // TODO: optimise and test 
//         if(Rds4==Raas3&&regesterWs4&&(regSrcs4==0)&&(Rds4!=0))begin
//             Rafwd=reg_write_data_halfs4;
//         end
//         else if(Rds5==Raas3&&regesterWs5&&(Rds5!=0)) begin
//             Rafwd=reg_write_datas5;
//         end
//         else if(Rds6==Raas3&&regesterWs6&&(Rds6!=0)) begin
//             Rafwd=reg_write_datas6;
//         end
//         else begin
//             Rafwd=Ras3;
//         end
//     end

//     always @(*) begin  
//         if(Rds4==Rbas3&&regesterWs4&&(regSrcs4!=1)&&(Rds4!=0))begin
//             Rs2s3=reg_write_data_halfs4;
//         end
//         else if(Rds5==Rbas3&&regesterWs5&&(Rds5!=0)) begin
//             Rs2s3=reg_write_datas5;
//         end
//         else if(Rds6==Rbas3&&regesterWs6&&(Rds6!=0)) begin
//             Rs2s3=reg_write_datas6;
//         end
//         else begin
//             Rs2s3=Rbs3;
//         end
//     end

// endmodule