`timescale 1ns / 1ps
module decoder (
    output reg [31:0] Imm,
    input [2:0] InstFormat,
    input [31:0] inst,
    input sign_ext);

    parameter   IFormatR  = 3'd0,
                IFormatI  = 3'd1,
                IFormatS  = 3'd2,
                IFormatSB = 3'd3,
                IFormatU  = 3'd4,
                IFormatUJ = 3'd5;


    always @(*) begin
        case (InstFormat)
            IFormatR:  Imm <= 0;
            IFormatI:  Imm <= {(sign_ext&&inst[31])?20'hfffff:20'b0,inst[31:20]};
            IFormatS:  Imm <= {(sign_ext&&inst[31])?20'hfffff:20'b0,inst[31:25],inst[11:7]};
            IFormatSB: Imm <= {(sign_ext&&inst[31])?20'hfffff:20'b0,inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
            IFormatU:  Imm <= {inst[31:12],{12'b0}};
            IFormatUJ: Imm <= {inst[31]?11'hFFF:11'b0,inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
            default:   Imm <= 0;
        endcase 
    end 


endmodule