//Global
`define		RSTENABLE		1'b1
`define		RSTDISABLE		1'b0
`define		CHIPENABLE		1'b1
`define		CHIPDISABLE		1'b0
`define		READENABLE		1'b1
`define		READDISABLE		1'b0
`define		WRITEENABLE		1'b1
`define		WRITEDISABLE	1'b0
`define		ENABLE			1'b1
`define		DISABLE			1'b0

//Y86 instruction set
`define     HALT        4'H0
`define     NOP         4'H1
`define     CMOVXX      4'H2
`define     IRMOVL      4'H3
`define     RMMOVL      4'H4
`define     MRMOVL      4'H5
`define     OPL         4'H6
`define     JXX         4'H7
`define     CALL        4'H8
`define     RET         4'H9
`define     PUSHL       4'HA
`define     POPL        4'HB

//Function codes
`define		ADDL		4'H0
`define		SUBL		4'H1
`define		ANDL		4'H2
`define		XORL		4'H3
`define		JMP			4'H0
`define		JLE			4'H1
`define		JL			4'H2
`define		JE			4'H3
`define		JNE			4'H4
`define		JGE			4'H5
`define		JG			4'H6
`define		RRMOVL		4'H0
`define		CMOVLE		4'H1
`define		CMOVL		4'H2
`define		CMOVE		4'H3
`define		CMOVNE		4'H4
`define		CMOVGE		4'H5
`define		CMOVG		4'H6

//Size
`define		NIBBLE		3:0
`define		BYTE		7:0
`define		WORD		31:0
`define		INSTBUS		47:0
`define		ICODE		47:44
`define		IFUN		43:40
`define		RA			39:36
`define		RB			35:32
`define		DEST		39:8
`define		INSTMEMNUM	131071
`define		WORDNUM		32
`define		REGNUM		8

//Constant valus used HCL descriptions
`define     INOP		4'H0
`define     IHALT       4'H1
`define     IRRMOVL     4'H2
`define     IIRMOVL     4'H3
`define     IRMMOVL     4'H4
`define     IMRMOVL     4'H5
`define     IOPL        4'H6
`define     IJXX        4'H7
`define     ICALL       4'H8
`define     IRET        4'H9
`define     IPUSHL      4'HA
`define     IPOPL       4'HB
`define     FNONE       4'H0
`define     RESP        4'H4
`define     RNONE       4'HF
`define     ALUADD      4'H0
`define     SAOK        4'H1
`define     SADR        4'H2
`define     SINS        4'H3
`define     SHLT        4'H4

//Registers
`define		NOREG		4'HF
