 `timescale 1ns / 1ps
 
     /*

    add                      0000
    sub                      1000
    logical shift left       0001
    lt                       0010
    lt unsig                 0011
    xor                      0100
    logical shift right      0101
    arthematic shift right   1101
    or                       0110
    and                      0111

    eql                      1010
    eqlu                     1011
    
    
    not
    arthematic shift left
    
    */




module ALU (
    output reg [31:0] out,
    input [31:0] a,b,
    input [3:0] select
    );
    wire [31:0] aout,shout;
    wire lt,eq;
    wire [1:0] sh_select;

    `include "parameters.vh"

    
    add_sub ad(aout, a,b,select[3]);

    shift sh(shout, a,b[4:0],sh_select);

    compare cmp(lt,eq,a,b,select[0]);
    assign sh_select ={(select[2]&&select[0]&&(!select[1])),select[3]};  // TODO: test this
    // always @(*) begin
    //     case (select)
    //         PSLL: sh_select<=0;
    //         PSRL: sh_select <=2'b10;
    //         PSRA: sh_select<= 2'b11;
    //         default: sh_select<=0;
    //     endcase
    // end

    always @(*) begin
        case (select)

            Paddition    : out <= aout; // addition
            Psubtraction : out <= aout; // Subtraction

            PSLL         : out <= shout; // log shift left
            PSRL         : out <= shout; // log shift right
            PSRA         : out <= shout; // arth shift right

            PLT          : out <= {31'b0,lt}; // less than
            PLTU         : out <= {31'b0,lt}; // less than unsigned
            PEQL         : out <= {31'b0,eq}; // equal to
            PEQU         : out <= {31'b0,eq}; // equal to unsigned

            PXOR         : out <= a^b; // xor
            POR          : out <= a|b; // or
            PAND         : out <= a&b; // and
            Ppassa       : out <=a;
            Ppassb       : out <=b;

            default: out<=32'b0;
        endcase 
    end 

endmodule

module add_sub (
    output [31:0] out,
    // output cout,
    input [31:0] a,b,
    input sub
    );
    wire [31:0] temp;
    assign temp = b^{8{sub}};
    assign out = a+sub+temp;  // TODO: optimise this
endmodule

module compare(
    output lt,eq,
    input [31:0] a,b,
    input unsig
    );
    // assign gt = a>b;
    wire [31:0] atemp,btemp;
    assign atemp = {a[31]^(!unsig),a[30:0]^(a[31]&(!unsig))};
    assign btemp = {b[31]^(!unsig),b[30:0]^(b[31]&(!unsig))};

    assign lt = atemp<btemp;
    assign eq = atemp==btemp;
endmodule

module shift(
    output reg [31:0] out,
    input signed [31:0] a,
    input [4:0] b,
    input [1:0] select
    );
    always @(*)
        case (select)
            // 2'b00: out <= a<<b;
            // 2'b01: out <= a<<<b;
            2'b10: out <= a>>b;
            2'b11: out <= a>>>b;
            default: out <= a<<b;
        endcase
endmodule