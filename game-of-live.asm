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
call timer
reti
;------------------
;init
;------------------
ORG 20h
init:
mov IE, #10010010b
mov tmod, #00000010b
mov tl0, #0c0h
mov th0, #0c0h
SETB TR0
setb P0.0
MOV R0,#0

MOV A,#11100000b
movx @R0,A

INC R0
MOV A,#10000000b
movx @R0,A

INC R0
MOV A,#01000000b
movx @R0,A

INC R0
MOV A,#00000000b
movx @R0,A

INC R0
MOV A,#00000000b
movx @R0,A

INC R0
MOV A,#00000000b
movx @R0,A

INC R0
MOV A,#00000000b
movx @R0,A

INC R0
MOV A,#00000000b
movx @R0,A

call zeigen
;---------------------------
anfang:
jnb p1.0, starttimer
jnb p1.1, stoptimer
nurRT:
jnb p1.2, RT
jnb tr0, da
ajmp anfang
da:
call display
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
stoptimer:
clr tr0; stop timer
setb P1.1
ajmp anfang

RT:
clr tr0; stop timer
setb P1.2
setb P0.0
ljmp init



;----------------------
; timer
;
timer:
inc r1
cjne r1, #05h, nuranzeige
mov r1, #00h
call new_generation
ret

nuranzeige:
call zeigen
ret

hupe:
clr tr0; stop timer
clr P0.0
ret

new_generation:
MOV R0,#0
MOV R2,#8

checkrow:
movx A,@R0
CPL A
movx @R0,A

INC R0
DEC R2
MOV A,R2
JNZ checkrow

call zeigen
ret

zeigen:
call display
ret

display:

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

ret

end
