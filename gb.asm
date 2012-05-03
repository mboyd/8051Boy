;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; SETUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Emulation registers are stored in real 8051 registers, bank 0
; A and B registers are reserved for emulation code
; If additional registers are needed, must bank switch or save
; to RAM

era equ r0
; Flags are special, see below
erb equ r2
erc equ r3
erd equ r4
ere equ r5
erh equ r6
erl equ r7

; The Z flag can be expensive to compute, is modified
; by lots of instructions, and is written much more often than
; read.  As an optimization, we store the *value* determining
; Z in a register, and only compute it when required 
; by (JP Z/NZ and PUSH AF)
erzf equ r1

; We don't bother storing the N or H flags -- they're annoying to deal with
; and it turns out that most code doesn't care about them anyway.

; Carry flag storage -- cannonical value in 8051 C flag
ercf bit 0x00

; Store the PC in direct RAM
epcl data 0x30
epch data 0x31

; And the SP as well
espl data 0x32
ers data 0x32	; Pseudo-register (for convenience)
esph data 0x33
erp data 0x33	; Also psuedo-register

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; OPCODE DISPATCH ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Load next instruction
mov dpl, epcl
mov dph, epch
movx a, @dptr
; Increment the PC later, some instructions consume additional data

; 16-bit jump table nonsense here
; may need chained jump within table


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; BEGIN OPCODE TABLE ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.equ op_base, $
.equ op_step, 0x20

org op_base + 0x0 * op_step
; NOP 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x1 * op_step
; LD BC,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x2 * op_step
; LD (BC),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3 * op_step
; INC BC 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x4 * op_step
; INC B 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x5 * op_step
; DEC B 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x6 * op_step
; LD B,d8 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x7 * op_step
; RLCA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x8 * op_step
; LD (a16),SP 
;  3 bytes 
;  20 cycles 
;  - - - -

org op_base + 0x9 * op_step
; ADD HL,BC 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0xa * op_step
; LD A,(BC) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xb * op_step
; DEC BC 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xc * op_step
; INC C 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0xd * op_step
; DEC C 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0xe * op_step
; LD C,d8 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0xf * op_step
; RRCA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x10 * op_step
; STOP 0 
;  2 bytes 
;  4 cycles 
;  - - - -

org op_base + 0x11 * op_step
; LD DE,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x12 * op_step
; LD (DE),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x13 * op_step
; INC DE 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x14 * op_step
; INC D 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x15 * op_step
; DEC D 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x16 * op_step
; LD D,d8 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x17 * op_step
; RLA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x18 * op_step
; JR r8 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x19 * op_step
; ADD HL,DE 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x1a * op_step
; LD A,(DE) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x1b * op_step
; DEC DE 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x1c * op_step
; INC E 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x1d * op_step
; DEC E 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x1e * op_step
; LD E,d8 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x1f * op_step
; RRA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x20 * op_step
; JR NZ,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x21 * op_step
; LD HL,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x22 * op_step
; LD (HL+),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x23 * op_step
; INC HL 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x24 * op_step
; INC H 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x25 * op_step
; DEC H 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x26 * op_step
; LD H,d8 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x27 * op_step
; DAA 
;  1 byte 
;  4 cycles 
;  Z - 0 C

org op_base + 0x28 * op_step
; JR Z,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x29 * op_step
; ADD HL,HL 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x2a * op_step
; LD A,(HL+) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x2b * op_step
; DEC HL 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x2c * op_step
; INC L 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x2d * op_step
; DEC L 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x2e * op_step
; LD L,d8 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x2f * op_step
; CPL 
;  1 byte 
;  4 cycles 
;  - 1 1 -

org op_base + 0x30 * op_step
; JR NC,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x31 * op_step
; LD SP,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x32 * op_step
; LD (HL-),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x33 * op_step
; INC SP 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x34 * op_step
; INC (HL) 
;  1 byte 
;  12 cycles 
;  Z 0 H -

