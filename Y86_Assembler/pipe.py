#!/usr/bin/env python
#
#    Python Pipelined Y86 Simulator
#    Copyright (c) 2012 Linus Yang <laokongzi@gmail.com>
#
#    ** Compatible with Shedskin **
#    Shedskin is an RPython to C++ compiler
#    Visit https://code.google.com/p/shedskin/wiki/docs for more info
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import getopt
import binascii
import os
import sys

__ver__ = '0.1.3'

# Signals
INOP = 0x0
IHALT = 0x1
IRRMOVL = 0x2
IIRMOVL = 0x3
IRMMOVL = 0x4
IMRMOVL= 0x5
IOPL = 0x6
IJXX = 0x7
ICALL = 0x8
IRET = 0x9
IPUSHL = 0xa
IPOPL = 0xb
IIADDL = 0xc
ILEAVE = 0xd
FNONE = 0x0
RESP = 0x4
REBP = 0x5
RNONE = 0x8
ALUADD = 0x0
ALUSUB = 0x1
ALUAND = 0x2
ALUXOR = 0x3
FJMP = 0x0
FJLE = 0x1
FJL = 0x2
FJE = 0x3
FJNE = 0x4
FJGE = 0x5
FJG = 0x6

# Pipeline Register F
F_predPC = 0
F_stat = 'BUB'

# Intermediate Values in Fetch Stage
f_icode = INOP
f_ifun = FNONE
f_valC = 0x0
f_valP = 0x0
f_rA = RNONE
f_rB = RNONE
f_predPC = 0
f_stat = 'BUB'

# Pipeline Register D
D_stat = 'BUB'
D_icode = INOP
D_ifun = FNONE
D_rA = RNONE
D_rB = RNONE
D_valP = 0x0
D_valC = 0x0
D_next_bub = False

# Intermediate Values in Decode Stage
d_srcA = RNONE
d_srcB = RNONE
d_dstE = RNONE
d_dstM = RNONE
d_valA = 0x0
d_valB = 0x0

# Pipeline Register E
E_stat = 'BUB'
E_icode = INOP
E_ifun = FNONE
E_valC = 0x0
E_srcA = RNONE
E_valA = 0x0
E_srcB = RNONE
E_valB = 0x0
E_dstE = RNONE
E_dstM = RNONE

# Intermediate Values in Execute Stage
e_valE = 0x0
e_dstE = RNONE
e_Cnd = False
e_setcc = False

# Pipeline Register M
M_stat = 'BUB'
M_icode = INOP
M_ifun = FNONE
M_valA = 0x0
M_dstE = RNONE
M_valE = 0x0
M_dstM = RNONE
M_Cnd = False

# Intermediate Values in Memory Stage
m_valM = 0x0
m_stat = 'BUB'
mem_addr = 0x0
m_read = False
dmem_error = False

# Pipeline Register W
W_stat = 'BUB'
W_icode = INOP
W_ifun = FNONE
W_dstE = RNONE
W_valE = 0x0
W_dstM = RNONE
W_valM = 0x0

# Registers
register = {
    0x0: 0,
    0x1: 0,
    0x2: 0,
    0x3: 0,
    0x4: 0,
    0x5: 0,
    0x6: 0,
    0x7: 0,
    0x8: 0,
    0xf: 0
}

# CC code
condcode = {
    'ZF': 1,
    'SF': 0,
    'OF': 0
}

# Memory
memory = {}
memro = []

# Registers encode
regname = {
    0x0: "%eax",
    0x1: "%ecx",
    0x2: "%edx",
    0x3: "%ebx",
    0x4: "%esp",
    0x5: "%ebp",
    0x6: "%esi",
    0x7: "%edi"
}

