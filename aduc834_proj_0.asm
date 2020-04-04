$NOMOD51				; Wy��czenie symboli standardowego 8051
						; Pozostaj� ACC, B, DPL, DPH, PSW, SP
$include (aduc834.h)	; W��czenie symboli dla ADuC834
; ______________________________________________________________________
; Deklaracja w�asnych oznacze�
;FAN EQU P1.0			; Port steruj�cy prac� wentylatora
						; Je�li potrzebujesz, dopisz wi�cej deklaracji
; ______________________________________________________________________
CSEG					; Segment programu

ORG 0000H				; Adres w pami�ci programu 0000h
	JMP START			; Skocz do adresu przypisanego etykiecie START (0060h)

ORG 0060H 				; Tu zaczyna si� program g��wny
START:
; Od tego miejsca do etykiety LOOP znajduj� si� instrukcje wykonywane TYLKO jeden raz
; na pocz�tku programu. S� to instrukcje zwi�zane z inicjalizacj� uk�adu.
	MOV SP,#7FH			; Ustawienie wska�nika stosu na 7Fh
	CLR P0.0 ;poczatkowe zerowanie pin�w
	CLR P0.1
	CLR P0.2
	CLR P0.3
; Od tego miejsca powinien rozpoczyna� si� kod programu g��wnego (wraz z wywo�aniem podprogram�w).

	

LOOP:
; Instrukcje zapisane pomi�dzy etykiet� LOOP a instrukcj� JMP LOOP, s� powtarzane
; do wy��czenia zasilania / do sygna�u reset i stanowi� p�tl� g��wn� programu.
	JNB P2.0, UP ; zalaczanie od P0.3 do P0.0
	JNB P2.1, DOWN ; zalaczanie od P0.0 do P0.3
	JMP LOOP
;______________________________________________________________________
; Tu powinien znajdowa� si� kod podprogram�w i obs�ugi przerwa� np.:
	
UP:
	JNB P2.1, DOWN
	JNB P2.2, LOOP
	
	SETB P0.0 ; ustawienie 1 bitu na 1
	ACALL CZEKAJ ; skok do podprogramu
	CLR P0.0 ; zerowanie 1 bitu
	SETB P0.1 ; ustwienie 2 bitu na 1
	ACALL CZEKAJ
	CLR P0.1
	CLR P0.0
	SETB P0.2
	ACALL CZEKAJ
	CLR P0.2
	SETB P0.3
	ACALL CZEKAJ
	CLR P0.3
	
	JMP UP
	
DOWN:
	JNB P2.0, UP
	JNB P2.2, LOOP
	
	SETB P0.3
	ACALL CZEKAJ
	CLR P0.3
	SETB P0.2
	ACALL CZEKAJ
	CLR P0.2
	SETB P0.1
	ACALL CZEKAJ
	CLR P0.1
	SETB P0.0
	ACALL CZEKAJ
	CLR P0.0
	
	JMP DOWN
	
	
CZEKAJ: 

	MOV B,#50
	op:
		MOV A,#255 ;255 cykli
		DJNZ ACC,$ ;2 cykle
		DJNZ B,op ;2 cykle
	RET
; ______________________________________________________________________
END						; Koniec kodu do kompilacji