$NOMOD51				; Wy³¹czenie symboli standardowego 8051
						; Pozostaj¹ ACC, B, DPL, DPH, PSW, SP
$include (aduc834.h)	; W³¹czenie symboli dla ADuC834
; ______________________________________________________________________
; Deklaracja w³asnych oznaczeñ
;FAN EQU P1.0			; Port steruj¹cy prac¹ wentylatora
						; Jeœli potrzebujesz, dopisz wiêcej deklaracji
; ______________________________________________________________________
CSEG					; Segment programu

ORG 0000H				; Adres w pamiêci programu 0000h
	JMP START			; Skocz do adresu przypisanego etykiecie START (0060h)

ORG 0060H 				; Tu zaczyna siê program g³ówny
START:
; Od tego miejsca do etykiety LOOP znajduj¹ siê instrukcje wykonywane TYLKO jeden raz
; na pocz¹tku programu. S¹ to instrukcje zwi¹zane z inicjalizacj¹ uk³adu.
	MOV SP,#7FH			; Ustawienie wskaŸnika stosu na 7Fh
	CLR P0.0 ;poczatkowe zerowanie pinów
	CLR P0.1
	CLR P0.2
	CLR P0.3
; Od tego miejsca powinien rozpoczynaæ siê kod programu g³ównego (wraz z wywo³aniem podprogramów).

	

LOOP:
; Instrukcje zapisane pomiêdzy etykiet¹ LOOP a instrukcj¹ JMP LOOP, s¹ powtarzane
; do wy³¹czenia zasilania / do sygna³u reset i stanowi¹ pêtlê g³ówn¹ programu.
	JNB P2.0, UP ; zalaczanie od P0.3 do P0.0
	JNB P2.1, DOWN ; zalaczanie od P0.0 do P0.3
	JMP LOOP
;______________________________________________________________________
; Tu powinien znajdowaæ siê kod podprogramów i obs³ugi przerwañ np.:
	
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