instrname = {
    "00": "nop",
    "10": "halt",
    "20": "rrmovl",
    "21": "cmovle",
    "22": "cmovl",
    "23": "cmove",
    "24": "cmovne",
    "25": "cmovge",
    "26": "cmovg",
    "30": "irmovl",
    "40": "rmmovl",
    "50": "mrmovl",
    "60": "addl",
    "61": "subl",
    "62": "andl",
    "63": "xorl",
    "70": "jmp",
    "71": "jle",
    "72": "jl",
    "73": "je",
    "74": "jne",
    "75": "jge",
    "76": "jg",
    "80": "call",
    "90": "ret",
    "a0": "pushl",
    "b0": "popl",
    "c0": "iaddl",
    "d0": "leave"
}

# Global variables
isBigEndian = False
isSecond = False
isGuimode = False
isNoLogFile = False
cycle = 0
cpustat = 'AOK'
yasbin = ''
binlen = 0
addrlen = 3
logfile = None
    
def simLog(s, onscreen = False):
    if isGuimode:
        return
    if logfile != None:
        logfile.write("%s\n" % (s))
    if onscreen or logfile == None:
        print s

def writeGuiLog(s):
    if not isGuimode:
        return
    if logfile != None:
        logfile.write("%s\n" % (s))
    else:
        print s
    
def myHex(x, m = 0):
    if x < 0:
        x = (~(-x) + 1) & 0xffffffff
    if m == 0:
        return "%x" % (x)
    else:
        return "%.*x" % (m, x)

def getInstrName(icode, ifun):
    s = myHex(icode) + myHex(ifun)
    if s in instrname:
        return instrname[s]
    return 'INS'

def getRegName(x):
    if x == RNONE:
        return '----'
    else:
        return regname[x]
    
def getCCStr():
    return 'Z=%d S=%d O=%d' % \
            (condcode['ZF'], condcode['SF'], condcode['OF'])
    
def endianInt(s):
    x = 0
    if isBigEndian:
        x = int(s, 16)
    else:
        x = int('%c%c%c%c%c%c%c%c' % (s[6], s[7], s[4], s[5], \
                                         s[2], s[3], s[0], s[1]), 16)
    if x > 0x7fffffff:
        x = -((~x + 1) & 0xffffffff)
    return x

def writeF():
    global F_predPC
    global F_stat
    if IRET in (D_icode, E_icode, M_icode) or \
        (E_icode in (IMRMOVL, IPOPL) and \
        E_dstM in (d_srcA, d_srcB)):
        return
    F_predPC = f_predPC
    F_stat = 'AOK'

def stageF():
    global f_icode
    global f_ifun
    global f_valC
    global f_valP
    global f_rA
    global f_rB
    global f_predPC
    global f_stat
    f_pc = F_predPC
    if M_icode == IJXX and not M_Cnd:
        f_pc = M_valA
    elif W_icode == IRET:
        f_pc = W_valM
    old_pc = f_pc
    pcstart = f_pc * 2
    imem_error = False
    if f_pc == binlen:
        f_icode = IHALT
        f_ifun = FNONE
        f_rA = RNONE
        f_rB = RNONE
        f_valC = 0x0
        f_valP = 0x0
        f_stat = 'HLT'
        return
    elif f_pc > binlen or f_pc < 0:
        imem_error = True
    else:
        imem_icode = int(yasbin[pcstart], 16)
        imem_ifun = int(yasbin[pcstart + 1], 16)
        if isSecond:
            if imem_icode == 0x1:
                imem_icode = INOP
            elif imem_icode == 0x0:
                imem_icode = IHALT
        pcstart += 2
        f_pc += 1
    f_icode = INOP if imem_error else imem_icode    
    f_ifun = FNONE if imem_error else imem_ifun
    instr_valid =  f_icode in (INOP, IHALT, IRRMOVL, IIRMOVL, IRMMOVL, IMRMOVL, \
                               IOPL, IJXX, ICALL, IRET, IPUSHL, IPOPL, IIADDL, ILEAVE)
    if instr_valid:
        try:
            if f_icode in (IRRMOVL, IOPL, IPUSHL, IPOPL, \
                           IIRMOVL, IRMMOVL, IMRMOVL, IIADDL):
                f_rA = int(yasbin[pcstart], 16)
                f_rB = int(yasbin[pcstart + 1], 16)
                if isSecond:
                    if f_rA == 0xf:
                        f_rA = RNONE
                    if f_rB == 0xf:
                        f_rB = RNONE
                pcstart += 2
                f_pc += 1
            else:
                f_rA = RNONE
                f_rB = RNONE
            if (f_rA not in regname.keys() and f_rA != RNONE) or \
                (f_rB not in regname.keys() and f_rB != RNONE):
                imem_error = True
        except:
            imem_error = True
        f_valC = 0x0
        try:
            if f_icode in (IIRMOVL, IRMMOVL, IMRMOVL, IJXX, ICALL, IIADDL):
                f_valC = endianInt(yasbin[pcstart:pcstart + 8])
                pcstart += 8
                f_pc += 4
        except:
            imem_error = True
        if not imem_error:
            simLog('\tFetch: f_pc = 0x%x, imem_instr = %s, f_instr = %s' % \
                   (old_pc, getInstrName(imem_icode, imem_ifun), getInstrName(f_icode, f_ifun)))
    if not instr_valid:
        simLog('\tFetch: Instruction code 0x%x%x invalid' % (imem_icode, imem_ifun))
    f_valP = f_pc
    f_predPC = f_valC if f_icode in (IJXX, ICALL) else f_valP
    f_stat = 'AOK'
    if imem_error:
        f_stat = 'ADR'
    if not instr_valid:
        f_stat = 'INS'
    if f_icode == IHALT:
        f_stat = 'HLT'
    
