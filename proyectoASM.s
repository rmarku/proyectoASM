#include "imagenes.h"
#include <stdio.h>

.text
.align 2

.global miMain
.type miMain, %function

.extern printf

.mi.String:
	.string "%d\n"


miMain: // X0 pixels
		mov		x10, X0			//  BackUp pixels address
		mov		x15, X1			//  BackUp control

		mov		x11,	#0			//	Start counter in 0 -> 76800
		movz	w2, 0x0aa0			// 0x00000aa0
		movk	w2, 0xffff, lsl 16	// w2 = color = 0xffff0aa0

		

loop2:
		lsl		X1, X11, #2		// *4 pixels

		mov		X0, X10			// X0 = pixels
		add		X0, X0, X1
		str		W2, [x0, #0]

		add		X11, X11, #1
		movz	X3,	0x2C00
		movk	X3, 0x1, lsl 16
		
		adrp	x4, nave
		add		x4, x4, #:lo12:nave
		 ldr		x3, [x4, #0]   // nave.w
		//ldr		x3, [x4, #8]   // nave.h
		
		cmp		X11, X3
		b.lt	loop2
		add		w2, w2, #1
		mov		x11,	#0

wait: 							//wait for frame

        ldrb	w7, [x15, #8]
		subs	wzr, w7, #1
        b.ne	wait
		mov		w7, #0
		strb	w7,[x15, #8]
		b		loop2


rect:
		
