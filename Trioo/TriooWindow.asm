TITLE TriooWindow.asm
.386
.model flat, STDCALL
option casemap: none
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib
INCLUDELIB gdi32.lib
;INCLUDELIB masm32.lib

INCLUDE TriooWindow.inc
INCLUDE windows.inc
INCLUDE user32.inc
INCLUDE kernel32.inc
INCLUDE gdi32.inc
INCLUDE masm32.inc
INCLUDE sound.inc

INCLUDE TriooGame.inc
.data
WindowName BYTE "TriooName"
className BYTE "Trioo", 0
MainWin WNDCLASS <>
msg MSG <>
hInstance DWORD ?
rect RECT <>
hitpoint POINT <>
TotalRect DWORD ?

hFinalDC dd ?
hDC dd ?
hMemDC dd ?
hFont dd ?

hBuffer dd ?
hBackground dd ?
hPlank dd ?
hYellowDot dd ?
hRedDot dd ?
hBlueDot dd ?
hGreenDot dd ?
hDotShadow dd ?
hPlankShadow dd ?
hPlankRed dd ?
hPlankYellow dd ?
hPlankBlue dd ?
hPlankGreen dd ?
hHalo1 dd ?
hHalo1Medium dd ?
hHalo1Small dd ?
hHalo2 dd ?
hHalo2Medium dd ?
hHalo2Small dd ?
hHalo2Rotated dd ?
hHalo2RotatedMedium dd ?
hHalo2RotatedSmall dd ?
hPauseCover dd ?
hButtonMusic dd ?
hButtonSound dd ?
hButtonReplay dd ?
hButtonHome dd ?
hButtonPlay dd ?
hIcon dd ?
hExtraPlank dd ?
hExtraPlankFallDown dd ?
hWhite dd ?
hBlackPlank dd ?
hHeart dd ?

BufferFilePath BYTE "pic\buffer.bmp", 0
BackgroundFilePath BYTE "pic\trio_bg_with_pause_button.bmp", 0
NormalPlankFilePath BYTE "pic\trio_key_white.bmp", 0
YellowDotFilePath BYTE "pic\yellow_dot_combine.bmp", 0
RedDotFilePath BYTE "pic\red_dot_combine.bmp", 0
BlueDotFilePath BYTE "pic\blue_dot_combine.bmp", 0
GreenDotFilePath BYTE "pic\green_dot_combine.bmp", 0
DotShadowFilePath BYTE "pic\dot_shadow_new.bmp", 0
PlankShadowFilePath BYTE "pic\key_shadow.bmp", 0
PlankRedFilePath BYTE "pic\trio_plank_red.bmp", 0
PlankYellowFilePath BYTE "pic\trio_plank_yellow.bmp", 0
PlankBlueFilePath BYTE "pic\trio_plank_blue.bmp", 0
PlankGreenFilePath BYTE "pic\trio_plank_green.bmp", 0
Halo1FilePath BYTE "pic\halo_01.bmp", 0
Halo1MediumFilePath BYTE "pic\halo_01_medium.bmp", 0
Halo1SmallFilePath BYTE "pic\halo_01_small.bmp", 0
Halo2FilePath BYTE "pic\halo_02.bmp", 0
Halo2MediumFilePath BYTE "pic\halo_02_medium.bmp", 0
Halo2SmallFilePath BYTE "pic\halo_02_small.bmp", 0
Halo2RotatedFilePath BYTE "pic\halo_022.bmp", 0
Halo2RotatedMediumFilePath BYTE "pic\halo_022_medium.bmp", 0
Halo2RotatedSmallFilePath BYTE "pic\halo_022_small.bmp", 0
PauseCoverFilePath BYTE "pic\pause_cover2.bmp", 0
ButtonMusicFilePath BYTE "pic\trio_button_music.bmp", 0
ButtonSoundFilePath BYTE "pic\trio_button_sound.bmp", 0
ButtonReplayFilePath BYTE "pic\trio_button_replay.bmp", 0
ButtonHomeFilePath BYTE "pic\trio_button_home.bmp", 0
ButtonPlayFilePath BYTE "pic\trio_button_play.bmp", 0
IconFilePath BYTE "pic\Icon.bmp", 0
bgImgDeadCongratPath BYTE "pic\bgImgDeadCongrat.bmp", 0
bgImgDeadCongratLightPath BYTE "pic\bgImgDeadCongratLight.bmp", 0
ExtraPlankFilePath BYTE "pic\plank_extra.bmp", 0
ExtraPlankFallDownFilePath BYTE "pic\plank_fall_down.bmp", 0
HeartFilePath BYTE "pic\heart_combine.bmp", 0

strBuffer BYTE 20 DUP (0)
fontStr BYTE "Lucida Sans Unicode", 0
scoreStr BYTE "Score", 0
spaceStr BYTE "(space)", 0

bgImgPath	BYTE "pic\bgImg.bmp", 0
bgImgDeadPath BYTE "pic\bgImgDead.bmp", 0
bgImgHelpPath BYTE "pic\help.bmp", 0

IDI_ICON1 equ 101

PAUSE_POSITION0 equ 210
PAUSE_STEP equ 150
btnPauseMusic_X equ PAUSE_POSITION0
btnPauseSound_X equ PAUSE_POSITION0+PAUSE_STEP
btnPauseReplay_X equ PAUSE_POSITION0+2*PAUSE_STEP
btnPauseHome_X equ PAUSE_POSITION0+3*PAUSE_STEP
btnPausePlay_X equ PAUSE_POSITION0+4*PAUSE_STEP
btnPause_Y equ 267
btnPause_Width equ 84
btnPause_Height equ 87


