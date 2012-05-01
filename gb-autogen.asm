;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; SETUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Emulation registers are store in real 8051 registers, bank 0
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

; Store N and H in bit-addressable RAM (may change)
ernf bit 0x00
erhf bit 0x01

; Carry flag is also difficult to compute, but 

; Store the PC in direct RAM
epcl data 0x30
epch data 0x31

; And the SP as well
espl data 0x32
esph data 0x33

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; OPCODE DISPATCH ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov dpl, epcl
mov dph, epch
movx a, @dptr

; 16-bit jump table nonsense here
; may need chained jump within table


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; BEGIN OPCODE TABLE ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.equ op_base, $

org op_base + 0x0
; NOP 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x10
; LD BC,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x20
; LD (BC),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x30
; INC BC 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, #0x01
add a, erc
mov erc, a
mov a, #0x00
addc a, erb
mov erb, a
ljmp done

org op_base + 0x40
; INC B 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x50
; DEC B 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x60
; LD B,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erb, a
ljmp done

org op_base + 0x70
; RLCA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x80
; LD (a16),SP 
;  3 bytes 
;  20 cycles 
;  - - - -

org op_base + 0x90
; ADD HL,BC 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0xa0
; LD A,(BC) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xb0
; DEC BC 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, erc
clr c
subb a, #0x01
mov erc, a
mov a, erb
subb a, #0x01
mov erb, a
ljmp done

org op_base + 0xc0
; INC C 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0xd0
; DEC C 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0xe0
; LD C,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erc, a
ljmp done

org op_base + 0xf0
; RRCA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x100
; STOP 0 
;  2 bytes 
;  4 cycles 
;  - - - -

org op_base + 0x110
; LD DE,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x120
; LD (DE),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x130
; INC DE 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, #0x01
add a, ere
mov ere, a
mov a, #0x00
addc a, erd
mov erd, a
ljmp done

org op_base + 0x140
; INC D 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x150
; DEC D 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x160
; LD D,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erd, a
ljmp done

org op_base + 0x170
; RLA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x180
; JR r8 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x190
; ADD HL,DE 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x1a0
; LD A,(DE) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x1b0
; DEC DE 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, ere
clr c
subb a, #0x01
mov ere, a
mov a, erd
subb a, #0x01
mov erd, a
ljmp done

org op_base + 0x1c0
; INC E 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x1d0
; DEC E 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x1e0
; LD E,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov ere, a
ljmp done

org op_base + 0x1f0
; RRA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x200
; JR NZ,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x210
; LD HL,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x220
; LD (HL+),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x230
; INC HL 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, #0x01
add a, erl
mov erl, a
mov a, #0x00
addc a, erh
mov erh, a
ljmp done

org op_base + 0x240
; INC H 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x250
; DEC H 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x260
; LD H,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erh, a
ljmp done

org op_base + 0x270
; DAA 
;  1 byte 
;  4 cycles 
;  Z - 0 C

org op_base + 0x280
; JR Z,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x290
; ADD HL,HL 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x2a0
; LD A,(HL+) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x2b0
; DEC HL 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, erl
clr c
subb a, #0x01
mov erl, a
mov a, erh
subb a, #0x01
mov erh, a
ljmp done

org op_base + 0x2c0
; INC L 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x2d0
; DEC L 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x2e0
; LD L,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erl, a
ljmp done

org op_base + 0x2f0
; CPL 
;  1 byte 
;  4 cycles 
;  - 1 1 -

org op_base + 0x300
; JR NC,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x310
; LD SP,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x320
; LD (HL-),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x330
; INC SP 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x340
; INC (HL) 
;  1 byte 
;  12 cycles 
;  Z 0 H -

org op_base + 0x350
; DEC (HL) 
;  1 byte 
;  12 cycles 
;  Z 1 H -

org op_base + 0x360
; LD (HL),d8 
;  2 bytes 
;  12 cycles 
;  - - - -
mov a, erd
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x370
; SCF 
;  1 byte 
;  4 cycles 
;  - 0 0 1

org op_base + 0x380
; JR C,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x390
; ADD HL,SP 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x3a0
; LD A,(HL-) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3b0
; DEC SP 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3c0
; INC A 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x3d0
; DEC A 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x3e0
; LD A,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov era, a
ljmp done

