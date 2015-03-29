TITLE TriooGame.asm
.386
.model flat, STDCALL

ball STRUCT
	position_x DWORD ?
	position_y DWORD ? 
	velocity_x DWORD ?
	velocity_y DWORD ?
ball ENDS

.data
	MAX_NUM = 30
	PARA_A = 1
	PARA_B = 2
	PARA_C = 3
	PARA_P = 7
	gravity = 5
	balls ball MAX_NUM DUP (<>)
	existed BYTE MAX_NUM DUP (?)
	currentBalls DWORD ?
	score DWORD ?
	randomSeed DWORD ?
	plankPosition DWORD ?

.code
startGame PROC
	mov plankPosition, 1
	mov currentBalls, 0
	mov score, 0
	mov ecx, MAX_NUM
	mov edi, 0
L1:
	mov existed[edi], 0
	inc edi
	loop L1
startGame ENDP

step PROC USES edi
	mov edi, 0
L2: 
	cmp existed[edi], 0
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