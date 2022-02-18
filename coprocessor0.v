// `include "multiplier.v"
// `include "divider.v"

module cop0 (
    output reg [31:0] ans,
    input [31:0] a,b,
    input [2:0] Mulfnc3
);
    `include "parameters.vh"
    
    wire [63:0] mulans;
    wire [31:0] divans,remans;
    assign mulans = a*b;
    assign divans = a/b;
    assign remans = a%b;
    always @(*) case (Mulfnc3)
        MULf3: begin
            ans = mulans[31:0];
        end
        MULHf3: begin
            ans = mulans[63:31];
        end
        MULHSUf3: begin
            ans = mulans[63:31];
        end
        MULHUf3: begin
            ans = mulans[63:31];
        end
        DIVf3: begin
            ans = divans;
        end
        DIVUf3: begin
            ans = divans;
        end
        REMf3: begin
            ans = remans;
        end
        REMUf3: begin
            ans = remans;
        end
        default: begin
            ans = mulans[31:0];
        end
    endcase 
endmodule