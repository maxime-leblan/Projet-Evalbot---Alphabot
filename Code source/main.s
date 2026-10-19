	;; RK - Evalbot (Cortex M3 de Texas Instrument)



		AREA    |.text|, CODE, READONLY
			
		ENTRY
		EXPORT	__main
		
		;; The IMPORT command specifies that a symbol is defined in a shared object at runtime.
		IMPORT	MOTEUR_INIT					; initialise les moteurs (configure les pwms + GPIO)
		
		IMPORT	MOTEUR_DROIT_ON				; activer le moteur droit
		IMPORT  MOTEUR_DROIT_OFF			; déactiver le moteur droit
		IMPORT  MOTEUR_DROIT_AVANT			; moteur droit tourne vers l'avant
		IMPORT  MOTEUR_DROIT_ARRIERE		; moteur droit tourne vers l'arrière
		IMPORT  MOTEUR_DROIT_INVERSE		; inverse le sens de rotation du moteur droit
		
		IMPORT	MOTEUR_GAUCHE_ON			; activer le moteur gauche
		IMPORT  MOTEUR_GAUCHE_OFF			; déactiver le moteur gauche
		IMPORT  MOTEUR_GAUCHE_AVANT			; moteur gauche tourne vers l'avant
		IMPORT  MOTEUR_GAUCHE_ARRIERE		; moteur gauche tourne vers l'arrière
		IMPORT  MOTEUR_GAUCHE_INVERSE		; inverse le sens de rotation du moteur gauche
		
		; Import des fonctions du fichier fonctions.s
		IMPORT WAIT_1S
		IMPORT WAIT_0_1S
		IMPORT INC_CODE_LETTRE
		IMPORT INC_CODE_LETTRE_BASE
		IMPORT RESET_CODE_LETTRE
		
		; Import des variables du fichier fonctions.s
		IMPORT base
		IMPORT code_lettre
			
		; Import des fonctions du fichiers config_periphs.s
		IMPORT INIT_CLOCK
		IMPORT INIT_LEDS
		IMPORT INIT_BUMPERS
		IMPORT INIT_SWITCHS
		IMPORT ALLUMER_LED_1
		IMPORT ALLUMER_LED_2
		IMPORT ETEINDRE_LED_1
		IMPORT ETEINDRE_LED_2
		IMPORT SW1_EST_PRESSE
		IMPORT SW2_EST_PRESSE
		IMPORT BPR_EST_PRESSE
		IMPORT BPL_EST_PRESSE
		
		; Import des variables du fichier config_periphs.s
		IMPORT adresses_periphs
			
		; Import des fonctions du fichier deplacements.s
		IMPORT DEP_QUART_TOUR_R
		IMPORT DEP_QUART_TOUR_L
		IMPORT DEP_DEMI_TOUR_R
		IMPORT DEP_DEMI_TOUR_L
		IMPORT DEP_HUITIEME_TOUR_R
		IMPORT DEP_HUITIEME_TOUR_L
		IMPORT DEP_SEIZIEME_TOUR_R
		IMPORT DEP_SEIZIEME_TOUR_L
		IMPORT DEP_LIGNE_DROITE
		IMPORT DEP_DEMI_LIGNE_DROITE
		IMPORT DEP_DEMI_CERCLE_R
		IMPORT DEP_DEMI_CERCLE_L
		IMPORT DEP_GRAND_DEMI_CERCLE_R
		IMPORT DEP_GRAND_DEMI_CERCLE_L
			
		IMPORT DEP_LETTRE_A
		IMPORT DEP_LETTRE_B
		IMPORT DEP_LETTRE_C
		IMPORT DEP_LETTRE_D
		IMPORT DEP_LETTRE_E
		IMPORT DEP_LETTRE_F
		IMPORT DEP_LETTRE_G
		IMPORT DEP_LETTRE_H
		IMPORT DEP_LETTRE_I
		IMPORT DEP_LETTRE_J
		IMPORT DEP_LETTRE_K
		IMPORT DEP_LETTRE_L
		IMPORT DEP_LETTRE_M
		IMPORT DEP_LETTRE_N
		IMPORT DEP_LETTRE_O
		IMPORT DEP_LETTRE_P
		IMPORT DEP_LETTRE_Q
		IMPORT DEP_LETTRE_R
		IMPORT DEP_LETTRE_S
		IMPORT DEP_LETTRE_T
		IMPORT DEP_LETTRE_U
		IMPORT DEP_LETTRE_V
		IMPORT DEP_LETTRE_W
		IMPORT DEP_LETTRE_X
		IMPORT DEP_LETTRE_Y
		IMPORT DEP_LETTRE_Z