org op_base + 0x3f0
; CCF 
;  1 byte 
;  4 cycles 
;  - 0 0 C

org op_base + 0x400
; LD B,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erb, a
ljmp done

org op_base + 0x410
; LD B,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erb, a
ljmp done

org op_base + 0x420
; LD B,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erb, a
ljmp done

org op_base + 0x430
; LD B,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erb, a
ljmp done

org op_base + 0x440
; LD B,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erb, a
ljmp done

org op_base + 0x450
; LD B,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erb, a
ljmp done

org op_base + 0x460
; LD B,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -
mov dpl, erl
mov dph, erh
movx a, @dptr
mov erb, a
ljmp done

org op_base + 0x470
; LD B,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erb, a
ljmp done

org op_base + 0x480
; LD C,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erc, a
ljmp done

org op_base + 0x490
; LD C,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erc, a
ljmp done

org op_base + 0x4a0
; LD C,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erc, a
ljmp done

org op_base + 0x4b0
; LD C,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erc, a
ljmp done

org op_base + 0x4c0
; LD C,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erc, a
ljmp done

org op_base + 0x4d0
; LD C,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erc, a
ljmp done

org op_base + 0x4e0
; LD C,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -
mov dpl, erl
mov dph, erh
movx a, @dptr
mov erc, a
ljmp done

org op_base + 0x4f0
; LD C,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erc, a
ljmp done

org op_base + 0x500
; LD D,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erd, a
ljmp done

org op_base + 0x510
; LD D,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erd, a
ljmp done

org op_base + 0x520
; LD D,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erd, a
ljmp done

org op_base + 0x530
; LD D,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erd, a
ljmp done

org op_base + 0x540
; LD D,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erd, a
ljmp done

org op_base + 0x550
; LD D,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erd, a
ljmp done

org op_base + 0x560
; LD D,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -
mov dpl, erl
mov dph, erh
movx a, @dptr
mov erd, a
ljmp done

org op_base + 0x570
; LD D,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erd, a
ljmp done

org op_base + 0x580
; LD E,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov ere, a
ljmp done

org op_base + 0x590
; LD E,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov ere, a
ljmp done

org op_base + 0x5a0
; LD E,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov ere, a
ljmp done

org op_base + 0x5b0
; LD E,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov ere, a
ljmp done

org op_base + 0x5c0
; LD E,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov ere, a
ljmp done

org op_base + 0x5d0
; LD E,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov ere, a
ljmp done

org op_base + 0x5e0
; LD E,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -
mov dpl, erl
mov dph, erh
movx a, @dptr
mov ere, a
ljmp done

org op_base + 0x5f0
; LD E,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov ere, a
ljmp done

org op_base + 0x600
; LD H,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erh, a
ljmp done

org op_base + 0x610
; LD H,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erh, a
ljmp done

org op_base + 0x620
; LD H,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erh, a
ljmp done

org op_base + 0x630
; LD H,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erh, a
ljmp done

org op_base + 0x640
; LD H,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erh, a
ljmp done

org op_base + 0x650
; LD H,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erh, a
ljmp done

org op_base + 0x660
; LD H,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -
mov dpl, erl
mov dph, erh
movx a, @dptr
mov erh, a
ljmp done

org op_base + 0x670
; LD H,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erh, a
ljmp done

org op_base + 0x680
; LD L,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erl, a
ljmp done

org op_base + 0x690
; LD L,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erl, a
ljmp done

org op_base + 0x6a0
; LD L,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erl, a
ljmp done

org op_base + 0x6b0
; LD L,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erl, a
ljmp done

org op_base + 0x6c0
; LD L,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erl, a
ljmp done

org op_base + 0x6d0
; LD L,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erl, a
ljmp done

org op_base + 0x6e0
; LD L,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -
mov dpl, erl
mov dph, erh
movx a, @dptr
mov erl, a
ljmp done

org op_base + 0x6f0
; LD L,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erl, a
ljmp done

