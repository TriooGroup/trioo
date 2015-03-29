TITLE TriooGame.asm
.386
.model flat, STDCALL

INCLUDE TriooGame.inc

PUBLIC game
.data
	PARA_A = 1
	PARA_B = 2
	PARA_C = 3
	PARA_P = 7
	
	game Game <>
	score DWORD ?
	randomSeed DWORD ?

.code
startGame PROC
	mov game.plankPosition, 0
	mov game.score, 0
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

srand PROC, seed: DWORD
	ret
srand ENDP

rand PROC USES edx
	ret
rand ENDP

generateBall PROC USES edi esi
	ret
generateBall ENDP
END