#!/usr/bin/env python2.7
# Read an input asm file and expand (fill in) some opcode handlers.

import re, sys, inspect

# A little metaprogramming magic...
expansions = {}

def match(pattern):
    def register(f):
        expansions[re.compile(pattern)] = f
        return f
    return register
    
# ASM generation helpers
def load(r):
    if (r == '(hl)'):
        print "mov dpl, erl"
        print "mov dph, erh"
        print "movx a, @dptr"
    else:
        print "mov a, er" + r

def save(r):
    if (r == '(hl)'):
        print "movx @dptr, a"
    else:
        print "mov er" + r + ", a"
    

# Now we can decorate each expansion function with the regex to match,
# and they'll even get the match groups passed in as separate args.

@match(r'INC (\w)(\w)')
def inc16(r1, r2):
    r1 = r1.lower()
    r2 = r2.lower()
    
    print "mov a, #0x01"
    print "mov ercf, c"
    print "add a, er" + r2
    print "mov er" + r2 + ", a"
    print "mov a, #0x00"
    print "addc a, er" + r1
    print "mov er" + r1 + ", a"
    print "mov c, ercf"
    print "ljmp done"

@match(r'DEC (\w)(\w)')
def dec16(r1, r2):
    r1 = r1.lower()
    r2 = r2.lower()
    
    print "mov a, er" + r2
    print "clr c"
    print "subb a, #0x01"
    print "mov er" + r2 + ", a"
    print "mov a, er" + r1
    print "subb a, #0x01"
    print "mov er" + r1 + ", a"
    print "ljmp done"


@match(r'LD (\w),(\w)\s')
def ld(r1, r2):
    r1 = r1.lower()
    r2 = r2.lower()
    
    print "mov a, er" + r2
    print "mov er" + r1 + ", a"
    print "ljmp done"
    
@match(r'LD (\w),\(HL\)')
def ldrhl(r):
    r = r.lower()
    
    print "mov dpl, erl"
    print "mov dph, erh"
    print "movx a, @dptr"
    print "mov er" + r + ", a"
    print "ljmp done"

@match(r'LD \(HL\),(\w)')
def ldhlr(r):
    r = r.lower()
    
    print "mov a, er" + r
    print "mov dpl, erl"
    print "mov dph, erh"
    print "movx @dptr, a"
    print "ljmp done"


@match(r'LD (\w),d8')
def ld8(r):
    r = r.lower()
    
    print "inc dptr"
    print "movx a, @dptr"
    print "mov er" + r + ", a"
    print "ljmp done"

# Bit opcodes

@match(r'BIT (\d),(\w)')
def bit(bit, r):
    bit = int(bit)
    r = r.lower()
    
    print "mov a, er" + r
    print "anl a, #" + hex(2**bit)
    print "mov erzf, a"
    print "ljmp done"

@match(r'BIT (\d),\(HL\)')
def bithl(bit):
    bit = int(bit)
    
    print "mov dpl, erl"
    print "mov dph, erh"
    print "movx a, @dptr"
    print "anl a, #" + hex(2**bit)
    print "mov erzf, a"
    print "ljmp done"

@match(r'SET (\d),(\w)')
def set(bit, r):
    bit = int(bit)
    r = r.lower()
    
    print "mov a, er" + r
    print "orl a, #" + hex(2**bit)
    print "mov er" + r + ", a"
    print "ljmp done"

@match(r'SET (\d),\(HL\)')
def sethl(bit):
    bit = int(bit)
    
    print "mov erh, dph"
    print "mov erl, dpl"
    print "movx a, @dptr"
    print "anl a, #" + hex(2**bit)
    print "movx @dptr, a"
    print "ljmp done"
    
@match(r'RES (\d),(\w)')
def reset(bit, r):
    bit = int(bit)
    r = r.lower()
    
    print "mov a, er" + r
    print "orl a, #" + hex(0xff - 2**bit)
    print "mov er" + r + ", a"
    print "ljmp done"

@match(r'RES (\d),\(HL\)')
def reshl(bit):
    bit = int(bit)
    
    print "mov erh, dph"
    print "mov erl, dpl"
    print "movx a, @dptr"
    print "orl a, #" + hex(0xff - 2**bit)
    print "movx @dptr, a"
    print "ljmp done"
    
@match(r'RLC ([\w\(\)]*)')
def rlc(r):
    r = r.lower()
    
    load(r)
    print "mov b, a"
    print "add a, #0x80"    # Get the carry bit set properly
    print "mov a, b"
    print "rl a"
    print "mov erzf, a"
    save(r)
    print "ljmp done"
    

@match(r'RRC ([\w\(\)]*)')
def rrc(r):
    r = r.lower()
    
    load(r)
    print "rr a"
    save(r)
    print "mov erzf, a"
    print "add a, #0x80"
    print "ljmp done"
    

@match(r'RL ([\w\(\)]*)')
def rl(r):
    r = r.lower()
    
    load(r)
    print "rlc a"
    save(r)
    print "mov erzf, a"
    print "ljmp done"

@match(r'RR ([\w\(\)]*)')
def rr(r):
    r = r.lower()
    
    load(r)
    print "rrc a"
    save(r)
    print "mov erzf, a"
    print "ljmp done"

@match(r'SLA ([\w\(\)]*)')
def sla(r):
    r = r.lower()
    
    load(r)
    print "clr c"
    print "rlc a"
    print "mov erzf, a"
    save(r)
    print "ljmp done"


@match(r'SRA ([\w\(\)]*)')
def sra(r):
    r = r.lower()
    
    load(r)
    print "mov b, a"
    print "add a, #0x80"
    print "mov a, b"
    print "rrc a"
    print "mov erzf, a"
    save(r)
    print "ljmp done"

@match(r'SRL ([\w\(\)]*)')
def srl(r):
    r = r.lower()
    
    load(r)
    print "clr c"
    print "rrc a"
    print "mov erzf, a"
    save(r)
    print "ljmp done"

@match(r'SWAP ([\w\(\)]*)')
def swap(r):
    r = r.lower()
    
    load(r)
    print "swap a"
    print "mov erzf, a"
    print "clr c"
    save(r)
    print "ljmp done"
    
    

# Go through the input, matching each line against our expander regexen.
# Each line should only match one expansion -- behavior otherwise is undefined.

def expand(lines):
    i = 0

    while i < len(lines):
        print lines[i],

        for pattern, func in expansions.iteritems():
            match = re.search(pattern, lines[i])
        
            if match is None:
                continue
            
            argc = len(inspect.getargspec(func)[0])
            args = [match.group(j) for j in range(1, argc+1)]
    
            i += 1      # Skip through comments
            while (lines[i][0] == ';'):
                print lines[i],
                i += 1
                
            if (lines[i] != "\n"):
                raise ValueError, "Attempting to expand into non-blank line (" + \
                    str(i) + "): " + lines[i]
        
            func(*args) # Expand
            
            break
        
        else:   # No match for this line
            i += 1
        
if __name__ == '__main__':
    f = open(sys.argv[1])
    lines = f.readlines()
    expand(lines)
    