org op_base + 0x700
; LD (HL),B 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, erb
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x710
; LD (HL),C 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, erc
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x720
; LD (HL),D 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, erd
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x730
; LD (HL),E 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, ere
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x740
; LD (HL),H 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, erh
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x750
; LD (HL),L 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, erl
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x760
; HALT 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x770
; LD (HL),A 
;  1 byte 
;  8 cycles 
;  - - - -
mov a, era
mov dpl, erl
mov dph, erh
movx @dptr, a
ljmp done

org op_base + 0x780
; LD A,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov era, a
ljmp done

org op_base + 0x790
; LD A,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov era, a
ljmp done

org op_base + 0x7a0
; LD A,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov era, a
ljmp done

org op_base + 0x7b0
; LD A,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov era, a
ljmp done

org op_base + 0x7c0
; LD A,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov era, a
ljmp done

org op_base + 0x7d0
; LD A,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov era, a
ljmp done

org op_base + 0x7e0
; LD A,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -
mov dpl, erl
mov dph, erh
movx a, @dptr
mov era, a
ljmp done

org op_base + 0x7f0
; LD A,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov era, a
ljmp done

org op_base + 0x800
; ADD A,B 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x810
; ADD A,C 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x820
; ADD A,D 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x830
; ADD A,E 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x840
; ADD A,H 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x850
; ADD A,L 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x860
; ADD A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 0 H C

org op_base + 0x870
; ADD A,A 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x880
; ADC A,B 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x890
; ADC A,C 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8a0
; ADC A,D 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8b0
; ADC A,E 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8c0
; ADC A,H 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8d0
; ADC A,L 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x8e0
; ADC A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 0 H C

