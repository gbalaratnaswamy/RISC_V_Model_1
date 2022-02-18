`timescale 1ns / 1ps
module Memory ( 
     input clk,
     input[31:0] mem_access_addr,  
     input [31:0] mem_write_data,  
     input mem_write_en,  
     input mem_read,  
     input sign_extend,
     input [1:0] WL,
     output [31:0] mem_read_data,
     output reg [11:0] iomem,
     input [15:0] ioin
 );  
//     wire [31:0] mem_access_addr;
//     assign mem_access_addr=mem_access_addr_8[31:0];
     wire [31:0] mem_access_addr_nor;
     assign mem_access_addr_nor = (mem_access_addr>>2);
     // integer i;  
     reg [31:0] ram [1023:0],mem_read_data1;
     
     
     always @(posedge clk)		   //ram write
   		begin
			if (mem_write_en==1) begin
                    if(mem_access_addr==4096) begin
                         iomem <= mem_write_data[11:0];
                    end
                    else begin
                        iomem<=iomem;
                    end
				case (WL)
					0: begin
						case (mem_access_addr[1:0])
							0: ram[mem_access_addr_nor] = {ram[mem_access_addr_nor][31:8],mem_write_data[7:0]};
							1: ram[mem_access_addr_nor] = {ram[mem_access_addr_nor][31:16],mem_write_data[7:0],ram[mem_access_addr_nor][7:0]};
							2: ram[mem_access_addr_nor] = {ram[mem_access_addr_nor][31:24],mem_write_data[7:0],ram[mem_access_addr_nor][15:0]};
							3: ram[mem_access_addr_nor] = {mem_write_data[7:0],ram[mem_access_addr_nor][23:0]};
						endcase
					end
					1: begin
						case (mem_access_addr[1])
							0: ram[mem_access_addr_nor] = {ram[mem_access_addr_nor][31:16],mem_write_data[15:0]};
							1: ram[mem_access_addr_nor] = {mem_write_data[15:0],ram[mem_access_addr_nor][15:0]};
						endcase
					end
					default: begin
						ram[mem_access_addr_nor] = mem_write_data;
					end
				endcase
   				// ram[mem_access_addr_nor] = mem_write_data;
			end
   		end


     always @(*)
               case (WL)
                    0: begin // BYTE
                         case (mem_access_addr[1:0]) // 31:24,23:16,15:8,7:0
                              0: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][7])?24'hffffff:24'b0,ram[mem_access_addr_nor][7:0]};
                              1: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][7])?24'hffffff:24'b0,ram[mem_access_addr_nor][15:8]};
                              2: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][7])?24'hffffff:24'b0,ram[mem_access_addr_nor][23:16]};
                              3: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][7])?24'hffffff:24'b0,ram[mem_access_addr_nor][31:24]};
                              default: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][7])?24'hffffff:24'b0,ram[mem_access_addr_nor][31:24]};
                         endcase
                    end
                    1: begin // HALFWORD
                         case (mem_access_addr[1]) 
                              0: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][15])?16'hffff:16'b0,ram[mem_access_addr_nor][15:0]};
                              1: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][15])?16'hffff:16'b0,ram[mem_access_addr_nor][31:16]};
                              default: mem_read_data1 <= {(sign_extend && ram[mem_access_addr_nor][15])?16'hffff:16'b0,ram[mem_access_addr_nor][31:16]};
                         endcase
                    end
                    // 2: mem_read_data1 <= ram[mem_access_addr_nor];
                    default:  mem_read_data1 <= ram[mem_access_addr_nor];
               endcase


     assign mem_read_data = (mem_read==1'b1) ? ((mem_access_addr==4096)?{ioin,4'b0,iomem}:mem_read_data1): 32'd0;  
     
 endmodule   


// TODO: make i/o controller



 /*
 io mappping 

 display sel 1024
 display sev 1025
 switches 1 1026
 switches 2 1027


 */


      // reg [31:0]    
     // initial begin  
     //      for(i=0;i<256;i=i+1)  
     //           ram[i] <= 16'd0;  
     // end  
     // always @(posedge clk) begin  
     //      if (mem_write_en)  begin
     //           if (mem_access_addr==1024) begin
     //                iomem[15:0] <= mem_write_data[15:0];
     //           end
     //           else
     //           ram[mem_access_addr] <= mem_write_data; 
               
     //      end 
     // end  