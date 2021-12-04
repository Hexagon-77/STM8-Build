;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.0 #12072 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _clock
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	main.c: 21: unsigned int clock(void)
;	-----------------------------------------
;	 function clock
;	-----------------------------------------
_clock:
	sub	sp, #4
;	main.c: 23: unsigned char h = TIM1_PCNTRH;
	ld	a, 0x52bf
	ld	xh, a
;	main.c: 24: unsigned char l = TIM1_PCNTRL;
	ld	a, 0x52c0
;	main.c: 25: return((unsigned int)(h) << 8 | l);
	clr	(0x02, sp)
	clr	(0x03, sp)
	or	a, (0x02, sp)
	rlwa	x
	or	a, (0x03, sp)
	ld	xh, a
;	main.c: 26: }
	addw	sp, #4
	ret
;	main.c: 28: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 30: CLK_DIVR = 0x00; // Set the frequency to 16 MHz
	mov	0x50c0+0, #0x00
;	main.c: 31: CLK_PCKENR2 |= 0x02; // Enable clock to timer
	bset	20676, #1
;	main.c: 35: TIM1_PSCRH = 0x3e;
	mov	0x52c1+0, #0x3e
;	main.c: 36: TIM1_PSCRL = 0x80;
	mov	0x52c2+0, #0x80
;	main.c: 38: TIM1_CR1 = 0x01;
	mov	0x52b0+0, #0x01
;	main.c: 41: PE_DDR = 0x80;
	mov	0x5016+0, #0x80
;	main.c: 42: PE_CR1 = 0x80;
	mov	0x5017+0, #0x80
;	main.c: 44: PC_DDR = 0x80;
	mov	0x500c+0, #0x80
;	main.c: 45: PC_CR1 = 0x80;
	mov	0x500d+0, #0x80
00106$:
;	main.c: 49: PE_ODR &= 0x7f;
	bres	20500, #7
;	main.c: 50: if (clock() % 1000 <= 500)
	call	_clock
	ldw	y, #0x03e8
	divw	x, y
	cpw	y, #0x01f4
	jrugt	00102$
;	main.c: 51: PE_ODR |= 0x80;
	bset	20500, #7
00102$:
;	main.c: 52: PC_ODR &= 0x7f;
	bres	20490, #7
;	main.c: 53: if (clock() % 2000 <= 1000)
	call	_clock
	ldw	y, #0x07d0
	divw	x, y
	cpw	y, #0x03e8
	jrugt	00106$
;	main.c: 54: PC_ODR |= 0x80;
	bset	20490, #7
	jra	00106$
;	main.c: 56: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