def writeD():
    global D_stat
    global D_icode
    global D_ifun
    global D_rA
    global D_rB
    global D_valP
    global D_valC
    global D_next_bub
    if E_icode in (IMRMOVL, IPOPL) and E_dstM in (d_srcA, d_srcB):
        return
    if IRET in (E_icode, M_icode, W_icode) or D_next_bub:
        D_icode = INOP
        D_ifun = FNONE
        D_rA = RNONE
        D_rB = RNONE
        D_valC = 0x0
        D_valP = 0x0
        D_stat = 'BUB'
        if D_next_bub:
            D_next_bub = False
        return
    if E_icode == IJXX and not e_Cnd:
        D_next_bub = True
    D_stat = f_stat
    D_icode = f_icode
    D_ifun = f_ifun
    D_rA = f_rA
    D_rB = f_rB
    D_valC = f_valC
    D_valP = f_valP
    
def stageD():
    global d_srcA
    global d_srcB
    global d_dstE
    global d_dstM
    global d_valA
    global d_valB
    d_srcA = RNONE
    if D_icode in (IRRMOVL, IRMMOVL, IOPL, IPUSHL):
        d_srcA = D_rA
    elif D_icode in (IPOPL, IRET):
        d_srcA = RESP
    elif D_icode == ILEAVE:
        d_srcA = REBP
    d_srcB = RNONE
    if D_icode in (IOPL, IRMMOVL, IMRMOVL, IIADDL):
        d_srcB = D_rB
    elif D_icode in (IPUSHL, IPOPL, ICALL, IRET):
        d_srcB = RESP
    d_dstE = RNONE
    if D_icode in (IRRMOVL, IIRMOVL, IOPL, IIADDL):
        d_dstE = D_rB
    elif D_icode in (IPUSHL, IPOPL, ICALL, IRET, ILEAVE):
        d_dstE = RESP
    d_dstM = RNONE
    if D_icode in (IMRMOVL, IPOPL):
        d_dstM = D_rA
    elif D_icode == ILEAVE:
        d_dstM = REBP
    d_valA = register[d_srcA]
    if D_icode in (ICALL, IJXX):
        d_valA = D_valP
    elif d_srcA == e_dstE:
        d_valA = e_valE
    elif d_srcA == M_dstM:
        d_valA = m_valM
    elif d_srcA == M_dstE:
        d_valA = M_valE
    elif d_srcA == W_dstM:
        d_valA = W_valM
    elif d_srcA == W_dstE:
        d_valA = W_valE
    d_valB = register[d_srcB]
    if d_srcB == e_dstE:
        d_valB = e_valE
    elif d_srcB == M_dstM:
        d_valB = m_valM
    elif d_srcB == M_dstE:
        d_valB = M_valE
    elif d_srcB == W_dstM:
        d_valB = W_valM
    elif d_srcB == W_dstE:
        d_valB = W_valE
    