btnEndlessPath BYTE "pic\btnEndless.bmp", 0
btnEndless_X equ 600
btnEndless_Y equ 350
btnEndless_Width equ 124
btnEndless_Height equ 124
btnEndless_pressed BYTE 0

btnHelpPath BYTE "pic\btnHelp.bmp", 0
btnHelp_X equ 400
btnHelp_Y equ 350
btnHelp_Width equ 124
btnHelp_Height equ 124
btnHelp_pressed BYTE 0

btnHomePath BYTE "pic\home.bmp", 0
btnHome_X equ 20
btnHome_Y equ 20
btnHome_Width equ 124
btnHome_Height equ 124
btnHome_pressed BYTE 0

btnReplayPath BYTE "pic\btnReplay.bmp", 0
btnReplay_X equ 380
btnReplay_Y equ 280
btnReplay_Width equ 122
btnReplay_Height equ 117
btnReplay_pressed BYTE 0

btnPressedOffset_X equ 5
btnPressedOffset_Y equ 5

score_X equ 550
score_Y equ 280
deadScore_Height equ 60
best_X equ 550
best_Y equ 350
best_Height equ 50
bestScore_X equ 650
bestScore_Y equ 350

deadScreenCounter DWORD 0
deadBgNum DWORD 0

hBitmap_bg dd ?
hBitmap_btn_endless dd ?
hBitmap_btn_help dd ?
hBitmap_bg_dead dd ?
hBitmap_bg_dead_congrat dd ?
hBitmap_bg_dead_congrat_light dd ?
hBitmap_btn_replay dd ?
hBitmap_help dd ?
hBitmap_btn_home dd ?

bestStr BYTE "Best", 0

extern game: Game
extern gamesound: GameSound

.code
InitInstance PROC
	INVOKE GetModuleHandle, NULL
	mov hInstance, eax
	mov MainWin.hInstance, eax

	invoke	LoadIcon,hInstance,IDI_ICON1
	;INVOKE LoadCursor, NULL, IDC_ARROW

	mov MainWin.hIcon, eax
	INVOKE LoadCursor, NULL, IDC_ARROW
	mov MainWin.hCursor, eax

	mov MainWin.style, 0
	mov MainWin.lpfnWndProc, WndProc
	mov MainWin.cbClsExtra, 0
	mov MainWin.cbWndExtra, 0
	INVOKE GetStockObject,WHITE_BRUSH
	mov MainWin.hbrBackground, eax
	mov MainWin.lpszMenuName, NULL
	mov MainWin.lpszClassName, OFFSET className	

	INVOKE RegisterClass, ADDR MainWin
	.IF eax == 0
		;call ErrorHandler
		jmp Exit_Program
	.ENDIF	


	INVOKE CreateWindowEx, 0, ADDR className, ADDR WindowName,WS_OVERLAPPED + WS_CAPTION +WS_SYSMENU + WS_MINIMIZEBOX, CW_USEDEFAULT, CW_USEDEFAULT, \
		SCREEN_X, SCREEN_Y, NULL, NULL, hInstance, NULL
	.IF eax == 0
		;call ErrorHandler
		jmp Exit_Program
	.ELSE
		mov hWnd, eax;
	.ENDIF	
	
	INVOKE GetDC, hWnd
	mov hFinalDC, eax
	INVOKE CreateCompatibleDC, hFinalDC
	mov hDC, eax
	INVOKE CreateCompatibleDC, hDC
	mov hMemDC, eax

	invoke InitImage
	invoke startGame

	INVOKE SetTimer, hWnd, 1, 50, NULL

	INVOKE ShowWindow, hWnd, SW_SHOW
	INVOKE UpdateWindow, hWnd
	ret
Exit_Program:
	INVOKE ExitProcess, 0
InitInstance ENDP

