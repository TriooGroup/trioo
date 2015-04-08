TITLE TriooGame.asm

INCLUDE Irvine32.inc
INCLUDE TriooGame.inc

PUBLIC game
generateBall PROTO
moveOneBall PROTO, index:DWORD

SpeedType STRUCT
	velocityX SDWORD ?
	velocityY0 SDWORD ?
	velocityYMax SDWORD ?
	accelerate SDWORD ?
SpeedType ENDS
.data	
	diameter EQU 47
	game Game <>
	vXArray SDWORD 5 DUP(6), 8, 10, 12, 14
	vYArray SDWORD 5 DUP(-6), -4, 3, 8, 13
	PARA_NUM = 2
	speedTypes SpeedType {6, -3, 30, 1}, {7, 2, 26, 1}
.code
startGame PROC
	mov game.plankPosition, 1
	mov game.score, 0
	mov game.state, OPENING
	mov game.bestScore, 0
	mov game.isActivated, YELLOW
	mov game.activeCountdown, 0

	mov game.gravity, 1
	call Randomize
	mov ecx, MAX_NUM
	mov edi, 0
L1:
	mov game.ball[edi].existed, 0
	add edi, TYPE Ball
	loop L1
startGame ENDP

step PROC USES edi
	mov eax, 100
	call RandomRange
	cmp eax, 1
	jg L2
	invoke generateBall
L2:
	.IF game.activeCountdown > 0
		sub game.activeCountdown, 1
		.IF game.activeCountdown == 0
			mov game.isActivated, 0
		.ENDIF
	.ENDIF
	mov edi, 0
	mov ecx, MAX_NUM
L3:
	invoke moveOneBall, edi
	add edi, 1
	loop L3
	ret
step ENDP

generateBall PROC USES edi ecx ebx
	mov ecx, MAX_NUM
	mov edi, 0
L1:
	.IF game.ball[edi].existed == 1
		jmp L2
	.ENDIF
	mov game.ball[edi].positionX, -DIMETER
	mov game.ball[edi].positionY, 0
	mov eax, PARA_NUM
	call RandomRange
	mov game.ball[edi].speedType, eax
	mov ebx, eax
	mov eax, TYPE SpeedType
	mul ebx
	mov ebx, speedTypes[eax].velocityX
	mov game.ball[edi].velocityX, ebx
	mov ebx, speedTypes[eax].velocityY0
	mov game.ball[edi].velocityY, ebx
	mov game.ball[edi].color, RED
	mov game.ball[edi].existed, 1
	ret
L2:
	add edi, TYPE Ball
	loop L1
	ret
generateBall ENDP

moveOneBall PROC USES eax ebx edi edx, index: DWORD
	mov eax, TYPE Ball
	mul index
	mov edi, eax
	.IF game.ball[edi].existed == 1
		mov ebx, game.ball[edi].speedType
		mov eax, TYPE SpeedType
		mul ebx
		mov edx, eax
		mov eax, speedTypes[edx].accelerate
		add game.ball[edi].velocityY, eax
		mov eax, game.ball[edi].velocityX
		add game.ball[edi].positionX, eax
		mov eax, game.ball[edi].velocityY
		add game.ball[edi].positionY, eax
		.IF game.ball[edi].positionY > PLANK_Y - DIMETER
			mov ebx, game.ball[edi].positionX
			.IF (ebx > PLANK_X1 - RADIUS) && (ebx < PLANK_X2 - RADIUS) && (game.plankPosition != 1)
				ret
			.ELSEIF (ebx > PLANK_X2 - RADIUS) && (ebx < PLANK_X3 - RADIUS) && (game.plankPosition != 2)
				ret
			.ELSEIF (ebx > PLANK_X3 - RADIUS) && (game.plankPosition != 3)
				ret
			.ELSE
				.IF ((ebx < PLANK_X2) && (game.ball[edi].velocityX > 0) || (ebx > PLANK_X3) && (game.ball[edi].velocityX < 0))
					mov eax, speedTypes[edx].velocityYMax
					mov game.ball[edi].velocityY, 0
					sub game.ball[edi].velocityY, eax
				.ELSE
					neg game.ball[edi].velocityY
				.ENDIF
				mov eax, PLANK_Y - DIMETER
				mov game.ball[edi].positionY, eax
				mov eax, game.ball[edi].color
				mov game.isActivated, eax
				mov game.activeCountdown, 4
			.ENDIF
		.ENDIF
		.IF (game.ball[edi].positionX > SCREEN_X) || (game.ball[edi].positionX < 0 - DIMETER)
			mov game.ball[edi].existed, 0
		.ENDIF
	.ENDIF
	ret
moveOneBall ENDP

movePlank PROC USES eax, position: DWORD
	mov eax, position
	mov game.plankPosition, eax
	ret
movePlank ENDP
END