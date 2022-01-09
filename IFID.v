`timescale 1ns / 1ps
module IFID (
    output reg [31:0]pco,pc4o,insto,
    input [31:0]pc,pc4,inst,
    input clk,rst
);
    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            pco<=0;
            pc4o<=0;
            insto<=0;
        end
        else begin
            pco<=pc;
            pc4o<=pc4;
            insto<=inst;
        end
    end
endmodule