org op_base + 0x35 * op_step
; DEC (HL) 
;  1 byte 
;  12 cycles 
;  Z 1 H -

org op_base + 0x36 * op_step
; LD (HL),d8 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x37 * op_step
; SCF 
;  1 byte 
;  4 cycles 
;  - 0 0 1

org op_base + 0x38 * op_step
; JR C,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x39 * op_step
; ADD HL,SP 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x3a * op_step
; LD A,(HL-) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3b * op_step
; DEC SP 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3c * op_step
; INC A 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x3d * op_step
; DEC A 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x3e * op_step
; LD A,d8 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x3f * op_step
; CCF 
;  1 byte 
;  4 cycles 
;  - 0 0 C

org op_base + 0x40 * op_step
; LD B,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x41 * op_step
; LD B,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x42 * op_step
; LD B,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x43 * op_step
; LD B,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x44 * op_step
; LD B,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x45 * op_step
; LD B,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x46 * op_step
; LD B,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x47 * op_step
; LD B,A 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x48 * op_step
; LD C,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x49 * op_step
; LD C,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x4a * op_step
; LD C,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x4b * op_step
; LD C,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x4c * op_step
; LD C,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x4d * op_step
; LD C,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x4e * op_step
; LD C,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x4f * op_step
; LD C,A 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x50 * op_step
; LD D,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x51 * op_step
; LD D,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x52 * op_step
; LD D,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x53 * op_step
; LD D,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x54 * op_step
; LD D,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x55 * op_step
; LD D,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x56 * op_step
; LD D,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x57 * op_step
; LD D,A 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x58 * op_step
; LD E,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x59 * op_step
; LD E,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x5a * op_step
; LD E,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x5b * op_step
; LD E,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x5c * op_step
; LD E,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x5d * op_step
; LD E,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x5e * op_step
; LD E,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x5f * op_step
; LD E,A 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x60 * op_step
; LD H,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x61 * op_step
; LD H,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x62 * op_step
; LD H,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x63 * op_step
; LD H,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x64 * op_step
; LD H,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x65 * op_step
; LD H,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x66 * op_step
; LD H,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x67 * op_step
; LD H,A 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x68 * op_step
; LD L,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x69 * op_step
; LD L,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x6a * op_step
; LD L,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x6b * op_step
; LD L,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x6c * op_step
; LD L,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x6d * op_step
; LD L,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x6e * op_step
; LD L,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x6f * op_step
; LD L,A 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x70 * op_step
; LD (HL),B 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x71 * op_step
; LD (HL),C 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x72 * op_step
; LD (HL),D 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x73 * op_step
; LD (HL),E 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x74 * op_step
; LD (HL),H 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x75 * op_step
; LD (HL),L 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x76 * op_step
; HALT 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x77 * op_step
; LD (HL),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x78 * op_step
; LD A,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x79 * op_step
; LD A,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x7a * op_step
; LD A,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x7b * op_step
; LD A,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x7c * op_step
; LD A,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x7d * op_step
; LD A,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x7e * op_step
; LD A,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x7f * op_step
; LD A,A 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x80 * op_step
; ADD A,B 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x81 * op_step
; ADD A,C 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x82 * op_step
; ADD A,D 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x83 * op_step
; ADD A,E 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x84 * op_step
; ADD A,H 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x85 * op_step
; ADD A,L 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x86 * op_step
; ADD A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 0 H C

org op_base + 0x87 * op_step
; ADD A,A 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x88 * op_step
; ADC A,B 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x89 * op_step
; ADC A,C 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8a * op_step
; ADC A,D 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8b * op_step
; ADC A,E 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8c * op_step
; ADC A,H 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8d * op_step
; ADC A,L 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8e * op_step
; ADC A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 0 H C

