.text
.align 2
.global miMain
.type miMain, %function
.extern arbol


miMain: // X0 pixels
		mov		x10, x0			//  BackUp pixels address
		mov		x15, x1			//  BackUp control

        movz    x11, #120
		
miMain_loop:

// Pinto Fondo
        mov     x0, x10
        mov     x1, 0
        movz    x2, 0
        movz    x3, 320
        movz    x4, 240
        
		movz	w5, 0xffff			// 0x00000aa0
		movk	w5, 0xffff, lsl 16	// w2 = color = 0xffff0aa0
        bl      pintar_rectangulo_color
        
        
        ldrb    w7, [x15,#0] 
        cmp     w7, #1
        b.ne    miMain_tecla2
        sub     x11, x11, #1
        
 miMain_tecla2:       
        ldrb    w7, [x15,#1] 
        cmp     w7, #1
        b.ne    miMain_tecla_end
        add     x11, x11, #1
        
miMain_tecla_end:     
  /*  x0  direccion de pantalla
    x1  columna de pantalla
    x2  fila de pantalla
    x3  dire_imagen*/
    
        mov     x0, x10
        mov     x1, x11
        movz    x2, #100
        
        adrp    x3, arbol
        add     x3,x3, :lo12:arbol

        bl      pintar_img

miMain_wait: 							//wait for frame

        ldrb	w7, [x15, #8]
		subs	wzr, w7, #1
        b.ne	miMain_wait
		mov		w7, #0
		strb	w7,[x15, #8]
		b		miMain_loop

/*
    x0  direccion de pantalla
    x1  columna de pantalla
    x2  fila de pantalla
    x3  ancho
    x4  alto
    x5  color
*/
pintar_rectangulo_color:
        
        sub     sp, sp ,32
        str     x29,[sp, 16]
        str     x30,[sp, 8]
        str     x6,[sp, 0]
        
        movz    x6, 0x500   // 320 x 4 = 1280 = 0x500
        mul     x2, x2, x6
        add     x0, x0, x2
        
        lsl     x1, x1, #2
        add     x0, x0, x1
        
        movz    x2, #0      // Cont Alto

pintar_rectangulo_color_loop_fila:        
        movz    x1, #0      // Cont Ancho

pintar_rectangulo_color_loop_columna:        
        str     x5, [x0,#0]             // Llamar a funcion que verifique que estoy dentro del rango
        add     x0, x0, #4
        add     x1, x1, #1
        cmp     x1, x3
        b.lt       pintar_rectangulo_color_loop_columna
        add     x0, x0, #1280
        lsl     x6, x3, #2
        sub     x0, x0, x6
        
        add     x2, x2, #1
        
        cmp     x2, x4
        b.lt       pintar_rectangulo_color_loop_fila
        
   
		ldr     x6,[sp, 0]
        ldr     x30,[sp, 8]
        ldr     x29,[sp, 16]
        add     sp, sp ,32
		ret
        
        

/*
    x0  direccion de pantalla
    x1  columna de pantalla
    x2  fila de pantalla
    x3  dire_imagen
*/
pintar_img:
        
        sub     sp, sp ,32
        str     x29,[sp, 16]
        str     x30,[sp, 8]
        str     x6,[sp, 0]
        
        movz    x6, 0x500   // 320 x 4 = 1280 = 0x500
        mul     x2, x2, x6
        add     x0, x0, x2
        
        lsl     x1, x1, #2
        add     x0, x0, x1
        
        ldr     x4, [x3, #0]
        ldr     x5, [x3, #8]
        add     x3, x3, #16
        
        
        movz    x2, #0      // Cont Alto

pintar_img_loop_fila:        
        movz    x1, #0      // Cont Ancho

pintar_img_loop_columna:
        ldr     w6, [x3,#0]
        lsr     w7, w6, #24
        cmp     w7, 0xff
        b.lt    pintar_img_no_dibujar
        str     w6, [x0,#0]             // Llamar a funcion que verifique que estoy dentro del rango

pintar_img_no_dibujar:        
        add     x3, x3, #4
        add     x0, x0, #4
        add     x1, x1, #1
        cmp     x1, x4
        b.lt       pintar_img_loop_columna
        add     x0, x0, #1280
        lsl     x6, x4, #2
        sub     x0, x0, x6
        
        add     x2, x2, #1
        
        cmp     x2, x5
        b.lt       pintar_img_loop_fila
        
   
		ldr     x6,[sp, 0]
        ldr     x30,[sp, 8]
        ldr     x29,[sp, 16]
        add     sp, sp ,32
		ret
        
        
        