def writeE():
    global E_stat
    global E_icode
    global E_ifun
    global E_valC
    global E_srcA
    global E_valA
    global E_srcB
    global E_valB
    global E_dstE
    global E_dstM
    if (E_icode == IJXX and not e_Cnd) or \
        E_icode in (IMRMOVL, IPOPL) and \
        E_dstM in (d_srcA, d_srcB):
        E_icode = INOP
        E_ifun = FNONE
        E_valC = 0x0
        E_valA = 0x0
        E_valB = 0x0
        E_dstE = RNONE
        E_dstM = RNONE
        E_srcA = RNONE
        E_srcB = RNONE
        E_stat = 'BUB'
        return
    E_stat = D_stat
    E_icode = D_icode
    E_ifun = D_ifun
    E_valC = D_valC
    E_valA = d_valA
    E_valB = d_valB
    E_dstE = d_dstE
    E_dstM = d_dstM
    E_srcA = d_srcA
    E_srcB = d_srcB

def stageE():
    global condcode
    global e_Cnd
    global e_valE
    global e_dstE
    global e_setcc
    aluA = 0
    if E_icode in (IRRMOVL, IOPL, ILEAVE):
        aluA = E_valA
    elif E_icode in (IIRMOVL, IRMMOVL, IMRMOVL, IIADDL):
        aluA = E_valC
    elif E_icode in (ICALL, IPUSHL):
        aluA = -4
    elif E_icode in (IRET, IPOPL):
        aluA = 4
    aluB = 0
    if E_icode in (IRMMOVL, IMRMOVL, IOPL, ICALL, \
                   IPUSHL, IRET, IPOPL, IIADDL):
        aluB = E_valB
    elif E_icode == ILEAVE:
        aluB = 4
    alufun = E_ifun if E_icode == IOPL else ALUADD
    alures = 0
    aluchar = '+'
    if alufun == ALUADD:
        alures = aluB + aluA
        aluchar = '+'
    elif alufun == ALUSUB:
        alures = aluB - aluA
        aluchar = '-'
    elif alufun == ALUAND:
        alures = aluB & aluA
        aluchar = '&'
    elif alufun == ALUXOR:
        alures = aluB ^ aluA
        aluchar = '^'
    simLog('\tExecute: ALU: 0x%s %c 0x%s = 0x%s' % \
           (myHex(aluB), aluchar, myHex(aluA), myHex(alures)))
    e_setcc =  E_icode in (IOPL, IIADDL) and \
               m_stat not in ('ADR', 'INS', 'HLT') and \
               W_stat not in ('ADR', 'INS', 'HLT')
    if e_setcc:    
        condcode['ZF'] = 1 if alures == 0 else 0
        condcode['SF'] = 1 if alures < 0 else 0
        condcode['OF'] = 0
        if (E_ifun == ALUADD) and \
            ((aluB > 0 and aluA > 0 and alures < 0) or \
              aluB < 0 and aluB < 0 and alures > 0):
            condcode['OF'] = 1
        if (E_ifun == ALUSUB) and \
            ((aluB > 0 and aluA < 0 and alures < 0) or \
              aluB < 0 and aluB > 0 and alures > 0):
            condcode['OF'] = 1
        simLog('\tExecute: New cc = %s' % (getCCStr()))
    e_Cnd = False
    if E_icode == IJXX or E_icode == IRRMOVL:
        zf = condcode['ZF']
        sf = condcode['SF']
        of = condcode['OF']
        if E_ifun == FJMP:
            e_Cnd = True
        elif E_ifun == FJLE and (sf ^ of) | zf == 1:
            e_Cnd = True
        elif E_ifun == FJL and sf ^ of == 1:
            e_Cnd = True
        elif E_ifun == FJE and zf == 1:
            e_Cnd = True
        elif E_ifun == FJNE and zf == 0:
            e_Cnd = True
        elif E_ifun == FJGE and sf ^ of == 0:
            e_Cnd = True
        elif E_ifun == FJG and (sf ^ of) | zf == 0:
            e_Cnd = True
        simLog('\tExecute: instr = %s, cc = %s, branch %staken' % \
               (getInstrName(E_icode, E_ifun), 'Z=%d S=%d O=%d' % (zf, sf, of), \
                '' if e_Cnd else 'not '))
    e_valE = alures
    e_dstE = E_dstE
    if E_icode == IRRMOVL and not e_Cnd:
        e_dstE = RNONE
        