__main	

		; R11 => registre de stockage temporaire des données
		; R12 => registre de stockage temporaire des adresses
		
		
		; R2 => stocke la valeur d'un élément du tableau adresses_periphs
		; R3 => stocke l'adresse d'un élément du tableau adresses_periphs
		
		; R4 => stocke une valeur temporairement


		;; BL Branchement vers un lien (sous programme)
   		   
		; Configuration de la Clock et des périphériques
		BL	INIT_CLOCK
		BL	INIT_LEDS
		BL	INIT_BUMPERS
		BL	INIT_SWITCHS
		
		; Configure les PWM + GPIO
		BL	MOTEUR_INIT	
		
		; ---- DEBUT PROGRAMME ----
		
		; Clignotement par défaut des LEDs pour signifier que le programme est chargé dans l'Evalbot
		BL ALLUMER_LED_1
		BL ALLUMER_LED_2
		BL WAIT_0_1S
		BL ETEINDRE_LED_1
		BL ETEINDRE_LED_2
		BL WAIT_0_1S
		BL ALLUMER_LED_1
		BL ALLUMER_LED_2
		BL WAIT_0_1S
		BL ETEINDRE_LED_1
		BL ETEINDRE_LED_2
		
		; On initialise code_lettre à 0
		BL RESET_CODE_LETTRE
		
		; On initialise R4 à 0 indiquant que l'Evalbot ne tourne pas sur lui même
		
		; ---- DEBUT DE LA BOUCLE PRINCIPALE ----
		
MainLoop
		
		; Si le Switch 1 est pressé, on incrémente la variable code_lettre
		BL SW1_EST_PRESSE
		BNE Si_1
		
		BL INC_CODE_LETTRE
		; on fait clignoter la LED 1 pour indiquer un changement de valeur
		BL ALLUMER_LED_1
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL ETEINDRE_LED_1
Si_1
		; Si le Switch 2 est pressé, on incrémente la variable code_lettre de la valeur contenu dans "base"
		BL SW2_EST_PRESSE
		BNE Si_2
		
		BL INC_CODE_LETTRE_BASE
		; on fait clignoter la LED 2 pour indiquer un changement de valeur
		BL ALLUMER_LED_2
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL ETEINDRE_LED_2
Si_2
		
		; Si le Bumper gauche est pressé, on réinitialise code_lettre à 0
		BL BPL_EST_PRESSE
		BNE Si_4
		
		BL RESET_CODE_LETTRE
		BL ALLUMER_LED_2
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL ETEINDRE_LED_2
		
Si_4
		
		; Si le Bumper droit est pressé, alors l'Evalbot va tracer la lettre correspondante à la valeur de code_lettre
		BL BPR_EST_PRESSE
		BNE.W Si_3
		
		; ---- DEBUT EXECUTION DU TRACAGE DE LA LETTRE CORRESPONDANTE ----
		
		; On lance une animation des LEDs pour indiquer le lancement du processus du traçage de lettre
		MOV r11, #0x3
