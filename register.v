`timescale 1ns / 1ps
module Regester  (  
    input clk,rst,
    input reg_write_en,  
    input [4:0] reg_write_dest,  
    input [31:0] reg_write_data,  
    input [4:0] reg_read_addr_1,  
    output [31:0] reg_read_data_1,  
    input [4:0] reg_read_addr_2,  
    output [31:0] reg_read_data_2  
 );  
    reg [31:0] reg_array [31:0];   
    always @ (posedge clk or negedge rst) begin  
        if(!rst) begin  
            reg_array[0] <= 32'd0;
            reg_array[1] <= 32'd0;
            reg_array[2] <= 32'd0;
            reg_array[3] <= 32'd0;
            reg_array[4] <= 32'd0;
            reg_array[5] <= 32'd0;
            reg_array[6] <= 32'd0;
            reg_array[7] <= 32'd0;
            reg_array[8] <= 32'd0;
            reg_array[9] <= 32'd0;
            reg_array[10] <= 32'd0;
            reg_array[11] <= 32'd0;
            reg_array[12] <= 32'd0;
            reg_array[13] <= 32'd0;
            reg_array[14] <= 32'd0;
            reg_array[15] <= 32'd0;
            reg_array[16] <= 32'd0;
            reg_array[17] <= 32'd0;
            reg_array[18] <= 32'd0;
            reg_array[19] <= 32'd0;
            reg_array[20] <= 32'd0;
            reg_array[21] <= 32'd0;
            reg_array[22] <= 32'd0;
            reg_array[23] <= 32'd0;
            reg_array[24] <= 32'd0;
            reg_array[25] <= 32'd0;
            reg_array[26] <= 32'd0;
            reg_array[27] <= 32'd0;
            reg_array[28] <= 32'd0;
            reg_array[29] <= 32'd0;
            reg_array[30] <= 32'd0;
            reg_array[31] <= 32'd0;

        end  
        else begin  
                if(reg_write_en&&reg_write_dest) begin  
                    reg_array[reg_write_dest] <= reg_write_data;  
                end  
        end  
    end  
    assign reg_read_data_1 = ( reg_read_addr_1 == 0)? 32'b0 : reg_array[reg_read_addr_1];  
    assign reg_read_data_2 = ( reg_read_addr_2 == 0)? 32'b0 : reg_array[reg_read_addr_2];  
endmodule 