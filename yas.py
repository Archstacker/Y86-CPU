#!/usr/bin/env python
#
#    Python Y86 Assembler
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
import re
import binascii
import os
import sys

__ver__ = '0.1.2'

class YAssembler:

    def __init__(self, lar=True, big=False, sec=False, asc=False):
        self.largemem = lar
        self.bigendian = big
        self.second = sec
        self.asciibin = asc
        self.regs = {
            "%eax": "0",
            "%ecx": "1",
            "%edx": "2",
            "%ebx": "3",
            "%esp": "4",
            "%ebp": "5",
            "%esi": "6",
            "%edi": "7",
            "rnone": "8"
        }
        self.instr = {
            "nop": "00",
            "halt": "10",
            "rrmovl": "20",
            "cmovle": "21",
            "cmovl": "22",
            "cmove": "23",
            "cmovne": "24",
            "cmovge": "25",
            "cmovg": "26",
            "irmovl": "30",
            "rmmovl": "40",
            "mrmovl": "50",
            "addl": "60",
            "subl": "61",
            "andl": "62",
            "xorl": "63",
            "jmp": "70",
            "jle": "71",
            "jl": "72",
            "je": "73",
            "jne": "74",
            "jge": "75",
            "jg": "76",
            "call": "80",
            "ret": "90",
            "pushl": "a0",
            "popl": "b0",
            "iaddl": "c0",
            "leave": "d0"
        }
        self.instbyte = {
            "nop": 1,
            "halt": 1,
            "rrmovl": 2,
            "cmovle": 2,
            "cmovl": 2,
            "cmove": 2,
            "cmovne": 2,
            "cmovge": 2,
            "cmovg": 2,
            "irmovl": 6,
            "rmmovl": 6,
            "mrmovl": 6,
            "addl": 2,
            "subl": 2,
            "andl": 2,
            "xorl": 2,
            "jmp": 5,
            "jle": 5,
            "jl": 5,
            "je": 5,
            "jne": 5,
            "jge": 5,
            "jg": 5,
            "call": 5,
            "ret": 1,
            "pushl": 2,
            "popl": 2,
            "iaddl": 6,
            "leave": 1
        }
        self.bytelen = {
            '.long': 4,
            '.word': 2,
            '.byte': 1
        }
        if self.second:
            self.regs['rnone'] = 'f'
            self.instr['nop'] = '10'
            self.instr['halt'] = '00'
            
    def endianStr(self, x, length, bigendian=False):
        s = ''
        nowlen = 0
        while x != 0 and nowlen < length:
            if bigendian:
                s = "%.2x" % (x & 0xff) + s
            else:
                s += "%.2x" % (x & 0xff)
            x = x >> 8
            nowlen += 1
        while nowlen < length:
            if bigendian:
                s = '00' + s
            else:
                s += '00'
            nowlen += 1    
        return s

    def printError(self, error):
        print('Error: assembly failed:\n%s' % error)
        sys.exit(1)

    def runAssembler(self, inputName):
        try:
            fin = open(inputName)
        except IOError:
            print('Error: cannot open input file: %s' % inputName)
            sys.exit(1)

        binpos = 0
        linepos = 0
        alignment = 0
        labels = {}
        error = ''
        strippedline = {}
        origline = []
        yaslineno = {}
        
        # First pass to get labels and detect errors
        
        for nowline in fin:
            linepos += 1
            origline.append(nowline)
            nowline = re.sub(r'#.*$', '', nowline)
            nowline = re.sub(r'/\*.*\*/', '', nowline)
            nowline = re.sub(r'\s*,\s*', ',', nowline)
            if nowline.find(':') != -1:
                lab = re.compile('([^\s]+):')
                labmatch = lab.search(nowline)
                nowline = lab.sub('', nowline)
                if labmatch != None:
                    labelname = labmatch.group(1)
                else:
                    error += 'Line %d: %s\n' % (linepos, 'Label error.')
                    continue
                if labelname in labels:
                    error += 'Line %d: %s\n' % (linepos, 'Label repeated error.')
                    continue
                else:
                    labels[labelname] = binpos
                    yaslineno[linepos] = binpos
            linelist = []
            for element in nowline.split(' '):
                ele = element.replace('\t', '').replace('\n', '').replace('\r', '')
                if ele != '':
                    linelist.append(ele)
            if linelist == []:
                continue
            posindex = str(linepos)
            strippedline[posindex] = linelist
            try:
                if linelist[0] in self.instbyte:
                    alignment = 0
                    yaslineno[linepos] = binpos
                    binpos += self.instbyte[linelist[0]]
                elif linelist[0] == '.pos':
                    binpos = int(linelist[1], 0)
                    yaslineno[linepos] = binpos
                elif linelist[0] == '.align':
                    alignment = int(linelist[1], 0)
                    if binpos % alignment != 0:
                        binpos += alignment - binpos % alignment
                    yaslineno[linepos] = binpos
                elif linelist[0] in ('.long', '.word', '.byte'):
                    yaslineno[linepos] = binpos
                    if alignment != 0:
                        binpos += alignment
                    else:
                        binpos += self.bytelen[linelist[0]]
                else:
                    error += 'Line %d: Instruction "%s" not defined.\n' % (linepos, linelist[0])
                    continue
            except:
                error += 'Line %d: Instruction error.\n' % linepos
                continue
        try:
            fin.close()
        except IOError:
            pass
        if error != '':
            self.printError(error)
        
        # Second pass to convert binary
        
        yasbin = {}
        for line in strippedline:
            try:
                linepos = int(line)
            except ValueError:
                print('Error: unexpected internal error')
                sys.exit(1)
            linelist = strippedline[line]
            if linelist == []:
                continue
            resbin = ''
            if linelist[0] in self.instr:
                alignment = 0
                try:
                    if linelist[0] in ('nop', 'halt', 'ret', 'leave'):
                        resbin = self.instr[linelist[0]]
                    elif linelist[0] in ('pushl', 'popl'):
                        resbin = self.instr[linelist[0]] + self.regs[linelist[1]] + self.regs["rnone"]
                    elif linelist[0] in ('addl', 'subl', 'andl', 'xorl', 'rrmovl') \
                         or linelist[0].startswith('cmov'):
                        reglist = linelist[1].split(',')
                        resbin = self.instr[linelist[0]] + self.regs[reglist[0]] + self.regs[reglist[1]]
                    elif linelist[0].startswith('j') or linelist[0] == 'call':
                        resbin = self.instr[linelist[0]]
                        if linelist[1] in labels:
                            resbin += self.endianStr(labels[linelist[1]], 4, self.bigendian)
                        else: 
                            resbin += self.endianStr(int(linelist[1], 0), 4, self.bigendian)
                    elif linelist[0] in ('irmovl', 'iaddl'):
                        reglist = linelist[1].split(',')  
                        if reglist[0] in labels:
                            instnum = self.endianStr(labels[reglist[0]], 4, self.bigendian)
                        else:
                            instnum = self.endianStr(int(reglist[0].replace('$', ''), 0), 4, self.bigendian)
                        resbin = self.instr[linelist[0]] + self.regs["rnone"] + \
                                 self.regs[reglist[1]] + instnum
                    elif linelist[0].endswith('movl'):
                        reglist = linelist[1].split(',')
                        if linelist[0] == 'rmmovl':
                            memstr = reglist[1]
                            self.regstr = reglist[0]
                        elif linelist[0] == 'mrmovl':
                            memstr = reglist[0]
                            self.regstr = reglist[1]
                        regre = re.compile('\((.+)\)')
                        regmatch = regre.search(memstr)
                        memint = regre.sub('', memstr)
                        if memint == '' or memint == None:
                            memint = '0'
                        resbin = self.instr[linelist[0]] + self.regs[self.regstr] + \
                                 self.regs[regmatch.group(1)] + \
                                 self.endianStr(int(memint, 0), 4, self.bigendian)
                    else:
                        error += 'Line %d: Instruction "%s" not defined.\n' % (linepos, linelist[0])
                        continue  
                except:
                    error += 'Line %d: Instruction error.\n' % linepos
                    continue
            else:
                try:
                    if linelist[0] == '.pos':
                        pass
                    elif linelist[0] == '.align':
                        alignment = int(linelist[1], 0)
                    elif linelist[0] in ('.long', '.word', '.byte'):
                        if alignment != 0:
                            length = alignment
                        else:
                            length = self.bytelen[linelist[0]]
                        if linelist[1] in labels:
                            resbin = self.endianStr(labels[linelist[1]], length, self.bigendian)
                        else:
                            resbin = self.endianStr(int(linelist[1], 0), length, self.bigendian)
                    else:
                        error += 'Line %d: Alignment error.\n' % linepos
                        continue
                except:
                    error += 'Line %d: Alignment error.\n' % linepos
                    continue
            if resbin != '':
                yasbin[linepos] = resbin
                
        # Write to files
        
        binpos = 0
        linepos = 0
        maxaddrlen = 3
        if self.largemem:
            maxaddrlen = len("%x" % (max(yaslineno.values())))
            if maxaddrlen < 3:
                maxaddrlen = 3
        if error != '':
            self.printError(error)
        else:
            prefixName = os.path.splitext(inputName)[0]
            outputName = prefixName + '.yo'
            outbinName = prefixName + '.ybo'
            outascName = prefixName + '.yao'
            try:
                fout = open(outputName, 'w')
                fbout = open(outbinName, 'wb')
                if self.asciibin:
                    faout = open(outascName, 'w')
            except IOError:
                print('Error: cannot create output files')
                sys.exit(1)
            for line in origline:
                linepos += 1
                if (linepos in yasbin) and (linepos in yaslineno):
                    ystr = yasbin[linepos]
                    nowaddr = yaslineno[linepos]
                    if binpos != nowaddr:
                        blank = '0' * (2  * (nowaddr - binpos))
                        if self.asciibin:
                            faout.write(blank)
                        fbout.write(binascii.a2b_hex(blank))
                        binpos = nowaddr
                    binpos += len(ystr) // 2
                    fout.write('  0x%.*x: %-12s | %s' % (maxaddrlen, nowaddr, ystr, line))
                    if self.asciibin:
                        faout.write(ystr)
                    fbout.write(binascii.a2b_hex(ystr))
                elif linepos in yaslineno:
                    nowaddr = yaslineno[linepos]
                    fout.write('  0x%.*x:              | %s' % (maxaddrlen, nowaddr, line))
                else:
                    fout.write((' ' * (maxaddrlen + 19)) + '| %s' % line)
            try:
                if self.asciibin:
                    faout.close()
                fout.close()
                fbout.close()
            except IOError:
                pass
            print('Assembled file: %s' % os.path.basename(inputName))