InitImage PROC
	invoke LoadImage, NULL, ADDR BufferFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBuffer, eax
	invoke LoadImage, NULL, ADDR BufferFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hWhite, eax
	invoke LoadImage, NULL, ADDR BackgroundFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBackground, eax
	invoke LoadImage, NULL, ADDR YellowDotFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hYellowDot, eax
	invoke LoadImage, NULL, ADDR RedDotFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hRedDot, eax
	invoke LoadImage, NULL, ADDR BlueDotFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBlueDot, eax
	invoke LoadImage, NULL, ADDR GreenDotFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hGreenDot, eax
	invoke LoadImage, NULL, ADDR NormalPlankFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hPlank, eax
	invoke LoadImage, NULL, ADDR DotShadowFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hDotShadow, eax
	invoke LoadImage, NULL, ADDR PlankShadowFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hPlankShadow, eax
	invoke LoadImage, NULL, ADDR PlankRedFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hPlankRed, eax
	invoke LoadImage, NULL, ADDR PlankYellowFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hPlankYellow, eax
	invoke LoadImage, NULL, ADDR PlankBlueFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hPlankBlue, eax
	invoke LoadImage, NULL, ADDR PlankGreenFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hPlankGreen, eax
	invoke LoadImage, NULL, ADDR Halo1FilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo1, eax
	invoke LoadImage, NULL, ADDR Halo1MediumFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo1Medium, eax
	invoke LoadImage, NULL, ADDR Halo1SmallFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo1Small, eax
	invoke LoadImage, NULL, ADDR Halo2FilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo2, eax
	invoke LoadImage, NULL, ADDR Halo2MediumFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo2Medium, eax
	invoke LoadImage, NULL, ADDR Halo2SmallFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo2Small, eax
	invoke LoadImage, NULL, ADDR Halo2RotatedFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo2Rotated, eax
	invoke LoadImage, NULL, ADDR Halo2RotatedMediumFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo2RotatedMedium, eax
	invoke LoadImage, NULL, ADDR Halo2RotatedSmallFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHalo2RotatedSmall, eax
	invoke LoadImage, NULL, ADDR PauseCoverFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hPauseCover, eax
	invoke LoadImage, NULL, ADDR ButtonSoundFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hButtonSound, eax
	invoke LoadImage, NULL, ADDR ButtonMusicFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hButtonMusic, eax
	invoke LoadImage, NULL, ADDR ButtonReplayFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hButtonReplay, eax
	invoke LoadImage, NULL, ADDR ButtonHomeFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hButtonHome, eax
	invoke LoadImage, NULL, ADDR ButtonPlayFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hButtonPlay, eax
	invoke LoadImage, NULL, ADDR ExtraPlankFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hExtraPlank, eax
	invoke LoadImage, NULL, ADDR ExtraPlankFallDownFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hExtraPlankFallDown, eax
	invoke LoadImage, NULL, ADDR HeartFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hHeart, eax

	INVOKE LoadImage, NULL, ADDR bgImgPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_bg, eax
	INVOKE LoadImage, NULL, ADDR btnEndlessPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_btn_endless, eax
	INVOKE LoadImage, NULL, ADDR bgImgDeadPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_bg_dead, eax
	INVOKE LoadImage, NULL, ADDR bgImgDeadCongratPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_bg_dead_congrat, eax
	INVOKE LoadImage, NULL, ADDR bgImgDeadCongratLightPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_bg_dead_congrat_light, eax
	INVOKE LoadImage, NULL, ADDR btnReplayPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_btn_replay, eax
	INVOKE LoadImage, NULL, ADDR bgImgHelpPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_help, eax
	INVOKE LoadImage, NULL, ADDR btnHelpPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_btn_help, eax
	INVOKE LoadImage, NULL, ADDR btnHomePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov hBitmap_btn_home, eax

	ret
InitImage ENDP


WndProc PROC, lhwnd:DWORD, localMsg:DWORD, wParam:DWORD, lParam:DWORD
LOCAL	ps:PAINTSTRUCT, pt:POINT	
SAVE:
	.IF localMsg == WM_CREATE
		invoke jmpToOpening
		jmp WndProcExit
	.ELSEIF localMsg == WM_TIMER
		.IF game.state == DEAD
			invoke stepDead
			invoke InvalidateRect, hWnd, NULL, FALSE
		.ELSEIF game.state == LIVE
			invoke step
			.IF game.state == DEAD
				invoke playcrash
				invoke closeMusic
				mov eax, game.score
				.IF eax >= game.bestScore && eax != 0
					invoke playbest
				.ENDIF
			.ENDIF 
			invoke InvalidateRect, hWnd, NULL, FALSE		
		.ENDIF
		jmp WndProcExit
	.ELSEIF localMsg == WM_PAINT

		INVOKE BeginPaint, lhwnd, ADDR ps
		mov hFinalDC, eax
		invoke SelectObject, hDC, hBuffer

		.IF game.state == LIVE
			invoke DrawPlayingScreen
		.ELSEIF game.state == PAUSED
			invoke DrawPauseScreen
		.ELSEIF game.state == OPENING
			invoke drawOpeningScreen
		.ELSEIF game.state == HELP
			invoke drawHelpScreen
		.ELSE
			invoke drawDeadScreen, game.score, game.bestScore
		.ENDIF

		invoke BitBlt, hFinalDC, 0, 0, SCREEN_X, SCREEN_Y,\
				hDC, 0, 0, SRCCOPY
		INVOKE EndPaint, lhwnd, ADDR ps
		jmp WndProcExit
	.ELSEIF localMsg == WM_KEYDOWN
		.IF wParam == VK_SPACE
			.IF game.state == LIVE
				mov game.state, PAUSED
				invoke InvalidateRect, hWnd, NULL, FALSE
			.ELSEIF game.state == PAUSED
				mov game.state, LIVE
			.ENDIF
			ret
		.ENDIF
		.IF game.state == LIVE
			.IF wParam == VK_J
				invoke movePlank, 1
				ret
			.ELSEIF wParam == VK_K
				invoke movePlank, 2
				ret
			.ELSEIF wParam == VK_L
				invoke movePlank, 3
				ret
			.ELSE
				jmp default
			.ENDIF
		.ELSE
			jmp default
		.ENDIF
		jmp WndProcExit
	.ELSEIF localMsg == WM_KEYUP	
		jmp WndProcExit
	.ELSEIF localMsg == WM_LBUTTONDOWN 
		mov eax,lParam 
        and eax,0FFFFh 
        mov hitpoint.x,eax 
        mov eax,lParam 
        shr eax,16 
        mov hitpoint.y,eax 
        .IF game.state == OPENING
			invoke mouseDownOpening, hitpoint
		.ELSEIF game.state == DEAD 
			invoke mouseDownDead, hitpoint
		.ELSEIF game.state == PAUSED
			invoke mouseDownPause, hitpoint
		.ELSE
		.ENDIF
	.ELSEIF localMsg == WM_LBUTTONUP
		.IF game.state == OPENING
			invoke mouseUpOpening
		.ELSEIF game.state == HELP
			invoke mouseUpHelp
		.ELSEIF game.state == DEAD
			invoke mouseUpDead
		.ELSE
		.ENDIF
	.ELSEIF localMsg == WM_DESTROY
		INVOKE ExitProcess, 0
		jmp WndProcExit
	.ELSE
