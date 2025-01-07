;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.4.0 #14620 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _display
	.globl _milis
	.globl _init_milis
	.globl _GPIO_WriteLow
	.globl _GPIO_WriteHigh
	.globl _GPIO_Init
	.globl _CLK_HSIPrescalerConfig
	.globl _init
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
	.area SSEG
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
	int _TRAP_IRQHandler ; trap
	int _TLI_IRQHandler ; int0
	int _AWU_IRQHandler ; int1
	int _CLK_IRQHandler ; int2
	int _EXTI_PORTA_IRQHandler ; int3
	int _EXTI_PORTB_IRQHandler ; int4
	int _EXTI_PORTC_IRQHandler ; int5
	int _EXTI_PORTD_IRQHandler ; int6
	int _EXTI_PORTE_IRQHandler ; int7
	int _CAN_RX_IRQHandler ; int8
	int _CAN_TX_IRQHandler ; int9
	int _SPI_IRQHandler ; int10
	int _TIM1_UPD_OVF_TRG_BRK_IRQHandler ; int11
	int _TIM1_CAP_COM_IRQHandler ; int12
	int _TIM2_UPD_OVF_BRK_IRQHandler ; int13
	int _TIM2_CAP_COM_IRQHandler ; int14
	int _TIM3_UPD_OVF_BRK_IRQHandler ; int15
	int _TIM3_CAP_COM_IRQHandler ; int16
	int _UART1_TX_IRQHandler ; int17
	int _UART1_RX_IRQHandler ; int18
	int _I2C_IRQHandler ; int19
	int _UART3_TX_IRQHandler ; int20
	int _UART3_RX_IRQHandler ; int21
	int _ADC2_IRQHandler ; int22
	int _TIM4_UPD_OVF_IRQHandler ; int23
	int _EEPROM_EEC_IRQHandler ; int24
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
	call	___sdcc_external_startup
	tnz	a
	jreq	__sdcc_init_data
	jp	__sdcc_program_startup
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
;	./src/main.c: 10: void init(void) {
; genLabel
;	-----------------------------------------
;	 function init
;	-----------------------------------------
;	Register assignment is optimal.
;	Stack space usage: 0 bytes.
_init:
;	./src/main.c: 11: CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); // taktovani MCU na 16MHz
; genSend
	clr	a
; genCall
	call	_CLK_HSIPrescalerConfig
;	./src/main.c: 13: GPIO_Init(DIN_PORT, DIN_PIN, GPIO_MODE_OUT_PP_LOW_SLOW);
; genIPush
	push	#0xc0
; genSend
	ld	a, #0x04
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_Init
;	./src/main.c: 14: GPIO_Init(CS_PORT, CS_PIN, GPIO_MODE_OUT_PP_HIGH_SLOW);
; genIPush
	push	#0xd0
; genSend
	ld	a, #0x02
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_Init
;	./src/main.c: 15: GPIO_Init(CLK_PORT, CLK_PIN, GPIO_MODE_OUT_PP_LOW_SLOW);
; genIPush
	push	#0xc0
; genSend
	ld	a, #0x01
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_Init
;	./src/main.c: 17: init_milis();
; genCall
	jp	_init_milis
; genLabel
00101$:
;	./src/main.c: 18: }
; genEndFunction
	ret