def showUsage():
    print('''Usage: %s [options] [assembly file]

Options:
  -h, --help       show this help message and exit
  -l, --largemem   support code generation for more than 4096 bytes. (default
                   is enabled)
  -b, --bigendian  code generation using big-endian. (default is little-
                   endian)
  -s, --second     using generation rules in csapp 2nd edition. (default using
                   1st editon rules)
  -a, --asciibin   enable conversion binary object to ASCII digits. (default
                   is disabled)
''' % os.path.basename(sys.argv[0]))
    sys.exit(1)
    
def main():
    print('Y86 Assembler %s\nCopyright (c) 2012 Linus Yang\n' % __ver__)
    largemem = True
    bigendian = False
    second = False
    asciibin = False
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'lbsah', ['largemem', 'bigendian', 'second', 'asciibin', 'help'])
        if len(opts) == 0 and len(args) != 1:
            if len(args) == 0:
                print("Error: missing input file")
            else:
                print("Error: only one input file allowed")
            showUsage()
        for o, a in opts:
            if o in ('-l', '--largemem'):
                largemem = True
            if o in ('-b', '--bigendian'):
                bigendian = True
                print('Warning: generation using big-endian')
            if o in ('-s', '--second'):
                second = True
                print('Warning: using csapp 2nd edition rules')
            if o in ('-a', '--asciibin'):
                asciibin = True
            if o in ('-h', '--help'):
                showUsage()
    except getopt.GetoptError:
        print("Error: illegal option")
        showUsage() 
    assembler = YAssembler(largemem, bigendian, second, asciibin)
    assembler.runAssembler(args[0])
    
if __name__ == '__main__':
    main()
