`timescale 1ns / 1ps
/*

reg write
mem ot reg
mem wirte
mem read
alu code
inst/rb

*/


module controller (
    output reg regesterW,
    output reg [1:0] RegSrc,
    output reg memRead,memWrite,pcImmtoReg,extendSign,
    output reg [1:0] Alu2opn,jumpSel,
    output reg AluMulSel,jumpOpn,
    output reg [3:0] aluSelect,
    output reg [2:0] InstFormat,
    output reg [1:0] WL,

    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input bubble);

    `include "parameters.vh"

    wire func75;
    assign func75 = func7[5];
    // alucont a1(aluSelect,opcode,func3,func7);

    always @(*) begin
        case (opcode)
            InstLoad: begin
                case (func3)
                    LHf3: begin 
                        extendSign=1;
                        WL=1;
                    end
                    LBf3: begin 
                        extendSign=1;
                        WL=0;
                    end
                    LBUf3: begin 
                        extendSign=0;
                        WL=0;
                    end
                    LHUf3: begin 
                        extendSign=0;
                        WL=1;
                    end
                    default: begin 
                        extendSign=0;
                        WL=2;
                    end
                endcase
            end
            InstStore: begin
                case (func3)
                    SBf3: begin 
                        extendSign=0;
                        WL=0;
                    end
                    SHf3: begin 
                        extendSign=0;
                        WL=1;
                    end
                    default: begin 
                        extendSign=0;
                        WL=2;
                    end
                endcase
            end
            default: begin 
                extendSign=0;
                WL=2;
            end
        endcase
    end

    always @(*) begin
        case (opcode)
            InstLUI:   begin aluSelect=Ppassb; Alu2opn=PAluImm;end
            InstAUIPC: begin aluSelect=Paddition; Alu2opn=PAluPC;end  // TODO: complete
            InstJAL:   begin aluSelect=Paddition; Alu2opn=PAluPC;end
            InstJALR:   begin aluSelect=Paddition; Alu2opn=PAluRb;end

            InstBranch: begin
                Alu2opn=PAluRb;
                case(func3)
                    BEQf3:   aluSelect = PEQL;   // BEQ
                    BNEf3:   aluSelect = PEQL;   // BNE
                    BLTf3:   aluSelect = PLT;    // BLT
                    BGEf3:   aluSelect = PLT;    // BGE
                    BLTUf3:  aluSelect = PLTU;   // BLTU
                    BGEUf3:  aluSelect = PLTU;   // BGEU
                    default: aluSelect = PEQL; 
                endcase
            end

            InstLoad: begin
                Alu2opn=PAluImm;
                aluSelect = Paddition;
            end

            InstStore: begin
                Alu2opn=PAluImm;
                aluSelect = Paddition;
            end

            InstImm: begin
                Alu2opn=PAluImm;
                case (func3)
                    // ADDIf3:  aluSelect = Paddition;
                    // SLTIf3:  aluSelect = PLT;
                    // SLTIUf3: aluSelect = PLTU;
                    // XORIf3:  aluSelect = PXOR;
                    // ORIf3:   aluSelect = POR;
                    // ANDIf3:  aluSelect = PAND;
                    // SLLIf3:  aluSelect = PSLL;
                    SRLIf3:  aluSelect = func75?PSRA:PSRL;
                    default: aluSelect={1'b0,func3};
                endcase
            end

            InstRAlu: begin
                Alu2opn=PAluRb;
                case (func3)
                    ADDf3: aluSelect = func75?Psubtraction: Paddition;
                    SRAf3: aluSelect = func75?PSRA:PSRL;
                    default: aluSelect = {1'b0,func3};
                endcase
            end

            // InstCop0: begin  // not needed
            //     Alu2opn=PAluRb;
            //     aluSelect = {1'b0,func3};
            // end

            default: begin aluSelect={1'b0,func3}; Alu2opn=PAluRb;end
        endcase
    end 
    always @(*) begin
        case (opcode)
            InstLUI: begin regesterW=(!bubble);
                RegSrc=0;
                memRead=0;
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=0;
                InstFormat=IFormatU;
                AluMulSel=0;
            end
            InstAUIPC: begin regesterW=(!bubble);
                RegSrc=0;
                memRead=0;
                memWrite=0;
                pcImmtoReg=1;
                jumpSel=0;
                InstFormat=IFormatU;
                AluMulSel=0;
            end
            InstJAL: begin regesterW=(!bubble);
                RegSrc=3;
                memRead=0;
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=PJumpImm;
                InstFormat=IFormatUJ;
                AluMulSel=0;
            end
            InstJALR: begin regesterW=(!bubble);
                RegSrc=3;
                memRead=0;
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=PJumpAlu;
                InstFormat=IFormatI;
                AluMulSel=0;
            end

            InstBranch: begin regesterW=(!bubble);
                RegSrc=0;
                memRead=0;
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=PJumpImm;
                InstFormat=IFormatSB;
                AluMulSel=0;
            end
            InstLoad: begin regesterW=(!bubble);
                RegSrc=1;
                memRead=(!bubble);
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=0;
                InstFormat=IFormatI;
                AluMulSel=0;
            end

            InstStore: begin regesterW=0;
                RegSrc=0;
                memRead=0;
                memWrite=(!bubble);
                pcImmtoReg=0;
                jumpSel=0;
                InstFormat=IFormatS;
                AluMulSel=0;
            end

            InstImm: begin regesterW=(!bubble);
                RegSrc=0;
                memRead=0;
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=0;
                InstFormat=IFormatI;
                AluMulSel=0;
            end

            InstRAlu: begin regesterW=(!bubble);
                RegSrc=0;
                memRead=0;
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=0;
                InstFormat=IFormatR;
                AluMulSel=(func7==7'b0000001);
            end

            // InstCop0: begin regesterW=0; // BUG: fix this
            //     RegSrc=2;
            //     memRead=0;
            //     memWrite=0;
            //     pcImmtoReg=0;
            //     jumpSel=0;
            //     InstFormat=IFormatR;
            // end

            default: begin regesterW=0;
                RegSrc=0;
                memRead=0;
                memWrite=0;
                pcImmtoReg=0;
                jumpSel=0;
                InstFormat=IFormatR;
            end
            
        endcase 
    end

    always @(*) begin
        case (opcode)
            InstJAL: jumpOpn=1;
            InstJALR: jumpOpn=1;
            default: jumpOpn=0;
        endcase
    end
    
    /*

    r i s sb u uj

    */
endmodule