def writeM():
    global M_stat
    global M_icode
    global M_ifun
    global M_Cnd
    global M_valE
    global M_valA
    global M_dstE
    global M_dstM
    if m_stat in ('ADR', 'INS', 'HLT') or \
        W_stat in ('ADR', 'INS', 'HLT'):
        M_stat = 'BUB'
        M_icode = INOP
        M_ifun = FNONE
        M_Cnd = False
        M_valE = 0x0
        M_valA = 0x0
        M_dstE = RNONE
        M_dstM = RNONE
        return
    M_stat = E_stat
    M_icode = E_icode
    M_ifun = E_ifun
    M_Cnd = e_Cnd
    M_valE = e_valE
    M_valA = E_valA
    M_dstE = e_dstE
    M_dstM = E_dstM
    
def stageM():
    global memory
    global dmem_error
    global m_stat
    global m_valM
    global m_read
    global mem_addr
    global memro
    m_valM = 0
    mem_addr = 0
    dmem_error = False
    if M_icode in (IRMMOVL, IPUSHL, ICALL, IMRMOVL):
        mem_addr = M_valE
    elif M_icode in (IPOPL, IRET, ILEAVE):
        mem_addr = M_valA
    if M_icode in (IMRMOVL, IPOPL, IRET, ILEAVE):
        try:
            if mem_addr not in memory:
                memory[mem_addr] = endianInt(yasbin[mem_addr * 2:mem_addr * 2 + 8])
                memro.append(mem_addr)
            m_valM = memory[mem_addr]
            m_read = True
            simLog('\tMemory: Read 0x%s from 0x%x' % (myHex(m_valM), mem_addr))
        except:
            dmem_error = True
            simLog('\tMemory: Invalid address 0x%s' % (myHex(mem_addr)))
    if M_icode in (IRMMOVL, IPUSHL, ICALL):
        try:
            if mem_addr in memro or mem_addr < 0:
                raise Exception
            memory[mem_addr] = M_valA
            simLog('\tWrote 0x%s to address 0x%x' % (myHex(M_valA), mem_addr))
        except:
            dmem_error = True
            simLog('\tCouldn\'t write to address 0x%s' % (myHex(mem_addr)))
    m_stat = 'ADR' if dmem_error else M_stat
    
def writeW():
    global W_stat
    global W_icode
    global W_ifun
    global W_dstE
    global W_valE
    global W_dstM
    global W_valM
    if W_stat in ('ADR', 'INS', 'HLT'):
        return
    W_stat = m_stat
    W_icode = M_icode
    W_ifun = M_ifun
    W_valE = M_valE
    W_valM = m_valM
    W_dstE = M_dstE
    W_dstM = M_dstM
    
def stageW():
    global register
    global cpustat
    global cycle
    if W_dstE != RNONE:
        register[W_dstE] = W_valE
        simLog('\tWriteback: Wrote 0x%s to register %s' % (myHex(W_valE), regname[W_dstE]))
    if W_dstM != RNONE:
        register[W_dstM] = W_valM
        simLog('\tWriteback: Wrote 0x%s to register %s' % (myHex(W_valM), regname[W_dstM]))
    cpustat = 'AOK' if W_stat == 'BUB' else W_stat

def showStatTitle():
    if isGuimode:
        writeGuiLog("%d" % cycle);
        return
    simLog('\nCycle %d. CC=%s, Stat=%s' % (cycle, getCCStr(), cpustat))
    