org op_base + 0x8f * op_step
; ADC A,A 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x90 * op_step
; SUB B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x91 * op_step
; SUB C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x92 * op_step
; SUB D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x93 * op_step
; SUB E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x94 * op_step
; SUB H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x95 * op_step
; SUB L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x96 * op_step
; SUB (HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0x97 * op_step
; SUB A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x98 * op_step
; SBC A,B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x99 * op_step
; SBC A,C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9a * op_step
; SBC A,D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9b * op_step
; SBC A,E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9c * op_step
; SBC A,H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9d * op_step
; SBC A,L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9e * op_step
; SBC A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0x9f * op_step
; SBC A,A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xa0 * op_step
; AND B 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa1 * op_step
; AND C 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa2 * op_step
; AND D 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa3 * op_step
; AND E 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa4 * op_step
; AND H 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa5 * op_step
; AND L 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa6 * op_step
; AND (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 1 0

org op_base + 0xa7 * op_step
; AND A 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa8 * op_step
; XOR B 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xa9 * op_step
; XOR C 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xaa * op_step
; XOR D 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xab * op_step
; XOR E 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xac * op_step
; XOR H 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xad * op_step
; XOR L 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xae * op_step
; XOR (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xaf * op_step
; XOR A 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb0 * op_step
; OR B 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb1 * op_step
; OR C 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb2 * op_step
; OR D 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb3 * op_step
; OR E 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb4 * op_step
; OR H 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb5 * op_step
; OR L 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb6 * op_step
; OR (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xb7 * op_step
; OR A 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb8 * op_step
; CP B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xb9 * op_step
; CP C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xba * op_step
; CP D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbb * op_step
; CP E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbc * op_step
; CP H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbd * op_step
; CP L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbe * op_step
; CP (HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0xbf * op_step
; CP A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xc0 * op_step
; RET NZ 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xc1 * op_step
; POP BC 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0xc2 * op_step
; JP NZ,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xc3 * op_step
; JP a16 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0xc4 * op_step
; CALL NZ,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xc5 * op_step
; PUSH BC 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xc6 * op_step
; ADD A,d8 
;  2 bytes 
;  8 cycles 
;  Z 0 H C

org op_base + 0xc7 * op_step
; RST 00H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xc8 * op_step
; RET Z 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xc9 * op_step
; RET 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xca * op_step
; JP Z,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xcb * op_step
; PREFIX CB 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xcc * op_step
; CALL Z,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xcd * op_step
; CALL a16 
;  3 bytes 
;  24 cycles 
;  - - - -

org op_base + 0xce * op_step
; ADC A,d8 
;  2 bytes 
;  8 cycles 
;  Z 0 H C

org op_base + 0xcf * op_step
; RST 08H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xd0 * op_step
; RET NC 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xd1 * op_step
; POP DE 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0xd2 * op_step
; JP NC,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xd3 * op_step
; (unused)

org op_base + 0xd4 * op_step
; CALL NC,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xd5 * op_step
; PUSH DE 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xd6 * op_step
; SUB d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0xd7 * op_step
; RST 10H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xd8 * op_step
; RET C 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xd9 * op_step
; RETI 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xda * op_step
; JP C,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xdb * op_step
; (unused)

org op_base + 0xdc * op_step
; CALL C,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xdd * op_step
; (unused)

org op_base + 0xde * op_step
; SBC A,d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0xdf * op_step
; RST 18H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xe0 * op_step
; LDH (a8),A 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0xe1 * op_step
; POP HL 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0xe2 * op_step
; LD (C),A 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0xe3 * op_step
; (unused)

org op_base + 0xe4 * op_step
; (unused)

org op_base + 0xe5 * op_step
; PUSH HL 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xe6 * op_step
; AND d8 
;  2 bytes 
;  8 cycles 
;  Z 0 1 0

org op_base + 0xe7 * op_step
; RST 20H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xe8 * op_step
; ADD SP,r8 
;  2 bytes 
;  16 cycles 
;  0 0 H C

org op_base + 0xe9 * op_step
; JP (HL) 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xea * op_step
; LD (a16),A 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0xeb * op_step
; (unused)

org op_base + 0xec * op_step
; (unused)

org op_base + 0xed * op_step
; (unused)

org op_base + 0xee * op_step
; XOR d8 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xef * op_step
; RST 28H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xf0 * op_step
; LDH A,(a8) 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0xf1 * op_step
; POP AF 
;  1 byte 
;  12 cycles 
;  Z N H C

org op_base + 0xf2 * op_step
; LD A,(C) 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0xf3 * op_step
; DI 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xf4 * op_step
; (unused)

org op_base + 0xf5 * op_step
; PUSH AF 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xf6 * op_step
; OR d8 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xf7 * op_step
; RST 30H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xf8 * op_step
; LD HL,SP+r8 
;  2 bytes 
;  12 cycles 
;  0 0 H C

org op_base + 0xf9 * op_step
; LD SP,HL 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xfa * op_step
; LD A,(a16) 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0xfb * op_step
; EI 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xfc * op_step
; (unused)

org op_base + 0xfd * op_step
; (unused)

org op_base + 0xfe * op_step
; CP d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0xff * op_step
; RST 38H 
;  1 byte 
;  16 cycles 
;  - - - -


done:
	loop: ljmp loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; BEGIN BIT-OP TABLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.equ cb_base, $
.equ cb_step, 0x20

org cb_base + 0x0 * cb_step
; RLC B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1 * cb_step
; RLC C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x2 * cb_step
; RLC D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3 * cb_step
; RLC E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x4 * cb_step
; RLC H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x5 * cb_step
; RLC L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x6 * cb_step
; RLC (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x7 * cb_step
; RLC A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x8 * cb_step
; RRC B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x9 * cb_step
; RRC C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xa * cb_step
; RRC D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xb * cb_step
; RRC E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xc * cb_step
; RRC H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xd * cb_step
; RRC L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xe * cb_step
; RRC (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0xf * cb_step
; RRC A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x10 * cb_step
; RL B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x11 * cb_step
; RL C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x12 * cb_step
; RL D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x13 * cb_step
; RL E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x14 * cb_step
; RL H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x15 * cb_step
; RL L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x16 * cb_step
; RL (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x17 * cb_step
; RL A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x18 * cb_step
; RR B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x19 * cb_step
; RR C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1a * cb_step
; RR D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1b * cb_step
; RR E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1c * cb_step
; RR H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1d * cb_step
; RR L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1e * cb_step
; RR (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x1f * cb_step
; RR A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x20 * cb_step
; SLA B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x21 * cb_step
; SLA C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x22 * cb_step
; SLA D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x23 * cb_step
; SLA E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x24 * cb_step
; SLA H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x25 * cb_step
; SLA L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x26 * cb_step
; SLA (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x27 * cb_step
; SLA A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x28 * cb_step
; SRA B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x29 * cb_step
; SRA C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2a * cb_step
; SRA D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2b * cb_step
; SRA E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2c * cb_step
; SRA H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2d * cb_step
; SRA L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2e * cb_step
; SRA (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 0

org cb_base + 0x2f * cb_step
; SRA A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x30 * cb_step
; SWAP B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x31 * cb_step
; SWAP C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x32 * cb_step
; SWAP D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x33 * cb_step
; SWAP E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x34 * cb_step
; SWAP H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x35 * cb_step
; SWAP L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x36 * cb_step
; SWAP (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 0

org cb_base + 0x37 * cb_step
; SWAP A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x38 * cb_step
; SRL B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x39 * cb_step
; SRL C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3a * cb_step
; SRL D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3b * cb_step
; SRL E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3c * cb_step
; SRL H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3d * cb_step
; SRL L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3e * cb_step
; SRL (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x3f * cb_step
; SRL A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x40 * cb_step
; BIT 0,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x41 * cb_step
; BIT 0,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x42 * cb_step
; BIT 0,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x43 * cb_step
; BIT 0,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x44 * cb_step
; BIT 0,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x45 * cb_step
; BIT 0,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x46 * cb_step
; BIT 0,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x47 * cb_step
; BIT 0,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x48 * cb_step
; BIT 1,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x49 * cb_step
; BIT 1,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x4a * cb_step
; BIT 1,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x4b * cb_step
; BIT 1,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x4c * cb_step
; BIT 1,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x4d * cb_step
; BIT 1,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x4e * cb_step
; BIT 1,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x4f * cb_step
; BIT 1,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x50 * cb_step
; BIT 2,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x51 * cb_step
; BIT 2,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x52 * cb_step
; BIT 2,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x53 * cb_step
; BIT 2,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x54 * cb_step
; BIT 2,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x55 * cb_step
; BIT 2,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x56 * cb_step
; BIT 2,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x57 * cb_step
; BIT 2,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x58 * cb_step
; BIT 3,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x59 * cb_step
; BIT 3,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x5a * cb_step
; BIT 3,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x5b * cb_step
; BIT 3,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x5c * cb_step
; BIT 3,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x5d * cb_step
; BIT 3,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x5e * cb_step
; BIT 3,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x5f * cb_step
; BIT 3,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x60 * cb_step
; BIT 4,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x61 * cb_step
; BIT 4,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x62 * cb_step
; BIT 4,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x63 * cb_step
; BIT 4,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x64 * cb_step
; BIT 4,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x65 * cb_step
; BIT 4,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x66 * cb_step
; BIT 4,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x67 * cb_step
; BIT 4,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x68 * cb_step
; BIT 5,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x69 * cb_step
; BIT 5,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x6a * cb_step
; BIT 5,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x6b * cb_step
; BIT 5,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x6c * cb_step
; BIT 5,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x6d * cb_step
; BIT 5,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x6e * cb_step
; BIT 5,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x6f * cb_step
; BIT 5,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x70 * cb_step
; BIT 6,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x71 * cb_step
; BIT 6,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x72 * cb_step
; BIT 6,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x73 * cb_step
; BIT 6,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x74 * cb_step
; BIT 6,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x75 * cb_step
; BIT 6,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x76 * cb_step
; BIT 6,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x77 * cb_step
; BIT 6,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x78 * cb_step
; BIT 7,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x79 * cb_step
; BIT 7,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x7a * cb_step
; BIT 7,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x7b * cb_step
; BIT 7,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x7c * cb_step
; BIT 7,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x7d * cb_step
; BIT 7,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x7e * cb_step
; BIT 7,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x7f * cb_step
; BIT 7,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x80 * cb_step
; RES 0,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x81 * cb_step
; RES 0,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x82 * cb_step
; RES 0,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x83 * cb_step
; RES 0,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x84 * cb_step
; RES 0,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x85 * cb_step
; RES 0,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x86 * cb_step
; RES 0,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x87 * cb_step
; RES 0,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x88 * cb_step
; RES 1,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x89 * cb_step
; RES 1,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x8a * cb_step
; RES 1,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x8b * cb_step
; RES 1,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x8c * cb_step
; RES 1,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x8d * cb_step
; RES 1,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x8e * cb_step
; RES 1,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x8f * cb_step
; RES 1,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x90 * cb_step
; RES 2,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x91 * cb_step
; RES 2,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x92 * cb_step
; RES 2,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x93 * cb_step
; RES 2,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x94 * cb_step
; RES 2,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x95 * cb_step
; RES 2,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x96 * cb_step
; RES 2,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x97 * cb_step
; RES 2,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x98 * cb_step
; RES 3,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x99 * cb_step
; RES 3,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x9a * cb_step
; RES 3,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x9b * cb_step
; RES 3,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x9c * cb_step
; RES 3,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x9d * cb_step
; RES 3,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0x9e * cb_step
; RES 3,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x9f * cb_step
; RES 3,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa0 * cb_step
; RES 4,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa1 * cb_step
; RES 4,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa2 * cb_step
; RES 4,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa3 * cb_step
; RES 4,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa4 * cb_step
; RES 4,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa5 * cb_step
; RES 4,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa6 * cb_step
; RES 4,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xa7 * cb_step
; RES 4,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa8 * cb_step
; RES 5,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xa9 * cb_step
; RES 5,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xaa * cb_step
; RES 5,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xab * cb_step
; RES 5,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xac * cb_step
; RES 5,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xad * cb_step
; RES 5,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xae * cb_step
; RES 5,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xaf * cb_step
; RES 5,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb0 * cb_step
; RES 6,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb1 * cb_step
; RES 6,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb2 * cb_step
; RES 6,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb3 * cb_step
; RES 6,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb4 * cb_step
; RES 6,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb5 * cb_step
; RES 6,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb6 * cb_step
; RES 6,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xb7 * cb_step
; RES 6,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb8 * cb_step
; RES 7,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xb9 * cb_step
; RES 7,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xba * cb_step
; RES 7,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xbb * cb_step
; RES 7,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xbc * cb_step
; RES 7,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xbd * cb_step
; RES 7,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xbe * cb_step
; RES 7,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xbf * cb_step
; RES 7,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc0 * cb_step
; SET 0,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc1 * cb_step
; SET 0,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc2 * cb_step
; SET 0,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc3 * cb_step
; SET 0,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc4 * cb_step
; SET 0,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc5 * cb_step
; SET 0,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc6 * cb_step
; SET 0,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xc7 * cb_step
; SET 0,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc8 * cb_step
; SET 1,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xc9 * cb_step
; SET 1,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xca * cb_step
; SET 1,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xcb * cb_step
; SET 1,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xcc * cb_step
; SET 1,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xcd * cb_step
; SET 1,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xce * cb_step
; SET 1,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xcf * cb_step
; SET 1,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd0 * cb_step
; SET 2,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd1 * cb_step
; SET 2,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd2 * cb_step
; SET 2,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd3 * cb_step
; SET 2,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd4 * cb_step
; SET 2,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd5 * cb_step
; SET 2,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd6 * cb_step
; SET 2,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xd7 * cb_step
; SET 2,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd8 * cb_step
; SET 3,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xd9 * cb_step
; SET 3,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xda * cb_step
; SET 3,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xdb * cb_step
; SET 3,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xdc * cb_step
; SET 3,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xdd * cb_step
; SET 3,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xde * cb_step
; SET 3,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xdf * cb_step
; SET 3,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe0 * cb_step
; SET 4,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe1 * cb_step
; SET 4,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe2 * cb_step
; SET 4,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe3 * cb_step
; SET 4,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe4 * cb_step
; SET 4,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe5 * cb_step
; SET 4,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe6 * cb_step
; SET 4,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xe7 * cb_step
; SET 4,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe8 * cb_step
; SET 5,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xe9 * cb_step
; SET 5,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xea * cb_step
; SET 5,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xeb * cb_step
; SET 5,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xec * cb_step
; SET 5,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xed * cb_step
; SET 5,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xee * cb_step
; SET 5,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xef * cb_step
; SET 5,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf0 * cb_step
; SET 6,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf1 * cb_step
; SET 6,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf2 * cb_step
; SET 6,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf3 * cb_step
; SET 6,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf4 * cb_step
; SET 6,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf5 * cb_step
; SET 6,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf6 * cb_step
; SET 6,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xf7 * cb_step
; SET 6,A 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf8 * cb_step
; SET 7,B 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xf9 * cb_step
; SET 7,C 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xfa * cb_step
; SET 7,D 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xfb * cb_step
; SET 7,E 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xfc * cb_step
; SET 7,H 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xfd * cb_step
; SET 7,L 
;  2 bytes 
;  8 cycles 
;  - - - -

org cb_base + 0xfe * cb_step
; SET 7,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0xff * cb_step
; SET 7,A 
;  2 bytes 
;  8 cycles 
;  - - - -


.end