default:
		INVOKE DefWindowProc, lhwnd, localMsg, wParam, lParam
	.ENDIF
	
WndProcExit:
	ret
WndProc ENDP	

jmpToOpening PROC
	mov game.state, OPENING
	invoke playBGM_01
	ret
jmpToOpening ENDP

jmpToLive PROC
	mov game.state, LIVE
	invoke startGame
	invoke playBGM_02
	ret
jmpToLive ENDP

DrawPlayingScreen PROC
	invoke DrawBackground
	invoke DrawHalo, game.plankPosition, game.activeCountdown
	invoke DrawHalo, game.extraPosition, game.extraActiveCountdown
	invoke DrawExtraPlank
	invoke DrawBalls, game.deadIndex
	invoke DrawPlank
	invoke DrawScore
	invoke DrawLives, game.lives
	ret
DrawPlayingScreen ENDP

DrawPauseScreen PROC
	invoke DrawPlayingScreen
	invoke SelectObject, hMemDC, hPauseCover
	invoke BitBlt, hDC, 0, 0, SCREEN_X, SCREEN_Y, hMemDC, 0, 0, SRCAND

	invoke SelectObject, hMemDC, hButtonMusic
	invoke BitBlt, hDC, PAUSE_POSITION0, 267, 84, 87, hMemDC, 0, 0, SRCPAINT
	.if gamesound.playMusic == 0
		invoke SelectObject, hMemDC, hPauseCover
		invoke BitBlt, hDC, PAUSE_POSITION0, 267, 84, 87, hMemDC, 0, 0, SRCAND
	.endif

	invoke SelectObject, hMemDC, hButtonSound
	invoke BitBlt, hDC, PAUSE_POSITION0+PAUSE_STEP, 267, 84, 87, hMemDC, 0, 0, SRCPAINT
	.if gamesound.playSound == 0
		invoke SelectObject, hMemDC, hPauseCover
		invoke BitBlt, hDC, PAUSE_POSITION0+PAUSE_STEP, 267, 84, 87, hMemDC, 0, 0, SRCAND
	.endif

	invoke SelectObject, hMemDC, hButtonReplay
	invoke BitBlt, hDC, PAUSE_POSITION0+PAUSE_STEP*2, 267, 84, 87, hMemDC, 0, 0, SRCPAINT
	invoke SelectObject, hMemDC, hButtonHome
	invoke BitBlt, hDC, PAUSE_POSITION0+PAUSE_STEP*3, 267, 84, 87, hMemDC, 0, 0, SRCPAINT
	invoke SelectObject, hMemDC, hButtonPlay
	invoke BitBlt, hDC, PAUSE_POSITION0+PAUSE_STEP*4, 267, 84, 87, hMemDC, 0, 0, SRCPAINT
	ret
DrawPauseScreen ENDP

DrawFinalScreen PROC,dead_index:DWORD
	invoke DrawBackground
	invoke DrawHalo, game.plankPosition, game.activeCountdown
	invoke DrawHalo, game.extraPosition, game.extraActiveCountdown
	invoke DrawExtraPlank
	invoke DrawBalls, game.deadIndex
	invoke DrawPlank
	invoke DrawScore
	invoke DrawLives, game.lives
	ret
DrawFinalScreen ENDP

DrawBackground PROC
	invoke SelectObject, hMemDC, hBackground
	invoke BitBlt, hDC, 0, 0, SCREEN_X, SCREEN_Y, \
			hMemDC, 0, 0, SRCCOPY
	ret
DrawBackground ENDP

DrawHeart PROC, pos_x:DWORD, pos_y:DWORD
	invoke SelectObject, hMemDC, hHeart
	invoke BitBlt, hDC, pos_x, pos_y, 54, 45, hMemDC, 54, 0, SRCAND
	invoke BitBlt, hDC, pos_x, pos_y, 54, 45, hMemDC, 0, 0, SRCPAINT
	ret
DrawHeart ENDP

DrawLives PROC, lives:DWORD
	invoke DrawHeart, 20, 20
	invoke SetBkMode, hDC, TRANSPARENT 

	invoke CreateFont,35,0,0,0,FW_EXTRALIGHT,FALSE,FALSE,FALSE,DEFAULT_CHARSET,OUT_OUTLINE_PRECIS,\
                CLIP_DEFAULT_PRECIS,CLEARTYPE_QUALITY, VARIABLE_PITCH,addr fontStr
	mov hFont, eax
	invoke SelectObject, hDC, hFont

	invoke IntToStr, game.lives
	invoke SetTextColor, hDC, 0ffffffh
	invoke StringLen, ADDR strBuffer
	invoke TextOut, hDC, 80, 20, ADDR strBuffer, eax

	ret
DrawLives ENDP

DrawPlank PROC
LOCAL positionX:DWORD
LOCAL floatingY:DWORD
LOCAL tempHandle:DWORD
	.IF game.activeCountdown > 0
		.IF game.isActivated == RED
			invoke SelectObject, hMemDC, hPlankRed
		.ELSEIF game.isActivated == YELLOW
			invoke SelectObject, hMemDC, hPlankYellow
		.ELSEIF game.isActivated == BLUE
			invoke SelectObject, hMemDC, hPlankBlue
		.ELSEIF game.isActivated == GREEN
			invoke SelectObject, hMemDC, hPlankGreen
		.ENDIF
	.ELSE
		invoke SelectObject, hMemDC, hPlank
	.ENDIF

	.IF game.activeCountdown == MAX_COUNTDOWN || game.extraActiveCountdown == MAX_COUNTDOWN
		invoke playhit
	.ENDIF

	.IF game.plankPosition == 1
		mov positionX, PLANK_X1
	.ELSEIF game.plankPosition == 2
		mov positionX, PLANK_X2
	.ELSE
		mov positionX, PLANK_X3
	.ENDIF
	invoke BitBlt, hDC, positionX, PLANK_Y, PLANK_WIDTH, PLANK_HEIGHT, \
		hMemDC, 0, 0, SRCCOPY

	invoke SelectObject, hMemDC, hPlankShadow
	invoke BitBlt, hDC, positionX, PLANK_Y + 16, 160, 160, \
		hMemDC, 0, 0, SRCAND

	ret