def showStat():
    if isGuimode:
        writeGuiLog('0x' + myHex(F_predPC))
        writeGuiLog('%s %s %s %s %s %s' % \
            (getInstrName(D_icode, D_ifun), getRegName(D_rA), getRegName(D_rB), \
            myHex(D_valC, 8), myHex(D_valP, 8), D_stat))
        writeGuiLog('%s %s %s %s %s %s %s %s %s' % \
            (getInstrName(E_icode, E_ifun), myHex(E_valC, 8), myHex(E_valA, 8), myHex(E_valB, 8), \
            getRegName(E_srcA), getRegName(E_srcB), getRegName(E_dstE), getRegName(E_dstM), \
            E_stat))
        writeGuiLog('%s %d %s %s %s %s %s' % \
            (getInstrName(M_icode, M_ifun), int(M_Cnd), myHex(M_valE, 8), myHex(M_valA, 8), \
            getRegName(M_dstE), getRegName(M_dstM), M_stat))
        writeGuiLog('%s %s %s %s %s %s' % \
            (getInstrName(W_icode, W_ifun), myHex(W_valE, 8), myHex(W_valM, 8), getRegName(W_dstE), \
            getRegName(W_dstM), W_stat))
        writeGuiLog(cpustat)
        writeGuiLog('%d %d %d' % (condcode['ZF'], condcode['SF'], condcode['OF']))
        for reg in sorted(register.keys()):
            if reg != 0x8 and reg != 0xf:
                writeGuiLog(myHex(register[reg], 8))
        writeGuiLog('MEMBEG')
        for memaddr in sorted(memory.keys()):
            if memaddr not in memro and memory[memaddr] != 0:
                writeGuiLog('0x%s: 0x%s' % (myHex(memaddr, addrlen), myHex(memory[memaddr], 8)))
        writeGuiLog('CYCEND')
        return
    simLog('F: predPC = 0x%x' % (F_predPC))
    simLog('D: instr = %s, rA = %s, rB = %s, valC = 0x%s, valP = 0x%s, Stat = %s' % \
           (getInstrName(D_icode, D_ifun), getRegName(D_rA), getRegName(D_rB), \
            myHex(D_valC), myHex(D_valP), D_stat))
    simLog('E: instr = %s, valC = 0x%s, valA = 0x%s, valB = 0x%s' \
           '\n   srcA = %s, srcB = %s, dstE = %s, dstM = %s, Stat = %s' % \
           (getInstrName(E_icode, E_ifun), myHex(E_valC), myHex(E_valA), myHex(E_valB), \
            getRegName(E_srcA), getRegName(E_srcB), getRegName(E_dstE), getRegName(E_dstM), \
            E_stat))
    simLog('M: instr = %s, Cnd = %d, valE = 0x%s, valA = 0x%s' \
           '\n   dstE = %s, dstM = %s, Stat = %s' % \
           (getInstrName(M_icode, M_ifun), int(M_Cnd), myHex(M_valE), myHex(M_valA), \
            getRegName(M_dstE), getRegName(M_dstM), M_stat))
    simLog('W: instr = %s, valE = 0x%s, valM = 0x%s, dstE = %s, dstM = %s, Stat = %s' % \
           (getInstrName(W_icode, W_ifun), myHex(W_valE), myHex(W_valM), getRegName(W_dstE), \
            getRegName(W_dstM), W_stat))

def showUsage():
    print('''Usage: %s [options] [y86 binary object]

Options:
  -h, --help            show this help message and exit
  -b, --bigendian       detect binary as big-endian. (default is little-
                        endian)
  -s, --second          use decoding rules in csapp 2nd edition. (default
                        using 1st editon rules)
  -m MAXCYCLE, --maxcycle=MAXCYCLE
                        set limit of running cycles. 0 means no limit.
                        (default is 32767)
  -g, --guimode         set log output syntax for GUI. (default is disabled)
  -n, --nologfile       print log to stdout instead of writing to file.
                        (default is disabled)
''' % os.path.basename(sys.argv[0]))
    sys.exit(1)
    
