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
    output reg regesterW,memtoReg,memRead,memWrite,pc4toReg,pcImmtoReg,extendSign,
    output reg [1:0] Alu2opn,jumpSel,
    output reg [3:0] aluSelect,
    output reg [2:0] InstFormat,
    output reg [1:0] WL,

    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7
);

    parameter   PAluRb  = 2'd0,
                PAluImm = 2'd1,
                PAluPC  = 2'd2;
    

    parameter   Paddition    = 4'b0000, 
                Psubtraction = 4'b1000,
                PSLL         = 4'b0001,
                PSRL         = 4'b0101,
                PSRA         = 4'b1101,
                PLT          = 4'b0010,
                PLTU         = 4'b0011,
                PEQL         = 4'b1010,
                PEQU         = 4'b1011,
                PXOR         = 4'b0100,
                POR          = 4'b0110,
                PAND         = 4'b0111,
                Ppassa       = 4'b1110,
                Ppassb       = 4'b1111;

    parameter   PJumpPc4   = 2'b00,
                PJumpImm   = 2'b01,
                PJumpAlu   = 2'b10;
    
    parameter   InstLUI    = 7'b0110111,
                InstAUIPC  = 7'b0010111,
                InstJAL    = 7'b1101111, 
                InstJALR   = 7'b1100111,


                InstBranch = 7'b1100011,
                InstBEQ    = 7'b1100011,
                InstBNE    = 7'b1100011,
                InstBLT    = 7'b1100011,
                InstBGT    = 7'b1100011,
                InstBLTU   = 7'b1100011,
                InstBGTU   = 7'b1100011,
                
                BEQf3      = 3'b000,
                BNEf3      = 3'b001,
                BLTf3      = 3'b100,
                BGEf3      = 3'b101,
                BLTUf3     = 3'b110,
                BGEUf3     = 3'b111,



                InstLoad   = 7'b0000011,
                InstLB     = 7'b0000011,
                InstLH     = 7'b0000011,
                InstLW     = 7'b0000011,
                InstLBU    = 7'b0000011,
                InstLHU    = 7'b0000011,

                LBf3       = 3'b000,
                LHf3       = 3'b001,
                LWf3       = 3'b010,
                LBUf3      = 3'b100,
                LHUf3      = 3'b101,


                InstStore  = 7'b0100011,
                InstSB     = 7'b0100011,
                InstSH     = 7'b0100011,
                InstSW     = 7'b0100011,

                SBf3       = 3'b000,
                SHf3       = 3'b001,
                SWf3       = 3'b010,

                InstImm    = 7'b0010011,
                InstADDI   = 7'b0010011,
                InstSLTI   = 7'b0010011,
                InstSLTIU  = 7'b0010011,
                InstXORI   = 7'b0010011,
                InstORI    = 7'b0010011,
                InstANDI   = 7'b0010011,
                InstSLLI   = 7'b0010011,
                InstSRLI   = 7'b0010011,
                InstSRAI   = 7'b0010011,

                ADDIf3     = 3'b000,
                SLTIf3     = 3'b010,
                SLTIUf3    = 3'b011,
                XORIf3     = 3'b100,
                ORIf3      = 3'b110,
                ANDIf3     = 3'b111,
                SLLIf3     = 3'b001,
                SRLIf3     = 3'b101,
                SRAIf3     = 3'b101,

                InstRAlu   = 7'b0110011,
                InstSUB    = 7'b0110011,
                InstSLL    = 7'b0110011,
                InstSLT    = 7'b0110011,
                InstSLTU   = 7'b0110011,
                InstXOR    = 7'b0110011,
                InstSRL    = 7'b0110011,
                InstSRA    = 7'b0110011,
                InstOR     = 7'b0110011,
                InstAND    = 7'b0110011,

                ADDf3      = 3'b000,
                SUBf3      = 3'b000,
                SLLf3      = 3'b001,
                SLTf3      = 3'b010,
                SLTUf3     = 3'b011,
                XORf3      = 3'b100,
                SRLf3      = 3'b101,
                SRAf3      = 3'b101,
                ORf3       = 3'b110,
                ANDf3      = 3'b111,

                InstCop0   = 7'b0110011,
                
                MULf3      = 3'b000,
                MULHf3     = 3'b001,
                MULHSUf3   = 3'b010,
                MULHUf3    = 3'b011,
                DIVf3      = 3'b100,
                DIVUf3     = 3'b101,
                REMf3      = 3'b110,
                REMUf3     = 3'b111,
                
                tf =3'b1;

                
    parameter   IFormatR  = 3'd0,
                IFormatI  = 3'd1,
                IFormatS  = 3'd2,
                IFormatSB = 3'd3,
                IFormatU  = 3'd4,
                IFormatUJ = 3'd5;


    wire func75;
    assign func75 = func7[5];
    // alucont a1(aluSelect,opcode,func3,func7);

    always @(*) begin
        case (opcode)
            InstLoad: begin
                case (func3)
                    LHf3: begin 
                        extendSign<=1;
                        WL<=1;
                    end
                    LBf3: begin 
                        extendSign<=1;
                        WL<=0;
                    end
                    LBUf3: begin 
                        extendSign<=0;
                        WL<=0;
                    end
                    LHUf3: begin 
                        extendSign<=0;
                        WL<=1;
                    end
                    default: begin 
                        extendSign<=0;
                        WL<=2;
                    end
                endcase
            end
            InstStore: begin
                case (func3)
                    SBf3: begin 
                        extendSign<=0;
                        WL<=0;
                    end
                    SHf3: begin 
                        extendSign<=0;
                        WL<=1;
                    end
                    default: begin 
                        extendSign<=0;
                        WL<=2;
                    end
                endcase
            end
            default: begin 
                extendSign<=0;
                WL<=2;
            end
        endcase
    end

    always @(*) begin
        case (opcode)
            InstLUI:   begin aluSelect<=Ppassb; Alu2opn<=PAluImm;end
            InstAUIPC: begin aluSelect<=Paddition; Alu2opn<=PAluPC;end  // TODO: complete
            InstJAL:   begin aluSelect<=Paddition; Alu2opn<=PAluPC;end
            InstJALR:   begin aluSelect<=Paddition; Alu2opn<=PAluRb;end

            InstBranch: begin
                Alu2opn<=PAluRb;
                case(func3)
                    BEQf3:   aluSelect <= PEQL;   // BEQ
                    BNEf3:   aluSelect <= PEQL;   // BNE
                    BLTf3:   aluSelect <= PLT;    // BLT
                    BGEf3:   aluSelect <= PLT;    // BGE
                    BLTUf3:  aluSelect <= PLTU;   // BLTU
                    BGEUf3:  aluSelect <= PLTU;   // BGEU
                    default: aluSelect <= PEQL; 
                endcase
            end

            InstLoad: begin
                Alu2opn<=PAluImm;
                aluSelect <= Paddition;
            end

            InstStore: begin
                Alu2opn<=PAluImm;
                aluSelect <= Paddition;
            end

            InstImm: begin
                Alu2opn<=PAluImm;
                case (func3)
                    // ADDIf3:  aluSelect <= Paddition;
                    // SLTIf3:  aluSelect <= PLT;
                    // SLTIUf3: aluSelect <= PLTU;
                    // XORIf3:  aluSelect <= PXOR;
                    // ORIf3:   aluSelect <= POR;
                    // ANDIf3:  aluSelect <= PAND;
                    // SLLIf3:  aluSelect <= PSLL;
                    SRLIf3:  aluSelect <= func75?PSRA:PSRL;
                    default: aluSelect<={1'b0,func3};
                endcase
            end

            InstRAlu: begin
                Alu2opn<=PAluRb;
                case (func3)
                    ADDf3: aluSelect <= func75?Psubtraction: Paddition;
                    SRAf3: aluSelect <= func75?PSRA:PSRL;
                    default: aluSelect <= {1'b0,func3};
                endcase
            end

            InstCop0: begin
                Alu2opn<=PAluRb;
                aluSelect <= {1'b0,func3};
            end

            default: begin aluSelect<={1'b0,func3}; Alu2opn<=PAluRb;end
        endcase
    end 
    always @(*) begin
        case (opcode)
            InstLUI: begin regesterW<=1;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatU;
            end
            InstAUIPC: begin regesterW<=1;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=1;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatU;
            end
            InstJAL: begin regesterW<=1;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=1;
                jumpSel<=PJumpImm;
                InstFormat<=IFormatUJ;
            end
            InstJALR: begin regesterW<=1;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=1;
                jumpSel<=PJumpAlu;
                InstFormat<=IFormatI;
            end

            InstBranch: begin regesterW<=1;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=PJumpImm;
                InstFormat<=IFormatSB;
            end
            InstLoad: begin regesterW<=1;
                memtoReg<=1;
                memRead<=1;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatI;
            end

            InstStore: begin regesterW<=0;
                memtoReg<=0;
                memRead<=0;
                memWrite<=1;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatS;
            end

            InstImm: begin regesterW<=1;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatI;
            end

            InstRAlu: begin regesterW<=1;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatR;
            end

            InstCop0: begin regesterW<=0;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatR;
            end

            default: begin regesterW<=0;
                memtoReg<=0;
                memRead<=0;
                memWrite<=0;
                pcImmtoReg<=0;
                pc4toReg<=0;
                jumpSel<=0;
                InstFormat<=IFormatR;
            end
            
        endcase 
    end

    
    /*

    r i s sb u uj

    */
endmodule
