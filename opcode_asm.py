#!/usr/bin/env python2.7
import sys

f_in = open(sys.argv[1])

addr = 0

for line in f_in:
    if line == "\n":
        print 'org op_base + ' + hex(addr)
        print '; (unused)\n'
        addr += 16
        continue
    try:
        opcode, bytes, cycles, flags = line.split(':')
    except ValueError:
        print >> sys.stderr, 'Bad line: ' + line
        continue
    
    print 'org cb_base + ' + hex(addr)
    print '; ' + opcode
    print '; ' + bytes
    print '; ' + cycles
    print '; ' + flags
    
    addr += 16