DrawPlank ENDP

DrawExtraPlank PROC USES eax ebx ecx edx
LOCAL positionX:DWORD
	.IF game.extraPlankState == 0;no extra plank
		ret
	.ELSEIF game.extraPlankState == 1;falling down
		.IF game.extraPosition == 1
			mov positionX, PLANK_X1
		.ELSEIF game.extraPosition == 2
			mov positionX, PLANK_X2
		.ELSE
			mov positionX, PLANK_X3
		.ENDIF

		invoke SelectObject, hMemDC, hExtraPlankFallDown
		invoke BitBlt, hDC, positionX, game.extraPlankHeight, 320, 16, hMemDC, 0, 0, SRCPAINT
	.ELSEIF game.extraPlankState == 2 ;valid
		.IF game.extraPosition == 1
			mov positionX, PLANK_X1
		.ELSEIF game.extraPosition == 2
			mov positionX, PLANK_X2
		.ELSE
			mov positionX, PLANK_X3
		.ENDIF

		.IF game.extraPlankCountdown < EXTRA_PLANK_ALERT_TIME ;blink
			mov eax, 0
			mov edx, 0
			mov eax, game.extraPlankCountdown
			mov ecx, 10
			div ecx
			.IF edx < 5 ;show
				invoke SelectObject, hMemDC, hExtraPlank
				invoke BitBlt, hDC, positionX, PLANK_Y, 320, 16, hMemDC, 0, 0, SRCPAINT
			.ENDIF
		.ELSE ;countdown
			invoke SelectObject, hMemDC, hExtraPlank
			invoke BitBlt, hDC, positionX, PLANK_Y, 320, 16, hMemDC, 0, 0, SRCPAINT

			;countdown bar
			mov eax, game.extraPlankCountdown
			sub eax, EXTRA_PLANK_ALERT_TIME
			imul eax, 310
			mov edx, 0
			mov ecx, EXTRA_PLANK_TIME
			sub ecx, EXTRA_PLANK_ALERT_TIME
			div ecx
			push eax
			invoke SelectObject, hMemDC, hWhite
			pop eax
			mov ebx, positionX
			add ebx, 5
			mov edx, PLANK_Y
			add edx, 5
			invoke BitBlt, hDC, ebx, edx, eax, 6, hMemDC, 0, 0, SRCCOPY
		.ENDIF
	.ENDIF
	ret
DrawExtraPlank ENDP

DrawHalo PROC USES eax ebx edx, plankPosition:DWORD, activeCountdown:DWORD
LOCAL positionX:DWORD
LOCAL floatingY:DWORD
LOCAL tempHandle:DWORD
	.IF plankPosition == 1
		mov positionX, PLANK_X1
	.ELSEIF plankPosition == 2
		mov positionX, PLANK_X2
	.ELSE
		mov positionX, PLANK_X3
	.ENDIF

	.IF activeCountdown > 0
	;calculate current floating distance
		mov ebx, 4
		sub ebx, activeCountdown
		imul ebx, FLOATING_DISTANCE
		mov floatingY, ebx

		;lower circles
		mov edx, positionX
		mov ebx, PLANK_Y - 30
		sub ebx, floatingY
		invoke DrawCircle, edx, ebx, 18, hHalo1
		add edx, 140
		mov ebx, PLANK_Y - 60
		sub ebx, floatingY
		invoke DrawCircle, edx, ebx, 18, hHalo1
		add edx, 160
		mov ebx, PLANK_Y - 40
		sub ebx, floatingY
		invoke DrawCircle, edx, ebx, 18, hHalo1

		;middle circles
		mov edx, positionX
		add edx, 250
		mov ebx, PLANK_Y - 90
		sub ebx, floatingY
		invoke DrawCircle, edx, ebx, 16, hHalo1Medium

		;upper circles
		mov edx, positionX
		add edx, 60
		mov ebx, PLANK_Y - 165
		sub ebx, floatingY
		invoke DrawCircle, edx, ebx, 14, hHalo1Small
		add edx, 70
		mov ebx, PLANK_Y - 130
		sub ebx, floatingY
		invoke DrawCircle, edx, ebx, 14, hHalo1Small
		add edx, 165
		mov ebx, PLANK_Y - 155
		sub ebx, floatingY
		invoke DrawCircle, edx, ebx, 14, hHalo1Small

		;lower crosses
		.IF activeCountdown == 2 || activeCountdown == 4
			mov eax, hHalo2
		.ELSE
			mov eax, hHalo2Rotated
		.ENDIF
		mov tempHandle, eax
		mov edx, positionX
		add edx, 85
		mov ebx, PLANK_Y - 25
		sub ebx, floatingY	
		invoke DrawCross, edx, ebx, 16, tempHandle 
		add edx, 150
		mov ebx, PLANK_Y - 45
		sub ebx, floatingY
		invoke DrawCross, edx, ebx, 16, tempHandle 

		;middle crosses
		.IF activeCountdown == 2 || activeCountdown == 4
			mov eax, hHalo2Medium
		.ELSE
			mov eax, hHalo2RotatedMedium
		.ENDIF
		mov tempHandle, eax
		mov edx, positionX
		add edx, 60
		mov ebx, PLANK_Y - 100
		sub ebx, floatingY
		invoke DrawCross, edx, ebx, 14, tempHandle

		;upper crosses
		.IF activeCountdown == 2 || activeCountdown == 4
			mov eax, hHalo2Small
		.ELSE
			mov eax, hHalo2RotatedSmall
		.ENDIF
		mov tempHandle, eax
		mov edx, positionX
		add edx, 10
		mov ebx, PLANK_Y - 160
		sub ebx, floatingY
		invoke DrawCross, edx, ebx, 12, tempHandle
		add edx, 180
		mov ebx, PLANK_Y - 153
		sub ebx, floatingY
		invoke DrawCross, edx, ebx, 12, tempHandle
		add edx, 70
		mov ebx, PLANK_Y - 135
		sub ebx, floatingY
		invoke DrawCross, edx, ebx, 12, tempHandle
	.ENDIF

	ret
