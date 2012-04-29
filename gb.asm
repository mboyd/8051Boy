;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; SETUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

era equ r0
erf equ r1
erb equ r2
erc equ r3
erd equ r4
ere equ r5
erh equ r6
erl equ r7

epcl data 0x30
epch data 0x31

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
ljmp done

org op_base + 0x8
; LD BC,d16 
;  3 bytes 
;  12 cycles 
;  - - - -


org op_base + 0x10
; LD (BC),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x18
; INC BC 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x20
; INC B 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x28
; DEC B 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x30
; LD B,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erb, a
ljmp done

org op_base + 0x38
; RLCA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x40
; LD (a16),SP 
;  3 bytes 
;  20 cycles 
;  - - - -

org op_base + 0x48
; ADD HL,BC 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x50
; LD A,(BC) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x58
; DEC BC 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x60
; INC C 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x68
; DEC C 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x70
; LD C,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erc, a
ljmp done


org op_base + 0x78
; RRCA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x80
; STOP 0 
;  2 bytes 
;  4 cycles 
;  - - - -

org op_base + 0x88
; LD DE,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x90
; LD (DE),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x98
; INC DE 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xa0
; INC D 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0xa8
; DEC D 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0xb0
; LD D,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erd, a
ljmp done


org op_base + 0xb8
; RLA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0xc0
; JR r8 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0xc8
; ADD HL,DE 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0xd0
; LD A,(DE) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xd8
; DEC DE 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0xe0
; INC E 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0xe8
; DEC E 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0xf0
; LD E,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov ere, a
ljmp done


org op_base + 0xf8
; RRA 
;  1 byte 
;  4 cycles 
;  0 0 0 C

org op_base + 0x100
; JR NZ,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x108
; LD HL,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x110
; LD (HL+),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x118
; INC HL 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x120
; INC H 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x128
; DEC H 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x130
; LD H,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erh, a
ljmp done


org op_base + 0x138
; DAA 
;  1 byte 
;  4 cycles 
;  Z - 0 C

org op_base + 0x140
; JR Z,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x148
; ADD HL,HL 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x150
; LD A,(HL+) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x158
; DEC HL 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x160
; INC L 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x168
; DEC L 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x170
; LD L,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov erl, a
ljmp done


org op_base + 0x178
; CPL 
;  1 byte 
;  4 cycles 
;  - 1 1 -

org op_base + 0x180
; JR NC,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x188
; LD SP,d16 
;  3 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x190
; LD (HL-),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x198
; INC SP 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x1a0
; INC (HL) 
;  1 byte 
;  12 cycles 
;  Z 0 H -

org op_base + 0x1a8
; DEC (HL) 
;  1 byte 
;  12 cycles 
;  Z 1 H -

org op_base + 0x1b0
; LD (HL),d8 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x1b8
; SCF 
;  1 byte 
;  4 cycles 
;  - 0 0 1

org op_base + 0x1c0
; JR C,r8 
;  2 bytes 
;  12/8 cycles 
;  - - - -

org op_base + 0x1c8
; ADD HL,SP 
;  1 byte 
;  8 cycles 
;  - 0 H C

org op_base + 0x1d0
; LD A,(HL-) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x1d8
; DEC SP 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x1e0
; INC A 
;  1 byte 
;  4 cycles 
;  Z 0 H -

org op_base + 0x1e8
; DEC A 
;  1 byte 
;  4 cycles 
;  Z 1 H -

org op_base + 0x1f0
; LD A,d8 
;  2 bytes 
;  8 cycles 
;  - - - -
inc dptr
movx a, @dptr
mov era, a
ljmp done


org op_base + 0x1f8
; CCF 
;  1 byte 
;  4 cycles 
;  - 0 0 C

org op_base + 0x200
; LD B,B 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x208
; LD B,C 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x210
; LD B,D 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x218
; LD B,E 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x220
; LD B,H 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x228
; LD B,L 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x230
; LD B,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x238
; LD B,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erb, a
ljmp done

org op_base + 0x240
; LD C,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erc, a
ljmp done

