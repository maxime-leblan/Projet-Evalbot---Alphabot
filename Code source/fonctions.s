	;; RK - Evalbot (Cortex M3 de Texas Instrument)
		AREA    |.text|, CODE, READONLY
			
; blinking frequency
FREQUENCE_7   		EQU     0x00989680 ; FREQUENCE = 10e7 Hz
FREQUENCE_65   		EQU     0x004C4B40 ; FREQUENCE = 5 * 10e6 Hz (environ 1s)
FREQUENCE_6   		EQU     0x000F4240 ; FREQUENCE = 10e6 Hz
FREQUENCE_55   		EQU     0x0007A120 ; FREQUENCE = 5 * 10e5 Hz
FREQUENCE_5   		EQU     0x000186A0 ; FREQUENCE = 10e5 Hz
FREQUENCE_66666   	EQU     0x0001046A ; FREQUENCE = 66 666 Hz

; R2 => registre de stockage temporaire des données
; R3 => registre de stockage temporaire des adresses
			
		ENTRY
		; export des fonctions
		EXPORT WAIT_1S
		EXPORT WAIT_0_1S
		EXPORT INC_CODE_LETTRE
		EXPORT INC_CODE_LETTRE_BASE
		EXPORT RESET_CODE_LETTRE
			
		
		; export des variables
		EXPORT code_lettre
		EXPORT base
		
		
		; Fonction : Attendre 1 seconde
WAIT_1S
		ldr r2, =FREQUENCE_65 
wait_1s	
		subs r2, #1
        bne wait_1s
		BX LR
		
		; Fonction : Attendre 0.1 seconde
WAIT_0_1S
		ldr r2, =FREQUENCE_55
wait_0_1s	
		subs r2, #1
        bne wait_0_1s
		BX LR

RESET_CODE_LETTRE
		
		LDR r3, =code_lettre ; on récupère l'adresse de code_lettre dans r3
		MOV r2, #0x0
		STRB r2, [r3] ; on initialise code_lettre à 0
		
		BX LR
		
INC_CODE_LETTRE
		ldr r3, =code_lettre ; on récupère l'adresse de code_lettre dans r3
		LDRB r2, [r3] ; on récupère la valeur de code_lettre dans r2
		ADD r2, r2, #1 ; code_lettre = code_lettre + 1
		STRB r2, [r3] ; on enregistre la nouvelle valeur de code_lettre dans sa variable dans la mémoire
		BX LR
		
INC_CODE_LETTRE_BASE
		LDR r3, =code_lettre ; on récupère l'adresse de code_lettre dans r3
		LDRB r2, [r3] ; on récupère la valeur de code_lettre dans r2
		LDR r5, =base ; adresse de base
		LDRB r4, [r5] ; r4 contient base
		
		ADD r2, r2, r4 ; code_lettre = code_lettre + 5
		STRB r2, [r3]
		BX LR
		
		AREA constantes, DATA, READONLY
base	DCB		6
		
		AREA variables, DATA, READWRITE
code_lettre SPACE 1

        END