DrawHalo ENDP

DrawCircle PROC USES edx ebx, pos_x:DWORD, pos_y:DWORD, side_length:DWORD, handle:DWORD
	invoke SelectObject, hMemDC, handle
	invoke BitBlt, hDC, pos_x, pos_y, side_length, side_length, hMemDC, 0, 0, SRCPAINT
	ret
DrawCircle ENDP

DrawCross PROC USES edx, pos_x:DWORD, pos_y:DWORD, side_length:DWORD, handle:DWORD
	invoke SelectObject, hMemDC, handle
	invoke BitBlt, hDC, pos_x, pos_y, side_length, side_length, hMemDC, 0, 0, SRCPAINT
	ret
DrawCross ENDP


DrawScore PROC
LOCAL bgColor:DWORD
LOCAL textColor:DWORD
	invoke SetBkMode, hDC, TRANSPARENT 

	score_Height = 35
	invoke CreateFont,score_Height,0,0,0,FW_EXTRALIGHT,FALSE,FALSE,FALSE,DEFAULT_CHARSET,OUT_OUTLINE_PRECIS,\
                CLIP_DEFAULT_PRECIS,CLEARTYPE_QUALITY, VARIABLE_PITCH,addr fontStr
	mov hFont, eax
	invoke SelectObject, hDC, hFont

	invoke IntToStr, game.score
	invoke SetTextColor, hDC, 0ffffffh
	invoke StringLen, ADDR strBuffer
	invoke TextOut, hDC, 590, 20, ADDR strBuffer, eax
	invoke StringLen, ADDR scoreStr
	invoke TextOut, hDC, 500, 20, ADDR scoreStr, eax

	invoke SetBkMode, hDC, TRANSPARENT 

	space_Height = 20
	invoke CreateFont,space_Height,0,0,0,FW_EXTRALIGHT,FALSE,FALSE,FALSE,DEFAULT_CHARSET,OUT_OUTLINE_PRECIS,\
                CLIP_DEFAULT_PRECIS,CLEARTYPE_QUALITY, VARIABLE_PITCH,addr fontStr
	mov hFont, eax
	invoke SelectObject, hDC, hFont

	invoke StringLen, ADDR spaceStr
	invoke TextOut, hDC, 1030, 63, ADDR spaceStr, eax

	ret
DrawScore ENDP

DrawBalls PROC USES edx esi ecx, dead_index:SDWORD
	mov edx, TYPE Ball
	mov esi, 0
	mov ecx, MAX_NUM

L1:
	push edx
	push esi
	push ecx
;	.IF is_final_state == 0
;		.IF game.ball[esi].existed == 1
;			invoke DrawOneBall, game.ball[esi].positionX, game.ball[esi].positionY, game.ball[esi].color
;		.ENDIF
;	.ELSE ;final screen
		.IF game.ball[esi].existed == 1
			.IF esi != dead_index
				invoke DrawOneBall, game.ball[esi].positionX, game.ball[esi].positionY, game.ball[esi].color
			.ELSE
				mov eax, 0
				mov edx, 0
				mov eax, game.deadCountdown
				mov ecx, 10
				div ecx
				.IF edx < 5 ;show
					invoke DrawOneBall, game.ball[esi].positionX, game.ball[esi].positionY, game.ball[esi].color
				.ENDIF
			.ENDIF
		.ENDIF
;	.ENDIF
	pop ecx
	pop esi
	pop edx
	add esi, edx
	dec ecx
	cmp ecx, 0
	jg L1

	ret
DrawBalls ENDP

DrawOneBall PROC, pos_x:DWORD, pos_y:DWORD, color:DWORD
LOCAL shadow_pos_x:DWORD
LOCAL shadow_pos_y:DWORD
	mov eax, pos_x
	inc eax
	mov shadow_pos_x, eax
	mov eax, pos_y
	inc eax
	mov shadow_pos_y, eax
	invoke SelectObject, hMemDC, hDotShadow
	INVOKE BitBlt,hDC,shadow_pos_x,shadow_pos_y,132,132,hMemDC,0,0,SRCAND

	.IF color == RED
	invoke SelectObject, hMemDC, hRedDot 
	.ELSEIF color == YELLOW
	invoke SelectObject, hMemDC, hYellowDot 
	.ELSEIF color == BLUE
	invoke SelectObject, hMemDC, hBlueDot 
	.ELSEIF color == GREEN
	invoke SelectObject, hMemDC, hGreenDot 	
	.ENDIF

	INVOKE BitBlt,hDC,pos_x,pos_y,49,49,hMemDC,49,0,SRCAND
	INVOKE BitBlt,hDC,pos_x,pos_y,49,49,hMemDC,0,0,SRCPAINT

	ret
