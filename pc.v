`timescale 1ns / 1ps


module programCounter (
    output reg [31:0] pc,
    output [31:0] pc4,
    input [31:0] AluOut,PCImm,
    input [1:0] jumpSel,
    input jump,
    input clk,rst,stall);

    `include "parameters.vh"
    
    assign pc4=pc+4;

    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            pc<=0;
        end
        else begin
            if(stall)begin
                pc<=pc;
            end else if(jump) begin
                case (jumpSel)
                    PJumpPc4: pc<=pc4;
                    PJumpImm: pc<=PCImm;
                    PJumpAlu: pc<=AluOut;
                    default: pc<=pc4;
                endcase
            end
            else begin
                pc<=pc4;
            end
            
        end
    end
endmodule