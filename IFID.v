`timescale 1ns / 1ps
module IFID (
    output reg [31:0]pco,pc4o,insto,
    output reg bubbleo,
    input [31:0]pc,pc4,inst,
    input bubble,
    input clk,rst,stall
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pco<=0;
            pc4o<=0;
            insto<=0;
            bubbleo<=0;
        end
        else begin
            if(stall)begin
                pco<=pco;
                pc4o<=pc4o;
                insto<=insto;
                bubbleo<=bubbleo;
            end else begin
                pco<=pc;
                pc4o<=pc4;
                insto<=inst;
                bubbleo<=bubble;
            end
        end
    end
endmodule