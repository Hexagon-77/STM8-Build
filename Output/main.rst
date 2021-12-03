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
                                     12 ;--------------------------------------------------------
                                     13 ; ram data
                                     14 ;--------------------------------------------------------
                                     15 	.area DATA
                                     16 ;--------------------------------------------------------
                                     17 ; ram data
                                     18 ;--------------------------------------------------------
                                     19 	.area INITIALIZED
                                     20 ;--------------------------------------------------------
                                     21 ; Stack segment in internal ram 
                                     22 ;--------------------------------------------------------
                                     23 	.area	SSEG
      000001                         24 __start__stack:
      000001                         25 	.ds	1
                                     26 
                                     27 ;--------------------------------------------------------
                                     28 ; absolute external ram data
                                     29 ;--------------------------------------------------------
                                     30 	.area DABS (ABS)
                                     31 
                                     32 ; default segment ordering for linker
                                     33 	.area HOME
                                     34 	.area GSINIT
                                     35 	.area GSFINAL
                                     36 	.area CONST
                                     37 	.area INITIALIZER
                                     38 	.area CODE
                                     39 
                                     40 ;--------------------------------------------------------
                                     41 ; interrupt vector 
                                     42 ;--------------------------------------------------------
                                     43 	.area HOME
      008000                         44 __interrupt_vect:
      008000 82 00 80 07             45 	int s_GSINIT ; reset
                                     46 ;--------------------------------------------------------
                                     47 ; global & static initialisations
                                     48 ;--------------------------------------------------------
                                     49 	.area HOME
                                     50 	.area GSINIT
                                     51 	.area GSFINAL
                                     52 	.area GSINIT
      008007                         53 __sdcc_init_data:
                                     54 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   55 	ldw x, #l_DATA
      00800A 27 07            [ 1]   56 	jreq	00002$
      00800C                         57 00001$:
      00800C 72 4F 00 00      [ 1]   58 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   59 	decw x
      008011 26 F9            [ 1]   60 	jrne	00001$
      008013                         61 00002$:
      008013 AE 00 00         [ 2]   62 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   63 	jreq	00004$
      008018                         64 00003$:
      008018 D6 80 23         [ 1]   65 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   66 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   67 	decw	x
      00801F 26 F7            [ 1]   68 	jrne	00003$
      008021                         69 00004$:
                                     70 ; stm8_genXINIT() end
                                     71 	.area GSFINAL
      008021 CC 80 04         [ 2]   72 	jp	__sdcc_program_startup
                                     73 ;--------------------------------------------------------
                                     74 ; Home
                                     75 ;--------------------------------------------------------
                                     76 	.area HOME
                                     77 	.area HOME
      008004                         78 __sdcc_program_startup:
      008004 CC 80 24         [ 2]   79 	jp	_main
                                     80 ;	return from main will return to caller
                                     81 ;--------------------------------------------------------
                                     82 ; code
                                     83 ;--------------------------------------------------------
                                     84 	.area CODE
                                     85 ;	../main.c: 3: int main() {
                                     86 ;	-----------------------------------------
                                     87 ;	 function main
                                     88 ;	-----------------------------------------
      008024                         89 _main:
                                     90 ;	../main.c: 4: GPIOA->DDR = 0xFF;
      008024 35 FF 50 02      [ 1]   91 	mov	0x5002+0, #0xff
                                     92 ;	../main.c: 5: return 0;
      008028 5F               [ 1]   93 	clrw	x
                                     94 ;	../main.c: 6: }
      008029 81               [ 4]   95 	ret
                                     96 	.area CODE
                                     97 	.area CONST
                                     98 	.area INITIALIZER
                                     99 	.area CABS (ABS)