org op_base + 0x248
; LD C,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erc, a
ljmp done

org op_base + 0x250
; LD C,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erc, a
ljmp done

org op_base + 0x258
; LD C,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erc, a
ljmp done

org op_base + 0x260
; LD C,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erc, a
ljmp done

org op_base + 0x268
; LD C,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erc, a
ljmp done

org op_base + 0x270
; LD C,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x278
; LD C,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erc, a
ljmp done

org op_base + 0x280
; LD D,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erd, a
ljmp done

org op_base + 0x288
; LD D,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erd, a

org op_base + 0x290
; LD D,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erd, a
ljmp done

org op_base + 0x298
; LD D,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erd, a
ljmp done

org op_base + 0x2a0
; LD D,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erd, a
ljmp done

org op_base + 0x2a8
; LD D,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erd, a
ljmp done

org op_base + 0x2b0
; LD D,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x2b8
; LD D,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erd, a
ljmp done

org op_base + 0x2c0
; LD E,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov ere, a
ljmp done

org op_base + 0x2c8
; LD E,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov ere, a
ljmp done

org op_base + 0x2d0
; LD E,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov ere, a
ljmp done

org op_base + 0x2d8
; LD E,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov ere, a
ljmp done

org op_base + 0x2e0
; LD E,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov ere, a
ljmp done

org op_base + 0x2e8
; LD E,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov ere, a
ljmp done

org op_base + 0x2f0
; LD E,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x2f8
; LD E,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov ere, a
ljmp done

org op_base + 0x300
; LD H,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erh, a
ljmp done

org op_base + 0x308
; LD H,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erh, a
ljmp done

org op_base + 0x310
; LD H,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erh, a
ljmp done

org op_base + 0x318
; LD H,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erh, a
ljmp done

org op_base + 0x320
; LD H,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erh, a
ljmp done

org op_base + 0x328
; LD H,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erh, a
ljmp done

org op_base + 0x330
; LD H,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x338
; LD H,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erh, a
ljmp done

org op_base + 0x340
; LD L,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov erl, a
ljmp done

org op_base + 0x348
; LD L,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov erl, a
ljmp done

org op_base + 0x350
; LD L,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov erl, a
ljmp done

org op_base + 0x358
; LD L,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov erl, a
ljmp done

org op_base + 0x360
; LD L,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov erl, a
ljmp done

org op_base + 0x368
; LD L,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov erl, a
ljmp done

org op_base + 0x370
; LD L,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x378
; LD L,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov erl, a
ljmp done

org op_base + 0x380
; LD (HL),B 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x388
; LD (HL),C 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x390
; LD (HL),D 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x398
; LD (HL),E 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3a0
; LD (HL),H 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3a8
; LD (HL),L 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3b0
; HALT 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x3b8
; LD (HL),A 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3c0
; LD A,B 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erb
mov era, a
ljmp done

org op_base + 0x3c8
; LD A,C 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erc
mov era, a
ljmp done

org op_base + 0x3d0
; LD A,D 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erd
mov era, a
ljmp done

org op_base + 0x3d8
; LD A,E 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, ere
mov era, a
ljmp done

org op_base + 0x3e0
; LD A,H 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erh
mov era, a
ljmp done

org op_base + 0x3e8
; LD A,L 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, erl
mov era, a
ljmp done

org op_base + 0x3f0
; LD A,(HL) 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x3f8
; LD A,A 
;  1 byte 
;  4 cycles 
;  - - - -
mov a, era
mov era, a
ljmp done

org op_base + 0x400
; ADD A,B 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x408
; ADD A,C 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x410
; ADD A,D 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x418
; ADD A,E 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x420
; ADD A,H 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x428
; ADD A,L 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x430
; ADD A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 0 H C

org op_base + 0x438
; ADD A,A 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x440
; ADC A,B 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x448
; ADC A,C 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x450
; ADC A,D 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x458
; ADC A,E 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x460
; ADC A,H 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x468
; ADC A,L 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x470
; ADC A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 0 H C

org op_base + 0x478
; ADC A,A 
;  1 byte 
;  4 cycles 
;  Z 0 H C

