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
SCREEN_X = 1104
SCREEN_Y = 621
MainWin WNDCLASS <>
msg MSG <>
hInstance DWORD ?
rect RECT <>
TotalRect DWORD ?
hWnd DWORD ?
hFinalDC dd ?
hDC dd ?

BitmapBuffer dd ?
BitmapBackground dd ?
BackgroundFilePath BYTE "bgImg.bmp", 0
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
	
	INVOKE CreateWindowEx, 0, ADDR className, ADDR WindowName,WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, SCREEN_X,
				SCREEN_Y, NULL, NULL, hInstance, NULL
	.IF eax == 0
		;call ErrorHandler
		jmp Exit_Program
	.ELSE
		mov hWnd, eax;
	.ENDIF	
	
	INVOKE GetDC, hWnd
	mov hFinalDC, eax
	INVOKE LoadImage, NULL, ADDR BackgroundFilePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
	mov BitmapBackground, eax
	INVOKE CreateCompatibleDC, hFinalDC
	mov hDC, eax
	INVOKE ShowWindow, hWnd, SW_SHOW
	INVOKE UpdateWindow, hWnd
	ret
Exit_Program:
	INVOKE ExitProcess, 0
InitInstance ENDP

WndProc PROC, lhwnd:DWORD, localMsg:DWORD, wParam:DWORD, lParam:DWORD
LOCAL	ps:PAINTSTRUCT, pt:POINT
		
SAVE:
		.IF localMsg == WM_CREATE
			jmp WndProcExit
		.ELSEIF localMsg == WM_TIMER
			;jmp WndProcExit
		.ELSEIF localMsg == WM_PAINT
			INVOKE BeginPaint, lhwnd, ADDR ps
			mov hFinalDC, eax
			INVOKE SelectObject, hDC, BitmapBackground
			INVOKE BitBlt, hFinalDC, 0, 0, SCREEN_X, SCREEN_Y, hDC, 0, 0, SRCCOPY
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
		.endif

	
WndProcExit:
	ret
WndProc ENDP	

END