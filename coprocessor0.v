// `include "multiplier.v"
// `include "divider.v"

module cop0 (
    output reg [31:0] ans,
    output stall,
    input [31:0] a,b,
    input [2:0] Mulfnc3,
    input sel,clk,rst
);
    `include "parameters.vh"

    wire [63:0] mulans;
    reg sig_a,sig_b;
    wire ok;
    reg prevOk;
    reg start;
    assign stall = start&&(!((prevOk==0)&&ok==1));
    always @(posedge clk) begin
        prevOk=ok;
    end
    // multiplier m1(mulans,a,b,sig_a,sig_b);

    wire [31:0] D,R;
    

    always @(*) case (Mulfnc3)
        MULf3: begin
            ans = mulans[31:0];
            sig_a=0;
            sig_b=0;
            start=0;
        end
        MULHf3: begin
            ans = mulans[63:31];
            sig_a=1;
            sig_b=1;
            start=0;
        end
        MULHSUf3: begin
            ans = mulans[63:31];
            sig_a=1;
            sig_b=0;
            start=0;
        end
        MULHUf3: begin
            ans = mulans[63:31];
            sig_a=0;
            sig_b=0;
            start=0;
        end
        DIVf3: begin
            ans = D;
            sig_a=1;
            sig_b=1;
            start=sel;
        end
        DIVUf3: begin
            ans = D;
            sig_a=0;
            sig_b=0;
            start=sel;
        end
        REMf3: begin
            ans = R;
            sig_a=1;
            sig_b=1;
            start=sel;
        end
        REMUf3: begin
            ans = R;
            sig_a=0;
            sig_b=0;
            start=sel;
        end
        default: begin
            ans = mulans[31:0];
            sig_a=0;
            sig_b=0;
            start=sel;
        end
    endcase 

    // Division 
    
    // wire [31:0] a_u,b_u;
    // wire a_neg,b_neg,res_neg;
    // assign res_neg = a_neg^b_neg; 
    // assign a_neg = a[31]&&sig_a;
    // assign a_u   = a^({31{a_neg}})+a_neg;
    // assign b_neg = b[31]&&sig_b;
    // assign b_u   = b^({31{b_neg}})+b_neg;

    // Divide d1(clk,rst,stall,a,b,D,R,ok,err);  
   
endmodule

module multiplier (
    output [63:0] out,
    input [31:0] a,b,
    input sig_a,sig_b
);
    wire signed [32:0] a_t,b_t;
    wire signed [65:0] out_t;
    assign out_t = a_t*b_t;  // uses internal DSP slices for operation
    assign a_t = {sig_a&&a[31],a};
    assign b_t = {sig_b&&b[31],b};
    assign out = out_t[63:0];
endmodule



`timescale 1ns / 1ps
module Divide(  
    input clk,  
    input rst,  
    input start,  
    input [31:0] A,  
    input [31:0] B,  
    output [31:0] D,  
    output [31:0] R,  
    output ok ,   // =1 when ready to get the result   
    output err 
);  
    reg active;   // True if the divider is running  
    reg [4:0] cycle;   // Number of cycles to go  
    reg [31:0] result;   // Begin with A, end with D  
    reg [31:0] denom;   // B  
    reg [31:0] work;    // Running R  
    // Calculate the current digit  
    wire [32:0] sub = { work[30:0], result[31] } - denom;  
    assign err = !B;  
    // Send the results to our master  
    assign D = result;  
    assign R = work;  
    assign ok = ~active;
    // fpga4student.com FPGA projects, Verilog projects, VHDL projects   
    // The state machine  
    always @(posedge clk,negedge rst) begin  
        if (!rst) begin  
            active <= 0;  
            cycle <= 0;  
            result <= 0;  
            denom <= 0;  
            work <= 0;  
        end  
        //  else if(start) begin  
        else begin
            if (active) begin  
                // Run an iteration of the divide.  
                if (sub[32] == 0) begin  
                    work <= sub[31:0];  
                    result <= {result[30:0], 1'b1};  
                end  
                else begin  
                    work <= {work[30:0], result[31]};  
                    result <= {result[30:0], 1'b0};  
                end  
                if (cycle == 0) begin  
                    active <= 0;  
                end  
                cycle <= cycle - 5'd1;  

            end  
            else begin  
                // Set up for an unsigned divide.  
                if(start) begin
                    active <= 1; 
                end
                else begin
                    active <= 0;
                end
                cycle <= 5'd31;  
                result <= A;  
                denom <= B;  
                work <= 32'b0;  
                //  active <= 1;  
            end  
        end
    end  
//    end  
endmodule   