While_1

		BL ALLUMER_LED_1
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL ALLUMER_LED_2
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL ETEINDRE_LED_1
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL ETEINDRE_LED_2
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		BL WAIT_0_1S
		
		SUBS r11, #1
		CMP r11, #0x0
		BNE While_1
		
		; On récupère la valeur de code_lettre
		LDR r12, = code_lettre
		LDRB r11, [r12]
		; On exécute la fonction de déplacement pour la lettre associée à code_lettre
		
		; ----- LIGNE DE TEST TEMPORAIRE -----
		;BL DEP_DEMI_TOUR_R
		; ----- FIN LIGNE DE TEST TEMPORAIRE -----
		
		; Lettre A
		CMP r11, #1
		BNE Si_5
		
		BL DEP_LETTRE_A
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_5
		; Lettre B
		CMP r11, #2
		BNE Si_6
		
		BL DEP_LETTRE_B
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_6
		; Lettre C
		CMP r11, #3
		BNE Si_7
		
		BL DEP_LETTRE_C
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_7
		; Lettre D
		CMP r11, #4
		BNE Si_8
		
		BL DEP_LETTRE_D
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_8
		; Lettre E
		CMP r11, #5
		BNE Si_9
		
		BL DEP_LETTRE_E
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_9
		; Lettre F
		CMP r11, #6
		BNE Si_10
		
		BL DEP_LETTRE_F
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_10
		; Lettre G
		CMP r11, #7
		BNE Si_30
		
		BL DEP_LETTRE_G
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_30
		; Lettre H
		CMP r11, #8
		BNE Si_11
		
		BL DEP_LETTRE_H
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_11
		; Lettre I
		CMP r11, #9
		BNE Si_12
		
		BL DEP_LETTRE_I
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_12
		; Lettre J
		CMP r11, #10
		BNE Si_13
		
		BL DEP_LETTRE_J
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_13
		; Lettre K
		CMP r11, #11
		BNE Si_14
		
		BL DEP_LETTRE_K
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_14
		; Lettre L
		CMP r11, #12
		BNE Si_15
		
		BL DEP_LETTRE_L
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_15
		; Lettre M
		CMP r11, #13
		BNE Si_16
		
		BL DEP_LETTRE_M
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_16
		; Lettre N
		CMP r11, #14
		BNE Si_17
		
		BL DEP_LETTRE_N
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_17
		; Lettre O
		CMP r11, #15
		BNE Si_18
		
		BL DEP_LETTRE_O
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_18
		; Lettre P
		CMP r11, #16
		BNE Si_19
		
		BL DEP_LETTRE_P
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_19
		; Lettre Q
		CMP r11, #17
		BNE Si_20
		
		BL DEP_LETTRE_Q
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_20
		; Lettre R
		CMP r11, #18
		BNE Si_21
		
		BL DEP_LETTRE_R
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_21
		; Lettre S
		CMP r11, #19
		BNE Si_22
		
		BL DEP_LETTRE_S
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_22
		; Lettre T
		CMP r11, #20
		BNE Si_23
		
		BL DEP_LETTRE_T
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_23
		; Lettre U
		CMP r11, #21
		BNE Si_24
		
		BL DEP_LETTRE_U
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_24
		; Lettre V
		CMP r11, #22
		BNE Si_25
		
		BL DEP_LETTRE_V
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_25
		; Lettre W
		CMP r11, #23
		BNE Si_26
		
		BL DEP_LETTRE_W
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_26
		; Lettre X
		CMP r11, #24
		BNE Si_27
		
		BL DEP_LETTRE_X
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_27
		; Lettre Y
		CMP r11, #25
		BNE Si_28
		
		BL DEP_LETTRE_Y
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_28
		; Lettre Z
		CMP r11, #26
		BNE Si_29
		
		BL DEP_LETTRE_Z
		; On réinitialise la variable code_lettre
		BL RESET_CODE_LETTRE
		
Si_29
		
Si_3
		
		B MainLoop
		
		NOP
        END