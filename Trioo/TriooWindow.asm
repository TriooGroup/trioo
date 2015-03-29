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

SCREEN_X = 1120
SCREEN_Y = 640
PLANK_X1 = 24
PLANK_X2 = 392
PLANK_X3 = 760
PLANK_Y = 496

hBuffer dd ?
hBackground dd ?
hPlank dd ?
hYellowDot dd ?
hRedDot dd ?
hBlueDot dd ?
hGreenDot dd ?

BufferFilePath BYTE "pic\buffer.bmp", 0
BackgroundFilePath BYTE "pic\trio_bg_with_pause_button.bmp", 0
NormalPlankFilePath BYTE "pic\trio_key_white.bmp", 0
YellowDotFilePath BYTE "pic\yellow_dot_combine.bmp", 0
RedDotFilePath BYTE "pic\red_dot_combine.bmp", 0
BlueDotFilePath BYTE "pic\blue_dot_combine.bmp", 0
GreenDotFilePath BYTE "pic\green_dot_combine.bmp", 0

TempScore BYTE "2304", 0

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

	INVOKE InitImage

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
	ret
InitImage ENDP

WndProc PROC, lhwnd:DWORD, localMsg:DWORD, wParam:DWORD, lParam:DWORD
LOCAL	ps:PAINTSTRUCT, pt:POINT	
SAVE:
	.IF localMsg == WM_CREATE
		jmp WndProcExit
	.ELSEIF localMsg == WM_TIMER
		INVOKE InvalidateRect, hWnd, NULL, TRUE
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
	invoke DrawPlank
	invoke DrawBalls
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
	invoke SelectObject, hMemDC, hPlank
	invoke BitBlt, hDC, PLANK_X1, PLANK_Y, SCREEN_X, SCREEN_Y, \
			hMemDC, 0, 0, SRCCOPY
	ret
DrawPlank ENDP

DrawScore PROC
LOCAL bgColor:DWORD
LOCAL textColor:DWORD
	;invoke SetTextColor, hDC, 010000h
	;invoke TextOut, hDC, 20,30,OFFSET TempScore,4
	ret
DrawScore ENDP

DrawBalls PROC
	invoke DrawOneBall, 10, 100, 1
	invoke DrawOneBall, 160, 447, 2
	invoke DrawOneBall, 400, 80, 3
	invoke DrawOneBall, 800, 300, 4
	ret
DrawBalls ENDP

DrawOneBall PROC, pos_x:DWORD, pos_y:DWORD, color:DWORD
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
END