def main():
    print('Pipelined Y86 Simulator %s\nCopyright (c) 2012 Linus Yang\n' % __ver__)
    global isBigEndian
    global isSecond
    global logfile
    global isGuimode
    global isNoLogFile
    isBigEndian = False
    isSecond = False
    isGuimode = False
    isNoLogFile = False
    maxcycle = 32767
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'bsm:gnh', \
                ['bigendian', 'second', 'maxcycle', 'guimode', 'nologfile', 'help'])
        if len(opts) == 0 and len(args) != 1:
            if len(args) == 0:
                print("Error: missing input file")
            else:
                print("Error: only one input file allowed")
            showUsage()
        for o, a in opts:
            if o in ("-b", "--bigendian"):
                isBigEndian = True
            if o in ("-s", "--second"):
                isSecond = True
                print('Warning: using csapp 2nd edition rules')
            if o in ("-m", "--maxcycle="):
                try:
                    maxcycle = int(a)
                except ValueError:
                    print('Error: invalied cycle number')
                    sys.exit(1)
            if o in ("-g", "--guimode"):
                isGuimode = True
            if o in ("-n", "--nologfile"):
                isNoLogFile = True
            if o in ('-h', '--help'):
                showUsage()
    except getopt.GetoptError:
        print("Error: illegal option")
        showUsage()
    inputName = args[0]
    try:
        fin = open(inputName, 'rb')
    except:
        print('Error: cannot open binary: %s' % inputName)
        sys.exit(1)
    if isNoLogFile:
        logfile = None
    else:
        prefixName = os.path.splitext(inputName)[0]
        outputName = prefixName + '.log'
        try:
            logfile = open(outputName, 'w')
        except IOError:
            print('Warning: cannot create log file')
    simLog('Pipelined Y86 Simulator %s\nCopyright (c) 2012 Linus Yang\n' % __ver__)
    simLog('Y86 Object: %s' % (inputName))
    if not isNoLogFile:
        print('Log file: %s' % (outputName))
    global yasbin
    global binlen
    global addrlen
    try:
        yasbin = binascii.b2a_hex(fin.read())
    except:
        print('Error: cannot identify binary: %s' % (inputName))
        sys.exit(1)
    try:
        fin.close()
    except IOError:
        pass
    binlen = len(yasbin) / 2
    simLog('%d bytes of code read' % (binlen))
    addrlen = len("%x" % (binlen))
    if addrlen < 3:
        addrlen = 3
        
    # Automatic pipeline run
    
    global cycle
    global cpustat
    try:
        while True:
            showStatTitle()
            writeW()
            stageW()
            writeM()
            stageM()
            writeE()
            stageE()
            writeD()
            stageD()
            writeF()
            stageF()
            if maxcycle != 0 and cycle > maxcycle:
                simLog('Reach Max Cycle', True)
                cpustat = 'HLT'
            if cpustat != 'AOK' and cpustat != 'BUB':
                showStat()
                break
            showStat()
            cycle += 1
    except:
        print('Error: bad input binary file')
        sys.exit(1)
    simLog('\n%d instructions executed\nStatus = %s' % \
           (cycle + 1, cpustat), True)
    simLog('Condition Codes: %s' % (getCCStr()), True)
    simLog('Changed Register State:', True)
    for reg in register:
        if reg != 0x8 and reg != 0xf and register[reg] != 0x0:
            simLog('%s:\t0x%s' % (regname[reg], myHex(register[reg], 8)), True)
    simLog('Changed Memory State:', True)
    for memaddr in sorted(memory.keys()):
        if memaddr not in memro and memory[memaddr] != 0:
            simLog('0x%s:\t0x%s' % (myHex(memaddr, addrlen), myHex(memory[memaddr], 8)), True)
    if logfile != None:
        try:        
            logfile.close()
        except IOError:
            pass
    print('Simulation finished')
     
if __name__ == '__main__':
    main()
