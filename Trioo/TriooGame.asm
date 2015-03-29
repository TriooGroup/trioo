TITLE TriooGame.asm

INCLUDE Irvine32.inc
INCLUDE TriooGame.inc

PUBLIC game
.data	
	diameter EQU 47
	game Game <>

.code
startGame PROC
	mov game.plankPosition, 0
	mov game.score, 0
	call Randomize
	mov ecx, MAX_NUM
	mov edi, 0
L1:
	mov game.ball.existed[edi], 0
	inc edi
	loop L1
startGame ENDP

step PROC USES edi
	mov edi, 0
L2:
	cmp game.ball.existed[edi], 0
	je L3
L3:
	inc edi
	cmp edi, MAX_NUM
	jb L2
	ret
step ENDP

generateBall PROC USES edi esi
	ret
generateBall ENDP
END