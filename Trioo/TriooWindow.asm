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

.data
WindowName BYTE "TriooName"
className BYTE "Trioo", 0
MainWin WNDCLASS <>
msg MSG <>
hInstance DWORD ?
rect RECT <>
TotalRect DWORD ?
hWnd DWORD ?
hFinalDC dd ?

BitmapBackground dd ?

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
	
	INVOKE CreateWindowEx, 0, ADDR className, ADDR WindowName,WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 1000,
				630, NULL, NULL, hInstance, NULL
	.IF eax == 0
		;call ErrorHandler
		jmp Exit_Program
	.ELSE
		mov hWnd, eax;
	.ENDIF	
	
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