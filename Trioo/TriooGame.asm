TITLE TriooGame.asm

INCLUDE Irvine32.inc
INCLUDE TriooGame.inc

PUBLIC game
generateBall PROTO
moveOneBall PROTO, index:DWORD
stepExtraPlank PROTO
stepHeart PROTO

SpeedType STRUCT
	velocityX SDWORD ?
	velocityY0 SDWORD ?
	velocityYMax SDWORD ?
	accelerate SDWORD ?
SpeedType ENDS
.data	
	diameter EQU 47
	game Game <>
	minIntervalArray DWORD 70, 50, 30, 15
	maxIntervalArray DWORD 100, 80, 50, 30
	levelUpScore DWORD 0, 20, 40, 60
	LEVEL_NUM = 4
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
	mov game.extraPlankState, 0
	mov game.extraPosition, 0
	mov game.isExtraActivated, 0
	mov game.deadIndex, -1
	mov game.deadCountdown, 0
	mov game.lives, 1
	call Randomize
	mov ecx, MAX_NUM
	mov edi, 0
L1:
	mov game.ball[edi].existed, 0
	add edi, TYPE Ball
	loop L1
startGame ENDP

step PROC USES edi edx
	.IF game.state != LIVE
		ret
	.ENDIF
	.IF game.deadIndex >= 0
		sub game.deadCountdown, 1
		.IF game.deadCountdown == 0
			mov game.state, DEAD
		.ENDIF
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
	.IF game.extraActiveCountdown > 0
		sub game.extraActiveCountdown, 1
		.IF game.extraActiveCountdown == 0
			mov game.isExtraActivated, 0
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
	invoke stepHeart
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
		.IF game.ball[edi].positionY > PLANK_Y - DIMETER - 20
			mov ebx, game.ball[edi].positionX
			.IF (ebx > PLANK_X1 - RADIUS) && (ebx < PLANK_X2 - RADIUS)
				mov edx, 1
			.ELSEIF	(ebx > PLANK_X2 - RADIUS) && (ebx < PLANK_X3 - RADIUS)
				mov edx, 2
			.ELSE
				mov edx, 3
			.ENDIF
			.IF (edx != game.extraPosition || game.extraPlankState != 2) && (edx != game.plankPosition)
				.IF game.ball[edi].positionY < PLANK_Y + 8 - DIMETER
					ret
				.ENDIF
				;ËÀÍö
				;mov game.state, DEAD
				sub game.lives, 1
				.IF game.lives == 0
					mov game.deadIndex, edi
					mov game.deadCountdown, 44
					mov game.ball[edi].positionY, PLANK_Y + 8 - DIMETER
					mov eax, game.score
					.IF eax > game.bestScore					
						mov game.bestScore, eax
					.ENDIF
					ret
				.ELSE
					mov game.ball[edi].existed, 0
				.ENDIF
			.ELSE
				;·´µ¯Çò
				.IF edx == game.extraPosition
					mov game.isExtraActivated, 1
					mov game.extraActiveCountdown, MAX_COUNTDOWN
				.ELSE
					mov eax, game.ball[edi].color
					mov game.isActivated, eax
					mov game.activeCountdown, MAX_COUNTDOWN
				.ENDIF
				mov ebx, game.ball[edi].speedType
				mov eax, TYPE SpeedType
				mul ebx
				mov edx, eax
				mov eax, speedTypes[edx].velocityYMax
				mov game.ball[edi].velocityY, 0
				sub game.ball[edi].velocityY, eax
				mov eax, PLANK_Y - DIMETER
				mov game.ball[edi].positionY, eax
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
	.IF game.state != LIVE || game.deadIndex != -1 
		ret
	.ENDIF
	mov eax, position
	mov game.plankPosition, eax
	mov game.isActivated, 0
	mov game.activeCountdown, 0
	ret
movePlank ENDP

stepExtraPlank PROC USES eax ebx
	.IF game.extraPlankState == 0
		mov eax, 10000
		call RandomRange
		.IF eax < 20
			mov eax, 3
			call RandomRange
			add eax, 1
			mov game.extraPosition, eax
			mov game.extraPlankHeight, 100
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
			mov eax, game.plankPosition
			.IF game.extraPlankHeight > PLANK_Y
				.IF eax == game.extraPosition
					mov game.extraPlankState, 2
					mov game.extraPlankCountdown, EXTRA_PLANK_TIME
					mov ebx, eax
					mov eax, 2
					call RandomRange
					shl eax, 1
					sub eax, 1
					add ebx, eax
					.IF ebx == 0
						mov ebx, 3
					.ENDIF
					.IF ebx == 4
						mov ebx, 1
					.ENDIF
					mov game.extraPosition, ebx
				.ELSE
					mov game.extraPlankState, 0
					mov game.extraPosition, 0
				.ENDIF
			.ENDIF
		.ENDIF
	.ELSE
		sub game.extraPlankCountdown, 1
		.IF game.extraPlankCountdown == 0
			mov game.extraPosition, 0
			mov game.extraPlankState, 0
		.ENDIF
	.ENDIF
	ret
stepExtraPlank ENDP

stepHeart PROC USES eax ebx
	.IF game.heartPosition == 0
		mov eax, 10000
		call RandomRange
		.IF eax < 10
			mov eax, 3
			call RandomRange
			add eax, 1
			mov game.heartPosition, eax
			mov game.heartHeight, -50
			mov game.heartVelocity, 0
		.ENDIF
	.ELSE
		add game.heartVelocity, 1
		mov eax, game.heartVelocity
		add game.heartHeight, eax
		mov eax, game.plankPosition
		.IF game.heartHeight > PLANK_Y - HEART_HEIGHT
			.IF eax == game.heartPosition
				add game.lives, 1
			.ENDIF
				mov game.heartPosition, 0
		.ENDIF
	.ENDIF
	ret
stepHeart ENDP
END