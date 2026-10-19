	;; RK - Evalbot (Cortex M3 de Texas Instrument)
   	
		AREA    |.text|, CODE, READONLY
 
; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf)

; The GPIODATA register is the data register
GPIO_PORTD_BASE		EQU		0x40007000		; GPIO Port D (APB) base: 0x4000.7000 (p416 datasheet de lm3s9B92.pdf)

GPIO_PORTE_BASE		EQU		0x40024000		; GPIO Port E (APB) base: 0x40024000 (p416 datasheet de lm3s9B92.pdf)

; configure the corresponding pin to be an output
; all GPIO pins are inputs by default
GPIO_O_DIR   		EQU 	0x00000400  ; GPIO Direction (p417 datasheet de lm3s9B92.pdf)

; The GPIODR2R register is the 2-mA drive control register
; By default, all GPIO pins have 2-mA drive.
GPIO_O_DR2R   		EQU 	0x00000500  ; GPIO 2-mA Drive Select (p428 datasheet de lm3s9B92.pdf)

; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

; Pul_up
GPIO_I_PUR   		EQU 	0x00000510  ; GPIO Pull-Up (p432 datasheet de lm3s9B92.pdf)

; Broches select
BROCHE4_5			EQU		0x30		; led1 & led2 sur broche 4 et 5 
BROCHE5				EQU 	0x20		; led 2
BROCHE4				EQU 	0x10		; led 1
BROCHE6				EQU 	0x40		; switch 1 (0x40)
BROCHE7				EQU 	0x80		; switch 2 (0x40)
BROCHE6_7			EQU		0xC0		; both switches
BROCHE0				EQU		0x1			; bumper right
BROCHE1				EQU		0x2			; bumper left
BROCHE1_0			EQU		0x3			; both bumpers
	
; éteindre une LED
ETEINDRE			EQU 	0x0

; Indice de chaque capteur pour les tableaux adresses_periphs et valeurs_periphs
INDICE_LED_1		EQU		0x0
INDICE_LED_2		EQU		0x4
INDICE_BUMPER_R		EQU		0x8
INDICE_BUMPER_L		EQU		0xC
INDICE_SWITCH_1		EQU		0x10
INDICE_SWITCH_2		EQU		0x14




	  	ENTRY

		EXPORT INIT_CLOCK
		EXPORT INIT_LEDS
		EXPORT INIT_BUMPERS
		EXPORT INIT_SWITCHS
		EXPORT ALLUMER_LED_1
		EXPORT ALLUMER_LED_2
		EXPORT ETEINDRE_LED_1
		EXPORT ETEINDRE_LED_2
		EXPORT SW1_EST_PRESSE
		EXPORT SW2_EST_PRESSE
		EXPORT BPR_EST_PRESSE
		EXPORT BPL_EST_PRESSE
			
		EXPORT adresses_periphs


; CONFIGURATION CLOCK
INIT_CLOCK

		; ;; Enable the Port F & D peripheral clock 		(p291 datasheet de lm3s9B96.pdf)
		; ;;									
		ldr r3, = SYSCTL_PERIPH_GPIO  			;; RCGC2
        mov r2, #0x00000038  					;; Enable clock sur GPIO D, E et F où sont branchés les leds (0x38 == 0b111000)
		; ;;														 									         (GPIO::FEDCBA)
        str r2, [r3]
		
		; ;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
		nop	   									;; tres tres important....
		nop	   
		nop	   									;; pas necessaire en simu ou en debbug step by step...
	
		BX LR
		