DrawOneBall ENDP

KeyDownProc PROC, localMsg: DWORD, wParam: DWORD, lParam: DWORD
	.IF wParam == VK_J
		invoke movePlank, 1
		ret
	.ELSEIF wParam == VK_K
		invoke movePlank, 2
		ret
	.ELSEIF wParam == VK_L
		invoke movePlank, 3
		ret
	.ENDIF
KeyDownProc ENDP


drawImg PROC USES eax,
	hBitmap:DWORD, x:DWORD, y:DWORD,
	w:DWORD, h:DWORD

	invoke SelectObject, hMemDC, hBitmap
	invoke BitBlt, hDC, x, y, w, h, \
			hMemDC, 0, 0, SRCCOPY 
	ret
drawImg ENDP

drawOpeningBtns PROC
	.if btnEndless_pressed == 0
		invoke drawImg, hBitmap_btn_endless, btnEndless_X, btnEndless_Y, \
			btnEndless_Width, btnEndless_Height
	.else
		invoke drawImg, hBitmap_btn_endless, \
			btnEndless_X+btnPressedOffset_X, btnEndless_Y+btnPressedOffset_Y, \
			btnEndless_Width, btnEndless_Height
	.endif

	.if btnHelp_pressed == 0
		invoke drawImg, hBitmap_btn_help, btnHelp_X, btnHelp_Y, \
			btnHelp_Width, btnHelp_Height
	.else
		invoke drawImg, hBitmap_btn_help, \
			btnHelp_X+btnPressedOffset_X, btnHelp_Y+btnPressedOffset_Y, \
			btnHelp_Width, btnHelp_Height
	.endif
	ret
drawOpeningBtns ENDP

drawDeadBtns PROC
	.if btnReplay_pressed == 0
		invoke drawImg, hBitmap_btn_replay, btnReplay_X, btnReplay_Y, \
			btnReplay_Width, btnReplay_Height
	.else
		invoke drawImg, hBitmap_btn_replay, \
			btnReplay_X+btnPressedOffset_X, btnReplay_Y+btnPressedOffset_Y, \
			btnReplay_Width, btnReplay_Height
	.endif

	.if btnHome_pressed == 0
		invoke drawImg, hBitmap_btn_home, btnHome_X, btnHome_Y, \
			btnHome_Width, btnHome_Height
	.else
		invoke drawImg, hBitmap_btn_home, \
			btnHome_X+btnPressedOffset_X, btnHome_Y+btnPressedOffset_Y, \
			btnHome_Width, btnHome_Height
	.endif
	ret
drawDeadBtns ENDP

mouseDownPause PROC USES eax,
	p:POINT

	.if p.x >= btnPauseMusic_X && p.x <= btnPauseMusic_X + btnPause_Width &&\
		p.y >= btnPause_Y && p.y <= btnPause_Y + btnPause_Height
		.if gamesound.playMusic == 1
			INVOKE closeMusic
			mov gamesound.playMusic, 0
		.else
			mov gamesound.playMusic, 1
			INVOKE playBGM_02
		.endif
		INVOKE InvalidateRect, NULL, NULL, FALSE
	.endif

	.if p.x >= btnPauseSound_X && p.x <= btnPauseSound_X + btnPause_Width &&\
		p.y >= btnPause_Y && p.y <= btnPause_Y + btnPause_Height
		.if gamesound.playSound == 1
			mov gamesound.playSound, 0
		.else
			mov gamesound.playSound, 1
		.endif
		INVOKE InvalidateRect, NULL, NULL, FALSE
	.endif

	.if p.x >= btnPauseReplay_X && p.x <= btnPauseReplay_X + btnPause_Width &&\
		p.y >= btnPause_Y && p.y <= btnPause_Y + btnPause_Height
		invoke jmpToLive
	.endif

	.if p.x >= btnPauseHome_X && p.x <= btnPauseHome_X + btnPause_Width &&\
		p.y >= btnPause_Y && p.y <= btnPause_Y + btnPause_Height
		invoke jmpToOpening
		INVOKE InvalidateRect, NULL, NULL, FALSE
	.endif

	.if p.x >= btnPausePlay_X && p.x <= btnPausePlay_X + btnPause_Width &&\
		p.y >= btnPause_Y && p.y <= btnPause_Y + btnPause_Height
		
		mov game.state, LIVE
	.endif
	ret
mouseDownPause ENDP

mouseDownOpening PROC USES eax,
	p:POINT

	.if p.x >= btnEndless_X && p.x <= btnEndless_X + btnEndless_Width &&\
		p.y >= btnEndless_Y && p.y <= btnEndless_Y + btnEndless_Height
		INVOKE InvalidateRect, NULL, NULL, FALSE
		mov al, 1
		mov btnEndless_pressed, al
	.endif

	.if p.x >= btnHelp_X && p.x <= btnHelp_X + btnHelp_Width &&\
		p.y >= btnHelp_Y && p.y <= btnHelp_Y + btnHelp_Height
		INVOKE InvalidateRect, NULL, NULL, FALSE
		mov al, 1
		mov btnHelp_pressed, al
	.endif

	ret
mouseDownOpening ENDP

