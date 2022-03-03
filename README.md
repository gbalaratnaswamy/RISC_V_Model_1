# RISC-V MicroProcessor
This repo contains verilog implementation of RISC-V 32-bit architecture based processor. It is implemented as Pipelining model and it has 5 pipelined stages.

This has 5 stages in pipelining named 

1. Instruction Fetch
2. Instruction Decode
3. Instruction Excecute
4. Memory access
5. Write Back


## Pipelining block diagram
<!-- ![RISC-V architecture](/images/RISC-V_architectute_block_diagram.png) -->
![RISC-V architecture](/images/RISC_V_Stages.png)

## Instruction Set
Following Instructions are implemented 

### R32I Base Instruction set:

| Instruction   | Instruction Type  | opcode   | fun3 | fun7     |
| ------------- | ----------------- | -------- | ---- | -------- |
| LUI           | U-type            | 0110111  |      |          |
| AUIPC         | U-type            | 0010111  |      |          |
| JAL           | UJ-type           | 1101111  |      |          |
| JALR          | I-type            | 1100111  | 000  |          |
| BEQ           | SB-type           | 1100011  | 000  |          |
| BNE           | SB-type           | 1100011  | 001  |          |
| BLT           | SB-type           | 1100011  | 100  |          |
| BGT           | SB-type           | 1100011  | 101  |          |
| BLTU          | SB-type           | 1100011  | 110  |          |
| BGTU          | SB-type           | 1100011  | 111  |          |
| LB            | I-type            | 0000011  | 000  |          |
| LH            | I-type            | 0000011  | 001  |          |
| LW            | I-type            | 0000011  | 010  |          |
| LBU           | I-type            | 0000011  | 100  |          |
| LHU           | I-type            | 0000011  | 101  |          |
| SB            | S-type            | 0100011  | 000  |          |
| SH            | S-type            | 0100011  | 001  |          |
| SW            | S-type            | 0100011  | 010  |          |
| ADDI          | I-type            | 0010011  | 000  |          |
| SLTI          | I-type            | 0010011  | 010  |          |
| SLTIU         | I-type            | 0010011  | 011  |          |
| XORI          | I-type            | 0010011  | 100  |          |
| ORI           | I-type            | 0010011  | 110  |          |
| ANDI          | I-type            | 0010011  | 111  |          |
| SLLI          | I-type            | 0010011  | 001  |          |
| SRLI          | I-type            | 0010011  | 101  |          |
| SRAI          | I-type            | 0010011  | 101  |          |
| ADD           | R-type            | 0110011  | 000  | 0000000  |
| SUB           | R-type            | 0110011  | 000  | 1000000  |
| SLL           | R-type            | 0110011  | 001  | 0000000  |
| SLT           | R-type            | 0110011  | 010  | 0000000  |
| SLTU          | R-type            | 0110011  | 011  | 0000000  |
| XOR           | R-type            | 0110011  | 100  | 0000000  |
| SRL           | R-type            | 0110011  | 101  | 0000000  |
| SRA           | R-type            | 0110011  | 101  | 1000000  |
| OR            | R-type            | 0110011  | 110  | 0000000  |
| AND           | R-type            | 0110011  | 111  | 0000000  |

### M Standard Extension
| Instruction   | Instruction Type  | opcode   | fun3 | fun7     |
| ------------- | ----------------- | -------- | ---- | -------- |
| MUL           | R-type            | 0110011  | 000  | 0000001  |
| MULH          | R-type            | 0110011  | 001  | 0000001  |
| MULHSU        | R-type            | 0110011  | 010  | 0000001  |
| MULHU         | R-type            | 0110011  | 011  | 0000001  |
| DIV           | R-type            | 0110011  | 100  | 0000001  |
| DIVU          | R-type            | 0110011  | 101  | 0000001  |
| REM           | R-type            | 0110011  | 110  | 0000001  |
| REMU          | R-type            | 0110011  | 111  | 0000001  |

## future plans
- [x] Implement forwarding for avoiding pipelining hazard
- [x] Implement stalling
- [ ] Optimise Muliplication, Division and remainder operations
- [ ] Add CSR and its instructions
- [ ] Implement interrupts
- [ ] Implement Floating Point operations
- [ ] Support for Compressed instruction standard
- [ ] Support for atomic instructions
- [ ] Implement caching
- [ ] Make single RAM for instruction and data memory (modified Harvard model)
- [ ] Optimization
 