; CONFIGURATION LED 1
INIT_LEDS

        ldr r3, = GPIO_PORTF_BASE+GPIO_O_DIR    ;; 1 Pin du portF en sortie (broche 4 et 5 : 00110000)
        ldr r2, = BROCHE4_5	
        str r2, [r3]
		
		ldr r3, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r2, = BROCHE4_5	
        str r2, [r3]
		
		ldr r3, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensité de sortie (2mA)
        ldr r2, = BROCHE4_5			
        str r2, [r3]
		
		LDR r3, = adresses_periphs ; on récupère l'adresse du tableau contenant les adresses de chaque périphérique
		LDR r2, = GPIO_PORTF_BASE + (BROCHE4<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
		STR r2, [r3, #INDICE_LED_1] ; on enregistre l'adresse de la case mémoire gérant l'état de la LED 1 dans le tableau adresses_periphs
		
		LDR r2, = GPIO_PORTF_BASE + (BROCHE5<<2)  ;; @data Register = @base + (mask<<2) ==> LED2
		STR r2, [r3, #INDICE_LED_2] ; on enregistre l'adresse de la case mémoire gérant l'état de la LED 2 dans le tableau adresses_periphs
		
		BX LR

INIT_BUMPERS

		ldr r3, = GPIO_PORTE_BASE+GPIO_I_PUR	;; Pul_up 
        ldr r2, = BROCHE1_0		
        str r2, [r3]
		
		ldr r3, = GPIO_PORTE_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r2, = BROCHE1_0	
        str r2, [r3]     
		
		LDR r3, = adresses_periphs ; on récupère l'adresse du tableau contenant les adresses de chaque périphérique
		LDR r2, = GPIO_PORTE_BASE + (BROCHE1<<2)  ;; @data Register = @base + (mask<<2) ==> Bumper left
		STR r2, [r3, #INDICE_BUMPER_L] ; on enregistre l'adresse de la case mémoire gérant l'état du Bumper left dans le tableau adresses_periphs
		
		LDR r2, = GPIO_PORTE_BASE + (BROCHE0<<2)  ;; @data Register = @base + (mask<<2) ==> Bumper right
		STR r2, [r3, #INDICE_BUMPER_R] ; on enregistre l'adresse de la case mémoire gérant l'état du Bumper right dans le tableau adresses_periphs
		
		BX LR
		
INIT_SWITCHS

		ldr r3, = GPIO_PORTD_BASE+GPIO_I_PUR	;; Pul_up 
        ldr r2, = BROCHE6_7	
        str r2, [r3]
		
		ldr r3, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r2, = BROCHE6_7	
        str r2, [r3]     
		
		LDR r3, = adresses_periphs ; on récupère l'adresse du tableau contenant les adresses de chaque périphérique
		LDR r2, = GPIO_PORTD_BASE + (BROCHE6<<2)  ;; @data Register = @base + (mask<<2) ==> Switch 1
		STR r2, [r3, #INDICE_SWITCH_1] ; on enregistre l'adresse de la case mémoire gérant l'état du Switch 1 dans le tableau adresses_periphs
		
		LDR r2, = GPIO_PORTD_BASE + (BROCHE7<<2)  ;; @data Register = @base + (mask<<2) ==> Switch 2
		STR r2, [r3, #INDICE_SWITCH_2] ; on enregistre l'adresse de la case mémoire gérant l'état du Switch 2 dans le tableau adresses_periphs

		BX LR
		
ALLUMER_LED_1

		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_LED_1] ; on enregistre l'adresse de la case mémoire gérant l'état de la LED 1 dans R3
		MOV r2, #BROCHE4
		
		STR r2, [r3] ; on allume la LED 1
		
		BX LR

ALLUMER_LED_2

		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_LED_2] ; on enregistre l'adresse de la case mémoire gérant l'état de la LED 2 dans R3
		MOV r2, #BROCHE5
		
		STR r2, [r3] ; on allume la LED 2
		
		BX LR

ETEINDRE_LED_1

		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_LED_1] ; on enregistre l'adresse de la case mémoire gérant l'état de la LED 1 dans R3
		MOV r2, #0x0
		
		STR r2, [r3] ; on éteint la LED 1
		
		BX LR

ETEINDRE_LED_2

		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_LED_2] ; on enregistre l'adresse de la case mémoire gérant l'état de la LED 2 dans R3
		MOV r2, #0x0
		
		STR r2, [r3] ; on allume la LED 2
		
		BX LR

SW1_EST_PRESSE
		
		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_SWITCH_1] ; on enregistre l'adresse de la case mémoire gérant l'état du Switch 1 dans R3
		LDR r2, [r3] ; on récupère la valeur d'état du Switch 1
		
		CMP r2, #0x0 ; on vérifie si le Switch 1 est actuellement pressé (s'il est pressé, sa valeur d'état est 0, 1 sinon)
		
		BX LR

SW2_EST_PRESSE
		
		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_SWITCH_2] ; on enregistre l'adresse de la case mémoire gérant l'état du Switch 2 dans R3
		LDR r2, [r3] ; on récupère la valeur d'état du Switch 2
		
		CMP r2, #0x0 ; on vérifie si le Switch 2 est actuellement pressé (s'il est pressé, sa valeur d'état est 0, 1 sinon)
		
		BX LR

BPR_EST_PRESSE
		
		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_BUMPER_R] ; on enregistre l'adresse de la case mémoire gérant l'état du Bumper droit dans R3
		LDR r2, [r3] ; on récupère la valeur d'état du Bumper droit
		
		CMP r2, #0x0 ; on vérifie si le Bumper droit est actuellement pressé (s'il est pressé, sa valeur d'état est 0, 1 sinon)
		
		BX LR

BPL_EST_PRESSE
		
		LDR r3, = adresses_periphs
		LDR r3, [r3, #INDICE_BUMPER_L] ; on enregistre l'adresse de la case mémoire gérant l'état du Bumper gauche dans R3
		LDR r2, [r3] ; on récupère la valeur d'état du Bumper gauche
		
		CMP r2, #0x0 ; on vérifie si le Bumper gauche est actuellement pressé (s'il est pressé, sa valeur d'état est 0, 1 sinon)
		
		BX LR
		
		AREA variables, DATA, READWRITE
adresses_periphs SPACE 24
		
		END 