TITLE TriooGame.asm

INCLUDE Irvine32.inc
INCLUDE TriooGame.inc

PUBLIC game
generateBall PROTO
moveOneBall PROTO, index:DWORD
stepExtraPlank PROTO

SpeedType STRUCT
	velocityX SDWORD ?
	velocityY0 SDWORD ?
	velocityYMax SDWORD ?
	accelerate SDWORD ?
SpeedType ENDS
.data	
	diameter EQU 47
	game Game <>
	minIntervalArray DWORD 50, 15, 10
	maxIntervalArray DWORD 100, 50, 15
	levelUpScore DWORD 0, 20, 30
	LEVEL_NUM = 3
	PARA_NUM = 2
	speedTypes SpeedType {7, 0, 27, 1}, {6, -5, 31, 1}
.code
startGame PROC
	mov game.plankPosition, 1
	mov game.score, 0
	;mov game.state, OPENING
	;mov game.bestScore, 0
	mov game.isActivated, YELLOW
	mov game.activeCountdown, 0
	mov game.minInterval, 7
	mov game.gravity, 1
	mov game.minInterval, 50
	mov game.maxInterval, 100
	mov game.nextBall, 10
	mov game.ballNumber, 0
	mov game.currentLevel, 0
	call Randomize
	mov ecx, MAX_NUM
	mov edi, 0
L1:
	mov game.ball[edi].existed, 0
	add edi, TYPE Ball
	loop L1
startGame ENDP

step PROC USES edi
	.IF game.state != LIVE
		ret
	.ENDIF
	mov eax, game.minInterval
	.IF game.nextBall == 0
		invoke generateBall
		mov eax, game.maxInterval
		sub eax, game.minInterval
		call RandomRange
		add eax, game.minInterval
		mov game.nextBall, eax
	.ENDIF
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
	sub game.nextBall, 1
	invoke stepExtraPlank
	ret
step ENDP

generateBall PROC USES edi ecx ebx
	mov ecx, MAX_NUM
	mov edi, 0
L1:
	.IF game.ball[edi].existed == 0
		jmp L2
	.ENDIF
	add edi, TYPE Ball
	loop L1
	ret
L2:
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
	mov eax, 4
	call RandomRange
	add eax, 1
	mov game.ball[edi].color, eax
	mov eax, 2
	call RandomRange
	.IF eax == 1
		neg game.ball[edi].velocityX
		mov game.ball[edi].positionX, SCREEN_X
	.ENDIF
	mov game.ball[edi].existed, 1
	add game.ballNumber, 1
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
			.IF (ebx > PLANK_X1 - RADIUS) && (ebx < PLANK_X2 - RADIUS)
				mov edx, 1
			.ELSEIF	(ebx > PLANK_X2 - RADIUS) && (ebx < PLANK_X3 - RADIUS)
				mov edx, 2
			.ELSE
				mov edx, 3
			.ENDIF
			.IF (edx != game.extraPosition) && (edx != game.plankPosition)
				mov game.state, DEAD
				mov eax, game.score
				.IF eax > game.bestScore					
					mov game.bestScore, eax
				.ENDIF
				ret
			.ELSE
				.IF ((edx == 1) && (game.ball[edi].velocityX > 0) || (edx == 3) && (game.ball[edi].velocityX < 0))
					mov edx, game.ball[edi].speedType
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
				mov game.activeCountdown, MAX_COUNTDOWN
				add game.score, 1
				mov eax, game.currentLevel
				add eax, 1
				mov ebx, levelUpScore[eax * 4]
				.IF eax < 3 && ebx < game.score
					mov game.currentLevel, eax
					mov ebx, minIntervalArray[eax * 4]
					mov game.minInterval, ebx
					mov ebx, maxIntervalArray[eax * 4]
					mov game.maxInterval, ebx
				.ENDIF
			.ENDIF
		.ENDIF
		.IF (game.ball[edi].positionX > SCREEN_X) || (game.ball[edi].positionX < 0 - DIMETER)
			mov game.ball[edi].existed, 0
			sub game.ballNumber, 1
		.ENDIF
	.ENDIF
	ret
moveOneBall ENDP

movePlank PROC USES eax, position: DWORD
	mov eax, position
	mov game.plankPosition, eax
	mov game.isActivated, 0
	mov game.activeCountdown, 0
	ret
movePlank ENDP

stepExtraPlank PROC
	.IF game.extraPlankState == 0
		mov eax, 10000
		call RandomRange
		.IF eax < 100
			mov eax, 3
			call RandomRange
			add eax, 1
			mov game.extraPosition, eax
			mov game.extraPlankHeight, 0
			mov game.extraPlankVelocity, 0
			mov game.extraPlankCountdown, 10
			mov game.extraPlankState, 1
		.ENDIF
	.ELSEIF game.extraPlankState == 1
		.IF game.extraPlankCountdown > 0
			sub game.extraPlankCountdown, 1
		.ELSE
			add game.extraPlankVelocity, 1
			mov eax, game.extraPlankVelocity
			add game.extraPlankHeight, eax
			.IF game.extraPlankHeight > PLANK_Y
				mov game.extraPlankState, 2
				mov game.extraPlankCountdown, EXTRA_PLANK_TIME
			.ENDIF
		.ENDIF
	.ELSE
		sub game.extraPlankCountdown, 1
	.ENDIF
	ret
stepExtraPlank ENDP
END