org op_base + 0x8f0
; ADC A,A 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x900
; SUB B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x910
; SUB C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x920
; SUB D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x930
; SUB E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x940
; SUB H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x950
; SUB L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x960
; SUB (HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0x970
; SUB A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x980
; SBC A,B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x990
; SBC A,C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9a0
; SBC A,D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9b0
; SBC A,E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9c0
; SBC A,H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9d0
; SBC A,L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x9e0
; SBC A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0x9f0
; SBC A,A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xa00
; AND B 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa10
; AND C 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa20
; AND D 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa30
; AND E 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa40
; AND H 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa50
; AND L 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa60
; AND (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 1 0

org op_base + 0xa70
; AND A 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0xa80
; XOR B 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xa90
; XOR C 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xaa0
; XOR D 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xab0
; XOR E 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xac0
; XOR H 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xad0
; XOR L 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xae0
; XOR (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xaf0
; XOR A 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb00
; OR B 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb10
; OR C 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb20
; OR D 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb30
; OR E 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb40
; OR H 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb50
; OR L 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb60
; OR (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xb70
; OR A 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0xb80
; CP B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xb90
; CP C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xba0
; CP D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbb0
; CP E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbc0
; CP H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbd0
; CP L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xbe0
; CP (HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0xbf0
; CP A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0xc00
; RET NZ 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xc10
; POP BC 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0xc20
; JP NZ,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xc30
; JP a16 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0xc40
; CALL NZ,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xc50
; PUSH BC 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xc60
; ADD A,d8 
;  2 bytes 
;  8 cycles 
;  Z 0 H C

org op_base + 0xc70
; RST 00H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xc80
; RET Z 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xc90
; RET 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xca0
; JP Z,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xcb0
; PREFIX CB 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xcc0
; CALL Z,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xcd0
; CALL a16 
;  3 bytes 
;  24 cycles 
;  - - - -

org op_base + 0xce0
; ADC A,d8 
;  2 bytes 
;  8 cycles 
;  Z 0 H C

org op_base + 0xcf0
; RST 08H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xd00
; RET NC 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xd10
; POP DE 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0xd20
; JP NC,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xd30
; (unused)

org op_base + 0xd40
; CALL NC,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xd50
; PUSH DE 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xd60
; SUB d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0xd70
; RST 10H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xd80
; RET C 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0xd90
; RETI 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xda0
; JP C,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0xdb0
; (unused)

org op_base + 0xdc0
; CALL C,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0xdd0
; (unused)

org op_base + 0xde0
; SBC A,d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0xdf0
; RST 18H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xe00
; LDH (a8),A 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0xe10
; POP HL 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0xe20
; LD (C),A 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0xe30
; (unused)

org op_base + 0xe40
; (unused)

org op_base + 0xe50
; PUSH HL 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xe60
; AND d8 
;  2 bytes 
;  8 cycles 
;  Z 0 1 0

org op_base + 0xe70
; RST 20H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xe80
; ADD SP,r8 
;  2 bytes 
;  16 cycles 
;  0 0 H C

org op_base + 0xe90
; JP (HL) 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xea0
; LD (a16),A 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0xeb0
; (unused)

org op_base + 0xec0
; (unused)

org op_base + 0xed0
; (unused)

org op_base + 0xee0
; XOR d8 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xef0
; RST 28H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xf00
; LDH A,(a8) 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0xf10
; POP AF 
;  1 byte 
;  12 cycles 
;  Z N H C

org op_base + 0xf20
; LD A,(C) 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0xf30
; DI 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xf40
; (unused)

org op_base + 0xf50
; PUSH AF 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xf60
; OR d8 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org op_base + 0xf70
; RST 30H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0xf80
; LD HL,SP+r8 
;  2 bytes 
;  12 cycles 
;  0 0 H C

org op_base + 0xf90
; LD SP,HL 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xfa0
; LD A,(a16) 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0xfb0
; EI 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0xfc0
; (unused)

org op_base + 0xfd0
; (unused)

org op_base + 0xfe0
; CP d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0xff0
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

org cb_base + 0x0
; RLC B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x10
; RLC C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x20
; RLC D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x30
; RLC E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x40
; RLC H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x50
; RLC L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x60
; RLC (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x70
; RLC A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x80
; RRC B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x90
; RRC C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xa0
; RRC D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xb0
; RRC E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xc0
; RRC H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xd0
; RRC L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xe0
; RRC (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0xf0
; RRC A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x100
; RL B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x110
; RL C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x120
; RL D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x130
; RL E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x140
; RL H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x150
; RL L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x160
; RL (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x170
; RL A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x180
; RR B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x190
; RR C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1a0
; RR D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1b0
; RR E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1c0
; RR H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1d0
; RR L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1e0
; RR (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x1f0
; RR A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x200
; SLA B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x210
; SLA C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x220
; SLA D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x230
; SLA E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x240
; SLA H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x250
; SLA L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x260
; SLA (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x270
; SLA A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x280
; SRA B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x290
; SRA C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2a0
; SRA D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2b0
; SRA E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2c0
; SRA H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2d0
; SRA L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x2e0
; SRA (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 0

org cb_base + 0x2f0
; SRA A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x300
; SWAP B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x310
; SWAP C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x320
; SWAP D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x330
; SWAP E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x340
; SWAP H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x350
; SWAP L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x360
; SWAP (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 0

org cb_base + 0x370
; SWAP A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x380
; SRL B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x390
; SRL C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3a0
; SRL D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3b0
; SRL E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3c0
; SRL H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3d0
; SRL L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x3e0
; SRL (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x3f0
; SRL A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x400
; BIT 0,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x410
; BIT 0,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x420
; BIT 0,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x430
; BIT 0,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x440
; BIT 0,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x450
; BIT 0,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x460
; BIT 0,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x470
; BIT 0,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x1
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x480
; BIT 1,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x490
; BIT 1,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x4a0
; BIT 1,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x4b0
; BIT 1,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x4c0
; BIT 1,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x4d0
; BIT 1,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x4e0
; BIT 1,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x4f0
; BIT 1,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x2
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x500
; BIT 2,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x510
; BIT 2,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x520
; BIT 2,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x530
; BIT 2,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x540
; BIT 2,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x550
; BIT 2,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x560
; BIT 2,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x570
; BIT 2,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x4
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x580
; BIT 3,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x590
; BIT 3,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x5a0
; BIT 3,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x5b0
; BIT 3,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x5c0
; BIT 3,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x5d0
; BIT 3,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x5e0
; BIT 3,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x5f0
; BIT 3,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x8
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x600
; BIT 4,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x610
; BIT 4,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x620
; BIT 4,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x630
; BIT 4,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x640
; BIT 4,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x650
; BIT 4,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x660
; BIT 4,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x670
; BIT 4,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x10
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x680
; BIT 5,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x690
; BIT 5,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x6a0
; BIT 5,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x6b0
; BIT 5,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x6c0
; BIT 5,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x6d0
; BIT 5,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x6e0
; BIT 5,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x6f0
; BIT 5,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x20
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x700
; BIT 6,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x710
; BIT 6,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x720
; BIT 6,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x730
; BIT 6,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x740
; BIT 6,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x750
; BIT 6,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x760
; BIT 6,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x770
; BIT 6,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x40
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x780
; BIT 7,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erb
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x790
; BIT 7,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erc
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x7a0
; BIT 7,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erd
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x7b0
; BIT 7,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, ere
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x7c0
; BIT 7,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erh
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x7d0
; BIT 7,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, erl
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x7e0
; BIT 7,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -
mov dpl, erl
mov dph, erh
movx a, @dptr
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x7f0
; BIT 7,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -
mov a, era
anl a, #0x80
mov erzf, a
clr ernf
setb erhf
ljmp done

org cb_base + 0x800
; RES 0,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0xfe
mov erb, a
ljmp done

org cb_base + 0x810
; RES 0,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0xfe
mov erc, a
ljmp done

org cb_base + 0x820
; RES 0,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0xfe
mov erd, a
ljmp done

org cb_base + 0x830
; RES 0,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0xfe
mov ere, a
ljmp done

org cb_base + 0x840
; RES 0,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0xfe
mov erh, a
ljmp done

org cb_base + 0x850
; RES 0,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0xfe
mov erl, a
ljmp done

org cb_base + 0x860
; RES 0,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0xfe
movx @dptr, a
ljmp done

org cb_base + 0x870
; RES 0,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0xfe
mov era, a
ljmp done

org cb_base + 0x880
; RES 1,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0xfd
mov erb, a
ljmp done

org cb_base + 0x890
; RES 1,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0xfd
mov erc, a
ljmp done

org cb_base + 0x8a0
; RES 1,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0xfd
mov erd, a
ljmp done

org cb_base + 0x8b0
; RES 1,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0xfd
mov ere, a
ljmp done

org cb_base + 0x8c0
; RES 1,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0xfd
mov erh, a
ljmp done

org cb_base + 0x8d0
; RES 1,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0xfd
mov erl, a
ljmp done

org cb_base + 0x8e0
; RES 1,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0xfd
movx @dptr, a
ljmp done

org cb_base + 0x8f0
; RES 1,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0xfd
mov era, a
ljmp done

org cb_base + 0x900
; RES 2,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0xfb
mov erb, a
ljmp done

org cb_base + 0x910
; RES 2,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0xfb
mov erc, a
ljmp done

org cb_base + 0x920
; RES 2,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0xfb
mov erd, a
ljmp done

org cb_base + 0x930
; RES 2,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0xfb
mov ere, a
ljmp done

org cb_base + 0x940
; RES 2,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0xfb
mov erh, a
ljmp done

org cb_base + 0x950
; RES 2,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0xfb
mov erl, a
ljmp done

org cb_base + 0x960
; RES 2,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0xfb
movx @dptr, a
ljmp done

org cb_base + 0x970
; RES 2,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0xfb
mov era, a
ljmp done

org cb_base + 0x980
; RES 3,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0xf7
mov erb, a
ljmp done

org cb_base + 0x990
; RES 3,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0xf7
mov erc, a
ljmp done

org cb_base + 0x9a0
; RES 3,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0xf7
mov erd, a
ljmp done

org cb_base + 0x9b0
; RES 3,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0xf7
mov ere, a
ljmp done

org cb_base + 0x9c0
; RES 3,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0xf7
mov erh, a
ljmp done

org cb_base + 0x9d0
; RES 3,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0xf7
mov erl, a
ljmp done

org cb_base + 0x9e0
; RES 3,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0xf7
movx @dptr, a
ljmp done

org cb_base + 0x9f0
; RES 3,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0xf7
mov era, a
ljmp done

org cb_base + 0xa00
; RES 4,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0xef
mov erb, a
ljmp done

org cb_base + 0xa10
; RES 4,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0xef
mov erc, a
ljmp done

org cb_base + 0xa20
; RES 4,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0xef
mov erd, a
ljmp done

org cb_base + 0xa30
; RES 4,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0xef
mov ere, a
ljmp done

org cb_base + 0xa40
; RES 4,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0xef
mov erh, a
ljmp done

org cb_base + 0xa50
; RES 4,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0xef
mov erl, a
ljmp done

org cb_base + 0xa60
; RES 4,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0xef
movx @dptr, a
ljmp done

org cb_base + 0xa70
; RES 4,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0xef
mov era, a
ljmp done

org cb_base + 0xa80
; RES 5,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0xdf
mov erb, a
ljmp done

org cb_base + 0xa90
; RES 5,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0xdf
mov erc, a
ljmp done

org cb_base + 0xaa0
; RES 5,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0xdf
mov erd, a
ljmp done

org cb_base + 0xab0
; RES 5,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0xdf
mov ere, a
ljmp done

org cb_base + 0xac0
; RES 5,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0xdf
mov erh, a
ljmp done

org cb_base + 0xad0
; RES 5,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0xdf
mov erl, a
ljmp done

org cb_base + 0xae0
; RES 5,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0xdf
movx @dptr, a
ljmp done

org cb_base + 0xaf0
; RES 5,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0xdf
mov era, a
ljmp done

org cb_base + 0xb00
; RES 6,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0xbf
mov erb, a
ljmp done

org cb_base + 0xb10
; RES 6,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0xbf
mov erc, a
ljmp done

org cb_base + 0xb20
; RES 6,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0xbf
mov erd, a
ljmp done

org cb_base + 0xb30
; RES 6,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0xbf
mov ere, a
ljmp done

org cb_base + 0xb40
; RES 6,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0xbf
mov erh, a
ljmp done

org cb_base + 0xb50
; RES 6,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0xbf
mov erl, a
ljmp done

org cb_base + 0xb60
; RES 6,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0xbf
movx @dptr, a
ljmp done

org cb_base + 0xb70
; RES 6,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0xbf
mov era, a
ljmp done

org cb_base + 0xb80
; RES 7,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x7f
mov erb, a
ljmp done

org cb_base + 0xb90
; RES 7,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x7f
mov erc, a
ljmp done

org cb_base + 0xba0
; RES 7,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x7f
mov erd, a
ljmp done

org cb_base + 0xbb0
; RES 7,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x7f
mov ere, a
ljmp done

org cb_base + 0xbc0
; RES 7,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x7f
mov erh, a
ljmp done

org cb_base + 0xbd0
; RES 7,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x7f
mov erl, a
ljmp done

org cb_base + 0xbe0
; RES 7,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
orl a, #0x7f
movx @dptr, a
ljmp done

org cb_base + 0xbf0
; RES 7,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x7f
mov era, a
ljmp done

org cb_base + 0xc00
; SET 0,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x1
mov erb, a
ljmp done

org cb_base + 0xc10
; SET 0,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x1
mov erc, a
ljmp done

org cb_base + 0xc20
; SET 0,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x1
mov erd, a
ljmp done

org cb_base + 0xc30
; SET 0,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x1
mov ere, a
ljmp done

org cb_base + 0xc40
; SET 0,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x1
mov erh, a
ljmp done

org cb_base + 0xc50
; SET 0,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x1
mov erl, a
ljmp done

org cb_base + 0xc60
; SET 0,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x1
movx @dptr, a
ljmp done

org cb_base + 0xc70
; SET 0,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x1
mov era, a
ljmp done

org cb_base + 0xc80
; SET 1,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x2
mov erb, a
ljmp done

org cb_base + 0xc90
; SET 1,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x2
mov erc, a
ljmp done

org cb_base + 0xca0
; SET 1,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x2
mov erd, a
ljmp done

org cb_base + 0xcb0
; SET 1,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x2
mov ere, a
ljmp done

org cb_base + 0xcc0
; SET 1,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x2
mov erh, a
ljmp done

org cb_base + 0xcd0
; SET 1,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x2
mov erl, a
ljmp done

org cb_base + 0xce0
; SET 1,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x2
movx @dptr, a
ljmp done

org cb_base + 0xcf0
; SET 1,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x2
mov era, a
ljmp done

org cb_base + 0xd00
; SET 2,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x4
mov erb, a
ljmp done

org cb_base + 0xd10
; SET 2,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x4
mov erc, a
ljmp done

org cb_base + 0xd20
; SET 2,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x4
mov erd, a
ljmp done

org cb_base + 0xd30
; SET 2,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x4
mov ere, a
ljmp done

org cb_base + 0xd40
; SET 2,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x4
mov erh, a
ljmp done

org cb_base + 0xd50
; SET 2,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x4
mov erl, a
ljmp done

org cb_base + 0xd60
; SET 2,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x4
movx @dptr, a
ljmp done

org cb_base + 0xd70
; SET 2,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x4
mov era, a
ljmp done

org cb_base + 0xd80
; SET 3,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x8
mov erb, a
ljmp done

org cb_base + 0xd90
; SET 3,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x8
mov erc, a
ljmp done

org cb_base + 0xda0
; SET 3,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x8
mov erd, a
ljmp done

org cb_base + 0xdb0
; SET 3,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x8
mov ere, a
ljmp done

org cb_base + 0xdc0
; SET 3,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x8
mov erh, a
ljmp done

org cb_base + 0xdd0
; SET 3,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x8
mov erl, a
ljmp done

org cb_base + 0xde0
; SET 3,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x8
movx @dptr, a
ljmp done

org cb_base + 0xdf0
; SET 3,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x8
mov era, a
ljmp done

org cb_base + 0xe00
; SET 4,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x10
mov erb, a
ljmp done

org cb_base + 0xe10
; SET 4,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x10
mov erc, a
ljmp done

org cb_base + 0xe20
; SET 4,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x10
mov erd, a
ljmp done

org cb_base + 0xe30
; SET 4,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x10
mov ere, a
ljmp done

org cb_base + 0xe40
; SET 4,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x10
mov erh, a
ljmp done

org cb_base + 0xe50
; SET 4,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x10
mov erl, a
ljmp done

org cb_base + 0xe60
; SET 4,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x10
movx @dptr, a
ljmp done

org cb_base + 0xe70
; SET 4,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x10
mov era, a
ljmp done

org cb_base + 0xe80
; SET 5,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x20
mov erb, a
ljmp done

org cb_base + 0xe90
; SET 5,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x20
mov erc, a
ljmp done

org cb_base + 0xea0
; SET 5,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x20
mov erd, a
ljmp done

org cb_base + 0xeb0
; SET 5,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x20
mov ere, a
ljmp done

org cb_base + 0xec0
; SET 5,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x20
mov erh, a
ljmp done

org cb_base + 0xed0
; SET 5,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x20
mov erl, a
ljmp done

org cb_base + 0xee0
; SET 5,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x20
movx @dptr, a
ljmp done

org cb_base + 0xef0
; SET 5,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x20
mov era, a
ljmp done

org cb_base + 0xf00
; SET 6,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x40
mov erb, a
ljmp done

org cb_base + 0xf10
; SET 6,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x40
mov erc, a
ljmp done

org cb_base + 0xf20
; SET 6,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x40
mov erd, a
ljmp done

org cb_base + 0xf30
; SET 6,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x40
mov ere, a
ljmp done

org cb_base + 0xf40
; SET 6,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x40
mov erh, a
ljmp done

org cb_base + 0xf50
; SET 6,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x40
mov erl, a
ljmp done

org cb_base + 0xf60
; SET 6,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x40
movx @dptr, a
ljmp done

org cb_base + 0xf70
; SET 6,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x40
mov era, a
ljmp done

org cb_base + 0xf80
; SET 7,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x80
mov erb, a
ljmp done

org cb_base + 0xf90
; SET 7,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x80
mov erc, a
ljmp done

org cb_base + 0xfa0
; SET 7,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x80
mov erd, a
ljmp done

org cb_base + 0xfb0
; SET 7,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x80
mov ere, a
ljmp done

org cb_base + 0xfc0
; SET 7,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x80
mov erh, a
ljmp done

org cb_base + 0xfd0
; SET 7,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x80
mov erl, a
ljmp done

org cb_base + 0xfe0
; SET 7,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -
mov erh, dph
mov erl, dpl
movx a, @dptr
anl a, #0x80
movx @dptr, a
ljmp done

org cb_base + 0xff0
; SET 7,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x80
mov era, a
ljmp done


.end
