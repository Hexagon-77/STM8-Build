                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.1.0 #12072 (MINGW64)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _clock
                                     13 ;--------------------------------------------------------
                                     14 ; ram data
                                     15 ;--------------------------------------------------------
                                     16 	.area DATA
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area INITIALIZED
                                     21 ;--------------------------------------------------------
                                     22 ; Stack segment in internal ram 
                                     23 ;--------------------------------------------------------
                                     24 	.area	SSEG
      000001                         25 __start__stack:
      000001                         26 	.ds	1
                                     27 
                                     28 ;--------------------------------------------------------
                                     29 ; absolute external ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area DABS (ABS)
                                     32 
                                     33 ; default segment ordering for linker
                                     34 	.area HOME
                                     35 	.area GSINIT
                                     36 	.area GSFINAL
                                     37 	.area CONST
                                     38 	.area INITIALIZER
                                     39 	.area CODE
                                     40 
                                     41 ;--------------------------------------------------------
                                     42 ; interrupt vector 
                                     43 ;--------------------------------------------------------
                                     44 	.area HOME
      008000                         45 __interrupt_vect:
      008000 82 00 80 07             46 	int s_GSINIT ; reset
                                     47 ;--------------------------------------------------------
                                     48 ; global & static initialisations
                                     49 ;--------------------------------------------------------
                                     50 	.area HOME
                                     51 	.area GSINIT
                                     52 	.area GSFINAL
                                     53 	.area GSINIT
      008007                         54 __sdcc_init_data:
                                     55 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   56 	ldw x, #l_DATA
      00800A 27 07            [ 1]   57 	jreq	00002$
      00800C                         58 00001$:
      00800C 72 4F 00 00      [ 1]   59 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   60 	decw x
      008011 26 F9            [ 1]   61 	jrne	00001$
      008013                         62 00002$:
      008013 AE 00 00         [ 2]   63 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   64 	jreq	00004$
      008018                         65 00003$:
      008018 D6 80 23         [ 1]   66 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   67 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   68 	decw	x
      00801F 26 F7            [ 1]   69 	jrne	00003$
      008021                         70 00004$:
                                     71 ; stm8_genXINIT() end
                                     72 	.area GSFINAL
      008021 CC 80 04         [ 2]   73 	jp	__sdcc_program_startup
                                     74 ;--------------------------------------------------------
                                     75 ; Home
                                     76 ;--------------------------------------------------------
                                     77 	.area HOME
                                     78 	.area HOME
      008004                         79 __sdcc_program_startup:
      008004 CC 80 3A         [ 2]   80 	jp	_main
                                     81 ;	return from main will return to caller
                                     82 ;--------------------------------------------------------
                                     83 ; code
                                     84 ;--------------------------------------------------------
                                     85 	.area CODE
                                     86 ;	main.c: 21: unsigned int clock(void)
                                     87 ;	-----------------------------------------
                                     88 ;	 function clock
                                     89 ;	-----------------------------------------
      008024                         90 _clock:
      008024 52 04            [ 2]   91 	sub	sp, #4
                                     92 ;	main.c: 23: unsigned char h = TIM1_PCNTRH;
      008026 C6 52 BF         [ 1]   93 	ld	a, 0x52bf
      008029 95               [ 1]   94 	ld	xh, a
                                     95 ;	main.c: 24: unsigned char l = TIM1_PCNTRL;
      00802A C6 52 C0         [ 1]   96 	ld	a, 0x52c0
                                     97 ;	main.c: 25: return((unsigned int)(h) << 8 | l);
      00802D 0F 02            [ 1]   98 	clr	(0x02, sp)
      00802F 0F 03            [ 1]   99 	clr	(0x03, sp)
      008031 1A 02            [ 1]  100 	or	a, (0x02, sp)
      008033 02               [ 1]  101 	rlwa	x
      008034 1A 03            [ 1]  102 	or	a, (0x03, sp)
      008036 95               [ 1]  103 	ld	xh, a
                                    104 ;	main.c: 26: }
      008037 5B 04            [ 2]  105 	addw	sp, #4
      008039 81               [ 4]  106 	ret
                                    107 ;	main.c: 28: void main(void)
                                    108 ;	-----------------------------------------
                                    109 ;	 function main
                                    110 ;	-----------------------------------------
      00803A                        111 _main:
                                    112 ;	main.c: 30: CLK_DIVR = 0x00; // Set the frequency to 16 MHz
      00803A 35 00 50 C0      [ 1]  113 	mov	0x50c0+0, #0x00
                                    114 ;	main.c: 31: CLK_PCKENR2 |= 0x02; // Enable clock to timer
      00803E 72 12 50 C4      [ 1]  115 	bset	20676, #1
                                    116 ;	main.c: 35: TIM1_PSCRH = 0x3e;
      008042 35 3E 52 C1      [ 1]  117 	mov	0x52c1+0, #0x3e
                                    118 ;	main.c: 36: TIM1_PSCRL = 0x80;
      008046 35 80 52 C2      [ 1]  119 	mov	0x52c2+0, #0x80
                                    120 ;	main.c: 38: TIM1_CR1 = 0x01;
      00804A 35 01 52 B0      [ 1]  121 	mov	0x52b0+0, #0x01
                                    122 ;	main.c: 41: PE_DDR = 0x80;
      00804E 35 80 50 16      [ 1]  123 	mov	0x5016+0, #0x80
                                    124 ;	main.c: 42: PE_CR1 = 0x80;
      008052 35 80 50 17      [ 1]  125 	mov	0x5017+0, #0x80
                                    126 ;	main.c: 44: PC_DDR = 0x80;
      008056 35 80 50 0C      [ 1]  127 	mov	0x500c+0, #0x80
                                    128 ;	main.c: 45: PC_CR1 = 0x80;
      00805A 35 80 50 0D      [ 1]  129 	mov	0x500d+0, #0x80
      00805E                        130 00106$:
                                    131 ;	main.c: 49: PE_ODR &= 0x7f;
      00805E 72 1F 50 14      [ 1]  132 	bres	20500, #7
                                    133 ;	main.c: 50: if (clock() % 1000 <= 500)
      008062 CD 80 24         [ 4]  134 	call	_clock
      008065 90 AE 03 E8      [ 2]  135 	ldw	y, #0x03e8
      008069 65               [ 2]  136 	divw	x, y
      00806A 90 A3 01 F4      [ 2]  137 	cpw	y, #0x01f4
      00806E 22 04            [ 1]  138 	jrugt	00102$
                                    139 ;	main.c: 51: PE_ODR |= 0x80;
      008070 72 1E 50 14      [ 1]  140 	bset	20500, #7
      008074                        141 00102$:
                                    142 ;	main.c: 52: PC_ODR &= 0x7f;
      008074 72 1F 50 0A      [ 1]  143 	bres	20490, #7
                                    144 ;	main.c: 53: if (clock() % 2000 <= 1000)
      008078 CD 80 24         [ 4]  145 	call	_clock
      00807B 90 AE 07 D0      [ 2]  146 	ldw	y, #0x07d0
      00807F 65               [ 2]  147 	divw	x, y
      008080 90 A3 03 E8      [ 2]  148 	cpw	y, #0x03e8
      008084 22 D8            [ 1]  149 	jrugt	00106$
                                    150 ;	main.c: 54: PC_ODR |= 0x80;
      008086 72 1E 50 0A      [ 1]  151 	bset	20490, #7
      00808A 20 D2            [ 2]  152 	jra	00106$
                                    153 ;	main.c: 56: }
      00808C 81               [ 4]  154 	ret
                                    155 	.area CODE
                                    156 	.area CONST
                                    157 	.area INITIALIZER
                                    158 	.area CABS (ABS)
