;Countdown / Zaehler auf Null
;in Minuten und Sekunden
;
; mit 4x7-segment anzeige
;
; initialisierung
cseg at 0h
ajmp init
cseg at 100h

; -----------------
; Interrupt
;------------------
ORG 0bh
mov tl0, #000h
mov th0, #0fdh
SETB TR0
call timer
reti
;------------------
;init
;------------------
ORG 20h
init:
mov IE, #10010010b
mov tmod, #00000001b
mov tl0, #000h
mov th0, #0fdh
SETB TR0
setb P0.0
MOV R0,#0 ;Adress for row
;MOV R1,#20h ;Adress for row copy

; Initiales zeichnen des Gleiters
MOV A,#00000000b
movx @R0,A

INC R0
MOV A,#01111100b
movx @R0,A

INC R0
MOV A,#10000100b
movx @R0,A

INC R0
MOV A,#00000100b
movx @R0,A

INC R0
MOV A,#10001000b
movx @R0,A

INC R0
MOV A,#00100000b
movx @R0,A

INC R0
MOV A,#00000000b
movx @R0,A

INC R0
MOV A,#00000000b
movx @R0,A



LCALL display

main:
call new_generation
jmp main

;---------------------------
anfang:
jnb p1.0, starttimer
nurRT:
jnb p1.2, RT
jnb tr0, da
ajmp anfang
da:
lcall display
jnb P0.0, nurRT
ajmp anfang
;------------------------------
; unterprogramme
;
; start timer
starttimer:
setb tr0; start timer0
setb P1.0
ajmp anfang
; stop Timer
;stoptimer:
;clr tr0; stop timer
;setb P1.1
;ajmp anfang

RT:
clr tr0; stop timer
setb P1.2
setb P0.0
ljmp init

jmpdisplay:
lcall display
ret

;----------------------
; timer

;
timer:
push 00h
push A
call display
pop A
pop 00h
ret

;hupe:
;clr tr0; stop timer
;clr P0.0
;ret

;----- Logik für die neue Generation -----
new_generation:
MOV R0,#0;
MOV R2,#0 ;Counter row starts with row 0

checkrow:
MOV R3,#0 			;Counter column starts with column 0
MOV R4,#0			;R4 enthält die neuen Werte der Zellen der Zeile
MOV R1,#0;

checkcolumn:
MOV R7,#0
mov DPTR,#table2		;R7 enthält die anzahl der nachbarn
ACALL checkTop
ACALL checkMid
ACALL checkBottom

mov DPTR,#table			;Setze DataPointer auf masken tabelle
mov A,R3
movC A,@A+DPTR			;Hole Maske für Spalte R3
mov R6,A;

MOV A,R2;
MOV R0,A;
MOVX A,@R0;			;Laden der entsprechenden Zeile
MOV R5,A;
;MOV R1,#0

MOV A,R7;
CJNE A,#2,checkLessThan2	;Wenn A != 2 überprüfe ob weniger
MOV A,R6			;Wenn A = 2 -> Behalte Wert der Zelle bei. Hole Maske
ANL A,R5			;Maskiere Wert der Zelle aus
ORL A,R1			;Berechne neue Zeile
MOV R1,A			;Füge Wert zur neuen Zeile hinzu
JMP checkEnd

checkLessThan2:
JNC checkMoreThan2		;Wenn A < 2 -> C = 1
JMP checkEnd

checkMoreThan2:
CJNE A,#3,checkEnd		;Wenn A != 3 muss die Zelle sterben
MOV A,R6			;Wenn A = 3 -> Setze Bit
ANL A,#11111111b		;Maskiere Wert der Zelle aus
ORL A,R1			;Berechne neue Zeile
MOV R1,A			;Füge Wert zur neuen Zeile hinzu
JMP checkEnd

checkEnd:
;A < 2 CLR
;A = 3 SETB
;A > 3 CLR

;Repeat until column = 0
INC R3
MOV A,R3
CJNE A,#8,checkcolumn

 ;setting new row from storage copy
;movx @R0,TODO

;Repeat until row = 0
MOV A,R2;
ADD A,#100;
MOV R0,A;
MOV A,R1;
MOVX @R0,A;

INC R2
MOV A,R2
CJNE A,#8,checkrow

call copyNewGenerationToField
ret


checkTop:
;Lade Zähler der Zeile in Akku
MOV A,R2;
;Wenn Akku gleich 0 muss zeile 7 betrachtet werden
MOV R5,#7;
JZ gotTopRow
;Sonst wird die Aktuelle zeile gesetzt
DEC A;
MOV R5,A;
;gotRow dient dazu, dass falls R2 = 0 R0 = 7 bleibt
gotTopRow:
ACALL calculateNeighbours
ret

