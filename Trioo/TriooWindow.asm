TITLE TriooWindow.asm
.386
.model flat, STDCALL
option casemap: none
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib
INCLUDELIB gdi32.lib
;INCLUDELIB masm32.lib
INCLUDELIB winmm.lib
INCLUDE TriooWindow.inc
INCLUDE windows.inc
INCLUDE user32.inc
INCLUDE kernel32.inc
INCLUDE gdi32.inc
INCLUDE masm32.inc
INCLUDE winmm.inc

INCLUDE TriooGame.inc
.data
WindowName BYTE "TriooName"
className BYTE "Trioo", 0
MainWin WNDCLASS <>
msg MSG <>
hInstance DWORD ?
rect RECT <>
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

strBuffer BYTE 20 DUP (0)
fontStr BYTE "Lucida Sans Unicode", 0

extern game: Game

.code
InitInstance PROC
	INVOKE GetModuleHandle, NULL
	mov hInstance, eax
	mov MainWin.hInstance, eax
	INVOKE LoadIcon, NULL, IDI_APPLICATION
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
	;注册窗口类
	INVOKE RegisterClass, ADDR MainWin
	.IF eax == 0
		;call ErrorHandler
		jmp Exit_Program
	.ENDIF	

	;创建应用程序主窗口
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
	invoke InitData

	;设置时钟
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

	ret
InitImage ENDP

InitData PROC
;TEST 初始化游戏数据
	invoke startGame
	mov game.plankPosition, 1
	mov game.score, 123
	mov game.state, OPENING
	mov game.bestScore, 0
	mov game.isActivated, YELLOW
	mov game.activeCountdown, 4
	ret
InitData ENDP

WndProc PROC, lhwnd:DWORD, localMsg:DWORD, wParam:DWORD, lParam:DWORD
LOCAL	ps:PAINTSTRUCT, pt:POINT	
SAVE:
	.IF localMsg == WM_CREATE
		jmp WndProcExit
	.ELSEIF localMsg == WM_TIMER
		;invoke step
		INVOKE InvalidateRect, hWnd, NULL, FALSE
		jmp WndProcExit
	.ELSEIF localMsg == WM_PAINT
		INVOKE BeginPaint, lhwnd, ADDR ps
		mov hFinalDC, eax
		invoke SelectObject, hDC, hBuffer
		invoke DrawPlayingScreen
		invoke BitBlt, hFinalDC, 0, 0, SCREEN_X, SCREEN_Y,\
				hDC, 0, 0, SRCCOPY
		INVOKE EndPaint, lhwnd, ADDR ps
		jmp WndProcExit
	.ELSEIF localMsg == WM_KEYDOWN
		invoke KeyDownProc, localMsg, wParam, lParam
		jmp WndProcExit
	.ELSEIF localMsg == WM_KEYUP	
		jmp WndProcExit
	.ELSEIF localMsg == WM_DESTROY
		INVOKE ExitProcess, 0
		jmp WndProcExit
	.ELSE
		INVOKE DefWindowProc, lhwnd, localMsg, wParam, lParam
	.ENDIF
	
WndProcExit:
	ret
WndProc ENDP	

DrawPlayingScreen PROC
	invoke DrawBackground
	invoke DrawBalls
	invoke DrawPlank
	invoke DrawScore
	ret
DrawPlayingScreen ENDP

DrawBackground PROC
	invoke SelectObject, hMemDC, hBackground
	invoke BitBlt, hDC, 0, 0, SCREEN_X, SCREEN_Y, \
			hMemDC, 0, 0, SRCCOPY
	ret
DrawBackground ENDP

DrawPlank PROC
LOCAL positionX:DWORD
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

	;Halo
	.IF game.activeCountdown > 0
		;下层圈
		mov edx, positionX
		invoke DrawCircle, edx, PLANK_Y - 30, 18, hHalo1
		add edx, 140
		invoke DrawCircle, edx, PLANK_Y - 60, 18, hHalo1
		add edx, 160
		invoke DrawCircle, edx, PLANK_Y - 40, 18, hHalo1

		;下层叉
		mov edx, positionX
		add edx, 85
		invoke DrawCross, edx, PLANK_Y-25, 16, hHalo2 
		add edx, 150
		invoke DrawCross, edx, PLANK_Y-45, 16, hHalo2 

		;中层圈
		mov edx, positionX
		add edx, 250
		invoke DrawCircle, edx, PLANK_Y-90, 16, hHalo1Medium

		;中层叉
		mov edx, positionX
		add edx, 60
		invoke DrawCross, edx, PLANK_Y-100, 14, hHalo2Medium

		;上层圈
		mov edx, positionX
		add edx, 60
		invoke DrawCross, edx, PLANK_Y-165, 14, hHalo1Small
		add edx, 70
		invoke DrawCross, edx, PLANK_Y-130, 14, hHalo1Small
		add edx, 165
		invoke DrawCross, edx, PLANK_Y-155, 14, hHalo1Small

		;上层叉
		mov edx, positionX
		add edx, 10
		invoke DrawCross, edx, PLANK_Y-160, 12, hHalo2Small
		add edx, 180
		invoke DrawCross, edx, PLANK_Y-153, 12, hHalo2Small
		add edx, 70
		invoke DrawCross, edx, PLANK_Y-135, 12, hHalo2Small

	.ENDIF

	ret
DrawPlank ENDP

DrawCircle PROC USES edx, pos_x:DWORD, pos_y:DWORD, side_length:DWORD, handle:DWORD
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
	invoke SetBkMode, hDC, TRANSPARENT ;设置背景透明
	;调整字体
	score_Height = 35
	invoke CreateFont,score_Height,0,0,0,FW_EXTRALIGHT,FALSE,FALSE,FALSE,DEFAULT_CHARSET,OUT_OUTLINE_PRECIS,\
                CLIP_DEFAULT_PRECIS,CLEARTYPE_QUALITY, VARIABLE_PITCH,addr fontStr
	mov hFont, eax
	invoke SelectObject, hDC, hFont
	;转成字符串
	invoke IntToStr, game.score
	invoke SetTextColor, hDC, 0ffffffh
	invoke StringLen, ADDR strBuffer
	invoke TextOut, hDC, 20, 20, ADDR strBuffer, eax
	ret
DrawScore ENDP

DrawBalls PROC
	mov edx, TYPE Ball
	mov esi, 0
	mov ecx, MAX_NUM

L1:
	push edx
	push esi
	push ecx
	.IF game.ball[esi].existed == 1
		invoke DrawOneBall, game.ball[esi].positionX, game.ball[esi].positionY, game.ball[esi].color
	.ENDIF
	pop ecx
	pop esi
	pop edx
	add esi, edx
	loop L1

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
	.IF wParam == VK_LEFT
		invoke movePlank, 1
		ret
	.ELSEIF wParam == VK_DOWN
		invoke movePlank, 2
		ret
	.ELSEIF wParam == VK_RIGHT
		invoke movePlank, 3
		ret
	.ENDIF
KeyDownProc ENDP

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