;	./src/main.c: 20: void display(uint8_t address, uint8_t data) {
; genLabel
;	-----------------------------------------
;	 function display
;	-----------------------------------------
;	Register assignment is optimal.
;	Stack space usage: 2 bytes.
_display:
	pushw	x
; genReceive
	ld	(0x01, sp), a
;	./src/main.c: 22: LOW(CS); // začátek přenosu
; genSend
	ld	a, #0x02
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteLow
;	./src/main.c: 27: mask = 0b10000000;
; genAssign
	ld	a, #0x80
	ld	(0x02, sp), a
;	./src/main.c: 28: while (mask) {
; genLabel
00104$:
; genIfx
	tnz	(0x02, sp)
	jrne	00157$
	jp	00106$
00157$:
;	./src/main.c: 29: if (address & mask) {
; genAnd
	ld	a, (0x01, sp)
	and	a, (0x02, sp)
; genIfx
	tnz	a
	jrne	00158$
	jp	00102$
00158$:
;	./src/main.c: 30: HIGH(DIN);
; genSend
	ld	a, #0x04
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteHigh
; genGoto
	jp	00103$
; genLabel
00102$:
;	./src/main.c: 32: LOW(DIN);
; genSend
	ld	a, #0x04
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteLow
; genLabel
00103$:
;	./src/main.c: 34: HIGH(CLK);
; genSend
	ld	a, #0x01
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteHigh
;	./src/main.c: 35: mask = mask >> 1;
; genRightShiftLiteral
	srl	(0x02, sp)
;	./src/main.c: 36: LOW(CLK);
; genSend
	ld	a, #0x01
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteLow
; genGoto
	jp	00104$
; genLabel
00106$:
;	./src/main.c: 39: mask = 0b10000000;
; genAssign
	ld	a, #0x80
	ld	(0x02, sp), a
;	./src/main.c: 40: while (mask) {
; genLabel
00110$:
; genIfx
	tnz	(0x02, sp)
	jrne	00159$
	jp	00112$
00159$:
;	./src/main.c: 41: if (data & mask) {
; genAnd
	ld	a, (0x05, sp)
	and	a, (0x02, sp)
; genIfx
	tnz	a
	jrne	00160$
	jp	00108$
00160$:
;	./src/main.c: 42: HIGH(DIN);
; genSend
	ld	a, #0x04
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteHigh
; genGoto
	jp	00109$
; genLabel
00108$:
;	./src/main.c: 44: LOW(DIN);
; genSend
	ld	a, #0x04
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteLow
; genLabel
00109$:
;	./src/main.c: 46: HIGH(CLK);
; genSend
	ld	a, #0x01
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteHigh
;	./src/main.c: 47: mask = mask >> 1;
; genRightShiftLiteral
	srl	(0x02, sp)
;	./src/main.c: 48: LOW(CLK);
; genSend
	ld	a, #0x01
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteLow
; genGoto
	jp	00110$
; genLabel
00112$:
;	./src/main.c: 51: HIGH(CS); // konec přenosu
; genSend
	ld	a, #0x02
; genSend
	ldw	x, #0x5005
; genCall
	call	_GPIO_WriteHigh
; genLabel
00113$:
;	./src/main.c: 52: }
; genEndFunction
	popw	x
	popw	x
	pop	a
	jp	(x)
;	./src/main.c: 54: int main(void) {
; genLabel
;	-----------------------------------------
;	 function main
;	-----------------------------------------
;	Register assignment might be sub-optimal.
;	Stack space usage: 15 bytes.
_main:
	sub	sp, #15
;	./src/main.c: 56: uint32_t time = 0;
; genAssign
	clrw	x
	ldw	(0x03, sp), x
	ldw	(0x01, sp), x
;	./src/main.c: 57: uint8_t number = 0;
; genAssign
	clr	(0x0d, sp)
;	./src/main.c: 58: uint16_t number1 = 000;
; genAssign
	clrw	x
	ldw	(0x0e, sp), x
;	./src/main.c: 62: init();
; genCall
	call	_init
;	./src/main.c: 64: display(DECODE_MODE, 0b11111111);
; genIPush
	push	#0xff
; genSend
	ld	a, #0x09
; genCall
	call	_display
;	./src/main.c: 65: display(SCAN_LIMIT, 7);
; genIPush
	push	#0x07
; genSend
	ld	a, #0x0b
; genCall
	call	_display
;	./src/main.c: 66: display(INTENSITY, 1);
; genIPush
	push	#0x01
; genSend
	ld	a, #0x0a
; genCall
	call	_display
;	./src/main.c: 67: display(DISPLAY_TEST, DISPLAY_TEST_OFF);
; genIPush
	push	#0x00
; genSend
	ld	a, #0x0f
; genCall
	call	_display
;	./src/main.c: 68: display(SHUTDOWN, SHUTDOWN_ON);
; genIPush
	push	#0x01
; genSend
	ld	a, #0x0c
; genCall
	call	_display
;	./src/main.c: 69: display(DIGIT0, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x01
; genCall
	call	_display
;	./src/main.c: 70: display(DIGIT1, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x02
; genCall
	call	_display
;	./src/main.c: 71: display(DIGIT2, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x03
; genCall
	call	_display
;	./src/main.c: 72: display(DIGIT3, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x04
; genCall
	call	_display
;	./src/main.c: 73: display(DIGIT4, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x05
; genCall
	call	_display
;	./src/main.c: 74: display(DIGIT5, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x06
; genCall
	call	_display
;	./src/main.c: 75: display(DIGIT6, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x07
; genCall
	call	_display
;	./src/main.c: 76: display(DIGIT7, 0xF);
; genIPush
	push	#0x0f
; genSend
	ld	a, #0x08
; genCall
	call	_display
;	./src/main.c: 78: while(1){
; genLabel
00108$:
;	./src/main.c: 80: if (milis() - time > 300){
; genCall
	call	_milis
	ldw	(0x07, sp), x
	ldw	(0x05, sp), y
; genMinus
	ldw	x, (0x07, sp)
	subw	x, (0x03, sp)
	ldw	(0x0b, sp), x
	ld	a, (0x06, sp)
	sbc	a, (0x02, sp)
	ld	(0x0a, sp), a
	ld	a, (0x05, sp)
	sbc	a, (0x01, sp)
	ld	(0x09, sp), a
; genCmp
; genCmpTnz
	ldw	x, #0x012c
	cpw	x, (0x0b, sp)
	clr	a
	sbc	a, (0x0a, sp)
	clr	a
	sbc	a, (0x09, sp)
	jrc	00140$
	jp	00108$
00140$:
; skipping generated iCode
;	./src/main.c: 81: time = milis();
; genCall
	call	_milis
	ldw	(0x03, sp), x
	ldw	(0x01, sp), y
;	./src/main.c: 82: display(DIGIT0, number);
; genIPush
	ld	a, (0x0d, sp)
	push	a
; genSend
	ld	a, #0x01
; genCall
	call	_display
;	./src/main.c: 83: number ++;
; genPlus
	inc	(0x0d, sp)
;	./src/main.c: 85: if(number>9){
; genCmp
; genCmpTnz
	ld	a, (0x0d, sp)
	cp	a, #0x09
	jrugt	00141$
	jp	00102$
00141$:
; skipping generated iCode
;	./src/main.c: 86: number=0;
; genAssign
	clr	(0x0d, sp)
; genLabel
00102$:
;	./src/main.c: 90: vysledek = number1/100;
; genCast
; genAssign
	ldw	y, (0x0e, sp)
	ldw	(0x0b, sp), y
; genDivMod
	ldw	x, (0x0b, sp)
	ldw	y, #0x0064
	divw	x, y
	ld	a, xl
; genCast
; genAssign
;	./src/main.c: 92: display(DIGIT6, vysledek);
; genIPush
	push	a
; genSend
	ld	a, #0x07
; genCall
	call	_display
;	./src/main.c: 94: n= number1%100;
; genDivMod
	ldw	x, (0x0b, sp)
	ldw	y, #0x0064
	divw	x, y
	ldw	x, y
; genCast
; genAssign
;	./src/main.c: 95: vysledek1 = n/10;
; genCast
; genAssign
; genDivMod
	ldw	y, #0x000a
	divw	x, y
	ld	a, xl
; genCast
; genAssign
;	./src/main.c: 97: display(DIGIT5, vysledek1);
; genIPush
	push	a
; genSend
	ld	a, #0x06
; genCall
	call	_display
;	./src/main.c: 99: n= number1%10;
; genDivMod
	ldw	x, (0x0b, sp)
	ldw	y, #0x000a
	divw	x, y
	ld	a, yl
; genCast
; genAssign
;	./src/main.c: 100: display(DIGIT4, n);
; genCast
; genAssign
; genIPush
	push	a
; genSend
	ld	a, #0x05
; genCall
	call	_display
;	./src/main.c: 102: number1 ++;
; genPlus
	ldw	x, (0x0e, sp)
	incw	x
	ldw	(0x0e, sp), x
00142$:
;	./src/main.c: 104: if(number1>999){
; genCast
; genAssign
	ldw	x, (0x0e, sp)
; genCmp
; genCmpTnz
	cpw	x, #0x03e7
	jrugt	00143$
	jp	00108$
00143$:
; skipping generated iCode
;	./src/main.c: 105: number1 = 0;
; genAssign
	clrw	x
	ldw	(0x0e, sp), x
; genGoto
	jp	00108$
; genLabel
00110$:
;	./src/main.c: 110: }
; genEndFunction
	addw	sp, #15
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