checkMid:
;Lade Zähler der Zeile in Akku
MOV A,R2;
MOV R5,A;
ACALL calculateMiddleNeighbours
;DEC R7; ;NUR WENN MITTE GESEETZT
ret

checkBottom:
;Lade Zähler der Zeile in Akku
MOV A,R2;
;Wenn Akku gleich 7 muss zeile 0 betrachtet werden
MOV R5,#0;
CJNE A,#7,getBottomRow
JMP gotBottomrow
;Sonst wird die Aktuelle zeile gesetzt
getBottomRow:
INC A;
MOV R5,A;
;gotRow dient dazu, dass falls R2 = 7 R0 = 0 bleibt
gotBottomRow:
ACALL calculateNeighbours
ret

calculateNeighbours:
MOV A,R5;
MOV R0,A;

MOVX A,@R0;	;Laden der entsprechenden Zeile
MOV R6,A	;Speichern der rotierten Zeile

MOV A,R3		;7-ZeilenNummer den benötigten rechts rotationen entspricht
MOVC A,@A+DPTR
ANL A,R6;
JZ neighbour1NotSet
INC R7;

neighbour1NotSet:
MOV A,R3		;7-ZeilenNummer den benötigten rechts rotationen entspricht
INC A
MOVC A,@A+DPTR
ANL A,R6;
JZ neighbour2NotSet
INC R7;

neighbour2NotSet:
MOV A,R3		;7-ZeilenNummer den benötigten rechts rotationen entspricht
INC A
INC A
MOVC A,@A+DPTR
ANL A,R6;
JZ neighbour3NotSet
INC R7;

neighbour3NotSet:
MOV R6,#0;
ret


calculateMiddleNeighbours:
MOV A,R5;
MOV R0,A;
MOVX A,@R0;	;Laden der entsprechenden Zeile
MOV R6,A	;Speichern der rotierten Zeile
;Berechnen um wie viele Stellen die Zeile nach rechts verschoben werden muss

;MOV R4,A	;Speichern des zählers


;Rotieren der Zeile bis der zähler R4 null ist
;RL A		;einmalig links rotieren da erst nach der rechts rotation auf 0 geprüft wird
;RL A		;einmalig links rotieren da erst nach der rechts rotation auf 0 geprüft wird
;rotateRight2:	;so wird verhindert dass wenn der zähler 0 ist eine rotation stattfindet
;RR A;
;DJNZ R4,rotateRight2

MOV A,R3		;7-ZeilenNummer den benötigten rechts rotationen entspricht
MOVC A,@A+DPTR
ANL A,R6;
JZ neighbour2NotSet2
INC R7;

neighbour2NotSet2:
MOV A,R3		;7-ZeilenNummer den benötigten rechts rotationen entspricht
INC A
INC A
MOVC A,@A+DPTR
ANL A,R6;
JZ neighbour3NotSet2
INC R7;

neighbour3NotSet2:
MOV R6,#0;
ret

copyNewGenerationToField:
MOV R0,#100
MOV R1,#0
MOVX A,@R0
MOVX @R1,A

MOV R0,#101
MOV R1,#1
MOVX A,@R0
MOVX @R1,A

MOV R0,#102
MOV R1,#2
MOVX A,@R0
MOVX @R1,A

MOV R0,#103
MOV R1,#3
MOVX A,@R0
MOVX @R1,A

MOV R0,#104
MOV R1,#4
MOVX A,@R0
MOVX @R1,A

MOV R0,#105
MOV R1,#5
MOVX A,@R0
MOVX @R1,A

MOV R0,#106
MOV R1,#6
MOVX A,@R0
MOVX @R1,A

MOV R0,#107
MOV R1,#7
MOVX A,@R0
MOVX @R1,A

ret

display:
mov 42,A

mov R0,#0h
movx A,@R0
mov P3, #00000001b
mov P2, a
mov P2,#0

inc R0
movx A,@R0
mov P3, #00000010b
mov P2, a
mov P2,#0

inc R0
movx A,@R0
mov P3, #00000100b
mov P2, a
mov P2,#0

inc R0
movx A,@R0
mov P3, #00001000b
mov P2, a
mov P2,#0

inc R0
movx A,@R0
mov P3, #00010000b
mov P2, a
mov P2,#0

inc R0
movx A,@R0
mov P3, #00100000b
mov P2, a
mov P2,#0

inc R0
movx A,@R0
mov P3, #01000000b
mov P2, a
mov P2,#0

inc R0
movx A,@R0
mov P3, #10000000b
mov P2, a
mov P2,#0

mov A,42

ret


table: db 10000000b, 01000000b, 00100000b, 00010000b, 00001000b, 00000100b, 00000010b, 00000001b
table2: db 00000001b, 10000000b, 01000000b, 00100000b, 00010000b, 00001000b, 00000100b, 00000010b, 00000001b, 10000000b

end