mouseDownDead PROC USES eax,
	p:POINT

	.if p.x >= btnReplay_X && p.x <= btnReplay_X + btnReplay_Width &&\
		p.y >= btnReplay_Y && p.y <= btnReplay_Y + btnReplay_Height
		INVOKE InvalidateRect, NULL, NULL, FALSE
		mov al, 1
		mov btnReplay_pressed, al
	.endif

	.if p.x >= btnHome_X && p.x <= btnHome_X + btnHome_Width &&\
		p.y >= btnHome_Y && p.y <= btnHome_Y + btnHome_Height
		INVOKE InvalidateRect, NULL, NULL, FALSE
		mov al, 1
		mov btnHome_pressed, al
	.endif

	ret
mouseDownDead ENDP

mouseUpOpening PROC USES eax
	mov al, btnEndless_pressed
	.if al != 0		
		mov al, 0
		mov btnEndless_pressed, al

		invoke jmpToLive
		INVOKE InvalidateRect, NULL, NULL, FALSE
	.endif
	mov al, btnHelp_pressed
	.if al != 0
		mov al, 0
		mov btnHelp_pressed, al
		mov eax, HELP
		mov game.state, eax
		INVOKE InvalidateRect, NULL, NULL, FALSE
	.endif

	ret
mouseUpOpening ENDP

mouseUpHelp PROC
	mov eax, OPENING
	mov game.state, eax
	INVOKE InvalidateRect, NULL, NULL, FALSE
	ret 
mouseUpHelp ENDP

mouseUpDead PROC USES eax

	mov al, btnReplay_pressed
	.if al != 0
		INVOKE jmpToLive		
		mov al, 0
		mov btnReplay_pressed, al
		INVOKE InvalidateRect, NULL, NULL, FALSE
	.endif

	mov al, btnHome_pressed
	.if al != 0
		INVOKE jmpToOpening		
		mov al, 0
		mov btnHome_pressed, al
		INVOKE InvalidateRect, NULL, NULL, FALSE
	.endif

	ret
mouseUpDead ENDP

drawOpeningScreen PROC USES eax
	invoke drawImg, hBitmap_bg, 0, 0, SCREEN_X, SCREEN_Y
	invoke drawOpeningBtns

	ret
drawOpeningScreen ENDP

drawHelpScreen PROC USES eax
	invoke drawImg, hBitmap_help, 0, 0, SCREEN_X, SCREEN_Y
	ret
drawHelpScreen ENDP

drawDeadScreen PROC USES eax,
	score: DWORD,
	bestScore:DWORD

	mov eax, game.score
	.if eax >= game.bestScore && eax != 0
		mov eax, deadBgNum
		.if eax == 0
			invoke drawImg, hBitmap_bg_dead_congrat, 0, 0, SCREEN_X, SCREEN_Y
		.else
			invoke drawImg, hBitmap_bg_dead_congrat_light, 0, 0, SCREEN_X, SCREEN_Y
		.endif
		
		
	.else
		invoke drawImg, hBitmap_bg_dead, 0, 0, SCREEN_X, SCREEN_Y
	.endif

	invoke drawDeadBtns

	invoke SetBkMode, hDC, TRANSPARENT

	invoke CreateFont,deadScore_Height,0,0,0,FW_DONTCARE,FALSE,FALSE,FALSE,DEFAULT_CHARSET,OUT_OUTLINE_PRECIS,\
                CLIP_DEFAULT_PRECIS,CLEARTYPE_QUALITY, VARIABLE_PITCH,addr fontStr
	mov hFont, eax
	invoke SelectObject, hDC, hFont

	invoke IntToStr, score
	invoke SetTextColor, hDC, 0050bdf0h
	invoke StringLen, ADDR strBuffer
	invoke TextOut, hDC, score_X, score_Y, ADDR strBuffer, eax

	invoke CreateFont,best_Height,0,0,0,FW_DONTCARE,FALSE,FALSE,FALSE,DEFAULT_CHARSET,OUT_OUTLINE_PRECIS,\
                CLIP_DEFAULT_PRECIS,CLEARTYPE_QUALITY, VARIABLE_PITCH,addr fontStr
	mov hFont, eax
	invoke SelectObject, hDC, hFont
	invoke SetTextColor, hDC, 004c48eeh
	invoke StringLen, ADDR bestStr
	invoke TextOut, hDC, best_X, best_Y, ADDR bestStr, eax

	invoke IntToStr, bestScore
	invoke StringLen, ADDR strBuffer
	invoke TextOut, hDC, bestScore_X, bestScore_Y, ADDR strBuffer, eax

	ret
drawDeadScreen ENDP

stepDead PROC USES eax
	inc deadScreenCounter
	.IF deadScreenCounter == 1
		mov eax, 1
		mov deadBgNum, eax
	.ELSEIF deadScreenCounter == 3
		mov eax, 0
		mov deadBgNum, eax
		mov deadScreenCounter, eax
	.ELSE
	.ENDIF
	ret
stepDead ENDP

IntToStr PROC USES eax ebx ecx edx,
	val:DWORD
	mov eax, val
	mov bl, 0
	.REPEAT
		mov dl, 10
		div dl
		movzx dx, ah
		push dx
		mov ah, 0
		inc bl
	.UNTIL al==0
	movzx ecx, bl
	mov edi, offset strBuffer
L1:
	pop ax
	add al, '0'
	mov [edi], al
	inc edi
	LOOP L1
	mov al, 0
	mov [edi], al
	ret
IntToStr ENDP

StringLen PROC USES edi,
	pString: PTR BYTE
	mov edi, pString
	mov eax, 0

L1:
	cmp byte ptr [edi], 0
	je L2
	inc edi
	inc eax
	jmp L1
L2:
	ret
StringLen ENDP

END