org op_base + 0x480
; SUB B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x488
; SUB C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x490
; SUB D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x498
; SUB E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4a0
; SUB H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4a8
; SUB L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4b0
; SUB (HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0x4b8
; SUB A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4c0
; SBC A,B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4c8
; SBC A,C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4d0
; SBC A,D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4d8
; SBC A,E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4e0
; SBC A,H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4e8
; SBC A,L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x4f0
; SBC A,(HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0x4f8
; SBC A,A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x500
; AND B 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0x508
; AND C 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0x510
; AND D 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0x518
; AND E 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0x520
; AND H 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0x528
; AND L 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0x530
; AND (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 1 0

org op_base + 0x538
; AND A 
;  1 byte 
;  4 cycles 
;  Z 0 1 0

org op_base + 0x540
; XOR B 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x548
; XOR C 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x550
; XOR D 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x558
; XOR E 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x560
; XOR H 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x568
; XOR L 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x570
; XOR (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 0 0

org op_base + 0x578
; XOR A 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x580
; OR B 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x588
; OR C 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x590
; OR D 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x598
; OR E 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x5a0
; OR H 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x5a8
; OR L 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x5b0
; OR (HL) 
;  1 byte 
;  8 cycles 
;  Z 0 0 0

org op_base + 0x5b8
; OR A 
;  1 byte 
;  4 cycles 
;  Z 0 0 0

org op_base + 0x5c0
; CP B 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x5c8
; CP C 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x5d0
; CP D 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x5d8
; CP E 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x5e0
; CP H 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x5e8
; CP L 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x5f0
; CP (HL) 
;  1 byte 
;  8 cycles 
;  Z 1 H C

org op_base + 0x5f8
; CP A 
;  1 byte 
;  4 cycles 
;  Z 1 H C

org op_base + 0x600
; RET NZ 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0x608
; POP BC 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0x610
; JP NZ,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0x618
; JP a16 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0x620
; CALL NZ,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0x628
; PUSH BC 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x630
; ADD A,d8 
;  2 bytes 
;  8 cycles 
;  Z 0 H C

org op_base + 0x638
; RST 00H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x640
; RET Z 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0x648
; RET 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x650
; JP Z,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0x658
; PREFIX CB 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x660
; CALL Z,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0x668
; CALL a16 
;  3 bytes 
;  24 cycles 
;  - - - -

org op_base + 0x670
; ADC A,d8 
;  2 bytes 
;  8 cycles 
;  Z 0 H C

org op_base + 0x678
; RST 08H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x680
; RET NC 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0x688
; POP DE 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0x690
; JP NC,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0x698
; (unused)

org op_base + 0x6a0
; CALL NC,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0x6a8
; PUSH DE 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x6b0
; SUB d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0x6b8
; RST 10H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x6c0
; RET C 
;  1 byte 
;  20/8 cycles 
;  - - - -

org op_base + 0x6c8
; RETI 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x6d0
; JP C,a16 
;  3 bytes 
;  16/12 cycles 
;  - - - -

org op_base + 0x6d8
; (unused)

org op_base + 0x6e0
; CALL C,a16 
;  3 bytes 
;  24/12 cycles 
;  - - - -

org op_base + 0x6e8
; (unused)

org op_base + 0x6f0
; SBC A,d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0x6f8
; RST 18H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x700
; LDH (a8),A 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x708
; POP HL 
;  1 byte 
;  12 cycles 
;  - - - -

org op_base + 0x710
; LD (C),A 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x718
; (unused)

org op_base + 0x720
; (unused)

org op_base + 0x728
; PUSH HL 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x730
; AND d8 
;  2 bytes 
;  8 cycles 
;  Z 0 1 0

org op_base + 0x738
; RST 20H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x740
; ADD SP,r8 
;  2 bytes 
;  16 cycles 
;  0 0 H C

org op_base + 0x748
; JP (HL) 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x750
; LD (a16),A 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0x758
; (unused)

org op_base + 0x760
; (unused)

org op_base + 0x768
; (unused)

org op_base + 0x770
; XOR d8 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org op_base + 0x778
; RST 28H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x780
; LDH A,(a8) 
;  2 bytes 
;  12 cycles 
;  - - - -

org op_base + 0x788
; POP AF 
;  1 byte 
;  12 cycles 
;  Z N H C

org op_base + 0x790
; LD A,(C) 
;  2 bytes 
;  8 cycles 
;  - - - -

org op_base + 0x798
; DI 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x7a0
; (unused)

org op_base + 0x7a8
; PUSH AF 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x7b0
; OR d8 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org op_base + 0x7b8
; RST 30H 
;  1 byte 
;  16 cycles 
;  - - - -

org op_base + 0x7c0
; LD HL,SP+r8 
;  2 bytes 
;  12 cycles 
;  0 0 H C

org op_base + 0x7c8
; LD SP,HL 
;  1 byte 
;  8 cycles 
;  - - - -

org op_base + 0x7d0
; LD A,(a16) 
;  3 bytes 
;  16 cycles 
;  - - - -

org op_base + 0x7d8
; EI 
;  1 byte 
;  4 cycles 
;  - - - -

org op_base + 0x7e0
; (unused)

org op_base + 0x7e8
; (unused)

org op_base + 0x7f0
; CP d8 
;  2 bytes 
;  8 cycles 
;  Z 1 H C

org op_base + 0x7f8
; RST 38H 
;  1 byte 
;  16 cycles 
;  - - - -


done:
	loop: ljmp loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; BEGIN BIT-OP TABLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.equ cb_base, $

org cb_base + 0x0
; RLC B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x8
; RLC C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x10
; RLC D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x18
; RLC E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x20
; RLC H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x28
; RLC L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x30
; RLC (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x38
; RLC A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x40
; RRC B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x48
; RRC C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x50
; RRC D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x58
; RRC E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x60
; RRC H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x68
; RRC L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x70
; RRC (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x78
; RRC A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x80
; RL B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x88
; RL C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x90
; RL D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x98
; RL E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xa0
; RL H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xa8
; RL L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xb0
; RL (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0xb8
; RL A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xc0
; RR B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xc8
; RR C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xd0
; RR D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xd8
; RR E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xe0
; RR H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xe8
; RR L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0xf0
; RR (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0xf8
; RR A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x100
; SLA B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x108
; SLA C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x110
; SLA D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x118
; SLA E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x120
; SLA H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x128
; SLA L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x130
; SLA (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x138
; SLA A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x140
; SRA B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x148
; SRA C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x150
; SRA D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x158
; SRA E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x160
; SRA H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x168
; SRA L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x170
; SRA (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 0

org cb_base + 0x178
; SRA A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x180
; SWAP B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x188
; SWAP C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x190
; SWAP D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x198
; SWAP E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x1a0
; SWAP H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x1a8
; SWAP L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x1b0
; SWAP (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 0

org cb_base + 0x1b8
; SWAP A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 0

org cb_base + 0x1c0
; SRL B 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1c8
; SRL C 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1d0
; SRL D 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1d8
; SRL E 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1e0
; SRL H 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1e8
; SRL L 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x1f0
; SRL (HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 0 C

org cb_base + 0x1f8
; SRL A 
;  2 bytes 
;  8 cycles 
;  Z 0 0 C

org cb_base + 0x200
; BIT 0,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x208
; BIT 0,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x210
; BIT 0,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x218
; BIT 0,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x220
; BIT 0,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x228
; BIT 0,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x230
; BIT 0,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x238
; BIT 0,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x240
; BIT 1,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x248
; BIT 1,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x250
; BIT 1,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x258
; BIT 1,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x260
; BIT 1,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x268
; BIT 1,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x270
; BIT 1,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x278
; BIT 1,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x280
; BIT 2,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x288
; BIT 2,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x290
; BIT 2,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x298
; BIT 2,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2a0
; BIT 2,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2a8
; BIT 2,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2b0
; BIT 2,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x2b8
; BIT 2,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2c0
; BIT 3,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2c8
; BIT 3,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2d0
; BIT 3,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2d8
; BIT 3,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2e0
; BIT 3,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2e8
; BIT 3,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x2f0
; BIT 3,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x2f8
; BIT 3,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x300
; BIT 4,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x308
; BIT 4,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x310
; BIT 4,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x318
; BIT 4,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x320
; BIT 4,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x328
; BIT 4,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x330
; BIT 4,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x338
; BIT 4,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x340
; BIT 5,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x348
; BIT 5,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x350
; BIT 5,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x358
; BIT 5,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x360
; BIT 5,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x368
; BIT 5,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x370
; BIT 5,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x378
; BIT 5,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x380
; BIT 6,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x388
; BIT 6,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x390
; BIT 6,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x398
; BIT 6,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3a0
; BIT 6,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3a8
; BIT 6,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3b0
; BIT 6,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x3b8
; BIT 6,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3c0
; BIT 7,B 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3c8
; BIT 7,C 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3d0
; BIT 7,D 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3d8
; BIT 7,E 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3e0
; BIT 7,H 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3e8
; BIT 7,L 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x3f0
; BIT 7,(HL) 
;  2 bytes 
;  16 cycles 
;  Z 0 1 -

org cb_base + 0x3f8
; BIT 7,A 
;  2 bytes 
;  8 cycles 
;  Z 0 1 -

org cb_base + 0x400
; RES 0,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0xfe
mov erb, a
ljmp done

org cb_base + 0x408
; RES 0,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0xfe
mov erc, a
ljmp done

org cb_base + 0x410
; RES 0,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0xfe
mov erd, a
ljmp done

org cb_base + 0x418
; RES 0,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0xfe
mov ere, a
ljmp done

org cb_base + 0x420
; RES 0,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0xfe
mov erh, a
ljmp done

org cb_base + 0x428
; RES 0,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0xfe
mov erl, a
ljmp done

org cb_base + 0x430
; RES 0,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x438
; RES 0,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0xfe
mov era, a
ljmp done

org cb_base + 0x440
; RES 1,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0xfd
mov erb, a
ljmp done

org cb_base + 0x448
; RES 1,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0xfd
mov erc, a
ljmp done

org cb_base + 0x450
; RES 1,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0xfd
mov erd, a
ljmp done

org cb_base + 0x458
; RES 1,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0xfd
mov ere, a
ljmp done

org cb_base + 0x460
; RES 1,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0xfd
mov erh, a
ljmp done

org cb_base + 0x468
; RES 1,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0xfd
mov erl, a
ljmp done

org cb_base + 0x470
; RES 1,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x478
; RES 1,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0xfd
mov era, a
ljmp done

org cb_base + 0x480
; RES 2,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0xfb
mov erb, a
ljmp done

org cb_base + 0x488
; RES 2,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0xfb
mov erc, a
ljmp done

org cb_base + 0x490
; RES 2,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0xfb
mov erd, a
ljmp done

org cb_base + 0x498
; RES 2,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0xfb
mov ere, a
ljmp done

org cb_base + 0x4a0
; RES 2,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0xfb
mov erh, a
ljmp done

org cb_base + 0x4a8
; RES 2,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0xfb
mov erl, a
ljmp done

org cb_base + 0x4b0
; RES 2,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x4b8
; RES 2,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0xfb
mov era, a
ljmp done

org cb_base + 0x4c0
; RES 3,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0xf7
mov erb, a
ljmp done

org cb_base + 0x4c8
; RES 3,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0xf7
mov erc, a
ljmp done

org cb_base + 0x4d0
; RES 3,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0xf7
mov erd, a
ljmp done

org cb_base + 0x4d8
; RES 3,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0xf7
mov ere, a
ljmp done

org cb_base + 0x4e0
; RES 3,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0xf7
mov erh, a
ljmp done

org cb_base + 0x4e8
; RES 3,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0xf7
mov erl, a
ljmp done

org cb_base + 0x4f0
; RES 3,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x4f8
; RES 3,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0xf7
mov era, a
ljmp done

org cb_base + 0x500
; RES 4,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0xef
mov erb, a
ljmp done

org cb_base + 0x508
; RES 4,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0xef
mov erc, a
ljmp done

org cb_base + 0x510
; RES 4,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0xef
mov erd, a
ljmp done

org cb_base + 0x518
; RES 4,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0xef
mov ere, a
ljmp done

org cb_base + 0x520
; RES 4,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0xef
mov erh, a
ljmp done

org cb_base + 0x528
; RES 4,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0xef
mov erl, a
ljmp done

org cb_base + 0x530
; RES 4,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x538
; RES 4,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0xef
mov era, a
ljmp done

org cb_base + 0x540
; RES 5,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0xdf
mov erb, a
ljmp done

org cb_base + 0x548
; RES 5,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0xdf
mov erc, a
ljmp done

org cb_base + 0x550
; RES 5,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0xdf
mov erd, a
ljmp done

org cb_base + 0x558
; RES 5,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0xdf
mov ere, a
ljmp done

org cb_base + 0x560
; RES 5,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0xdf
mov erh, a
ljmp done

org cb_base + 0x568
; RES 5,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0xdf
mov erl, a
ljmp done

org cb_base + 0x570
; RES 5,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x578
; RES 5,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0xdf
mov era, a
ljmp done

org cb_base + 0x580
; RES 6,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0xbf
mov erb, a
ljmp done

org cb_base + 0x588
; RES 6,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0xbf
mov erc, a
ljmp done

org cb_base + 0x590
; RES 6,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0xbf
mov erd, a
ljmp done

org cb_base + 0x598
; RES 6,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0xbf
mov ere, a
ljmp done

org cb_base + 0x5a0
; RES 6,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0xbf
mov erh, a
ljmp done

org cb_base + 0x5a8
; RES 6,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0xbf
mov erl, a
ljmp done

org cb_base + 0x5b0
; RES 6,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x5b8
; RES 6,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0xbf
mov era, a
ljmp done

org cb_base + 0x5c0
; RES 7,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
anl a, #0x7f
mov erb, a
ljmp done

org cb_base + 0x5c8
; RES 7,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
anl a, #0x7f
mov erc, a
ljmp done

org cb_base + 0x5d0
; RES 7,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
anl a, #0x7f
mov erd, a
ljmp done

org cb_base + 0x5d8
; RES 7,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
anl a, #0x7f
mov ere, a
ljmp done

org cb_base + 0x5e0
; RES 7,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
anl a, #0x7f
mov erh, a
ljmp done

org cb_base + 0x5e8
; RES 7,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
anl a, #0x7f
mov erl, a
ljmp done

org cb_base + 0x5f0
; RES 7,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x5f8
; RES 7,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
anl a, #0x7f
mov era, a
ljmp done

org cb_base + 0x600
; SET 0,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x01
mov erb, a
ljmp done

org cb_base + 0x608
; SET 0,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x01
mov erc, a
ljmp done

org cb_base + 0x610
; SET 0,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x01
mov erd, a
ljmp done

org cb_base + 0x618
; SET 0,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x01
mov ere, a
ljmp done

org cb_base + 0x620
; SET 0,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x01
mov erh, a
ljmp done

org cb_base + 0x628
; SET 0,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x01
mov erl, a
ljmp done

org cb_base + 0x630
; SET 0,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x638
; SET 0,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x01
mov era, a
ljmp done

org cb_base + 0x640
; SET 1,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x02
mov erb, a
ljmp done

org cb_base + 0x648
; SET 1,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x02
mov erc, a
ljmp done

org cb_base + 0x650
; SET 1,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x02
mov erd, a
ljmp done

org cb_base + 0x658
; SET 1,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x02
mov ere, a
ljmp done

org cb_base + 0x660
; SET 1,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x02
mov erh, a
ljmp done

org cb_base + 0x668
; SET 1,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x02
mov erl, a
ljmp done

org cb_base + 0x670
; SET 1,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x678
; SET 1,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x02
mov era, a
ljmp done

org cb_base + 0x680
; SET 2,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x04
mov erb, a
ljmp done

org cb_base + 0x688
; SET 2,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x04
mov erc, a
ljmp done

org cb_base + 0x690
; SET 2,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x04
mov erd, a
ljmp done

org cb_base + 0x698
; SET 2,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x04
mov ere, a
ljmp done

org cb_base + 0x6a0
; SET 2,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x04
mov erh, a
ljmp done

org cb_base + 0x6a8
; SET 2,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x04
mov erl, a
ljmp done

org cb_base + 0x6b0
; SET 2,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x6b8
; SET 2,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x04
mov era, a
ljmp done

org cb_base + 0x6c0
; SET 3,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x08
mov erb, a
ljmp done

org cb_base + 0x6c8
; SET 3,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x08
mov erc, a
ljmp done

org cb_base + 0x6d0
; SET 3,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x08
mov erd, a
ljmp done

org cb_base + 0x6d8
; SET 3,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x08
mov ere, a
ljmp done

org cb_base + 0x6e0
; SET 3,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x08
mov erh, a
ljmp done

org cb_base + 0x6e8
; SET 3,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x08
mov erl, a
ljmp done

org cb_base + 0x6f0
; SET 3,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x6f8
; SET 3,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x08
mov era, a
ljmp done

org cb_base + 0x700
; SET 4,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x10
mov erb, a
ljmp done

org cb_base + 0x708
; SET 4,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x10
mov erc, a
ljmp done

org cb_base + 0x710
; SET 4,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x10
mov erd, a
ljmp done

org cb_base + 0x718
; SET 4,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x10
mov ere, a
ljmp done

org cb_base + 0x720
; SET 4,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x10
mov erh, a
ljmp done

org cb_base + 0x728
; SET 4,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x10
mov erl, a
ljmp done

org cb_base + 0x730
; SET 4,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x738
; SET 4,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x10
mov era, a
ljmp done

org cb_base + 0x740
; SET 5,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x20
mov erb, a
ljmp done

org cb_base + 0x748
; SET 5,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x20
mov erc, a
ljmp done

org cb_base + 0x750
; SET 5,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x20
mov erd, a
ljmp done

org cb_base + 0x758
; SET 5,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x20
mov ere, a
ljmp done

org cb_base + 0x760
; SET 5,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x20
mov erh, a
ljmp done

org cb_base + 0x768
; SET 5,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x20
mov erl, a
ljmp done

org cb_base + 0x770
; SET 5,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x778
; SET 5,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x20
mov era, a
ljmp done

org cb_base + 0x780
; SET 6,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x40
mov erb, a
ljmp done

org cb_base + 0x788
; SET 6,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x40
mov erc, a
ljmp done

org cb_base + 0x790
; SET 6,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x40
mov erd, a
ljmp done

org cb_base + 0x798
; SET 6,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x40
mov ere, a
ljmp done

org cb_base + 0x7a0
; SET 6,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x40
mov erh, a
ljmp done

org cb_base + 0x7a8
; SET 6,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x40
mov erl, a
ljmp done

org cb_base + 0x7b0
; SET 6,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x7b8
; SET 6,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x40
mov era, a
ljmp done

org cb_base + 0x7c0
; SET 7,B 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erb
orl a, #0x80
mov erb, a
ljmp done

org cb_base + 0x7c8
; SET 7,C 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erc
orl a, #0x80
mov erc, a
ljmp done

org cb_base + 0x7d0
; SET 7,D 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erd
orl a, #0x80
mov erd, a
ljmp done

org cb_base + 0x7d8
; SET 7,E 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, ere
orl a, #0x80
mov ere, a
ljmp done

org cb_base + 0x7e0
; SET 7,H 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erh
orl a, #0x80
mov erh, a
ljmp done

org cb_base + 0x7e8
; SET 7,L 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, erl
orl a, #0x80
mov erl, a
ljmp done

org cb_base + 0x7f0
; SET 7,(HL) 
;  2 bytes 
;  16 cycles 
;  - - - -

org cb_base + 0x7f8
; SET 7,A 
;  2 bytes 
;  8 cycles 
;  - - - -
mov a, era
orl a, #0x80
mov era, a
ljmp done



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.end