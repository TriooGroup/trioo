TITLE Trioo Main

.386
.model flat, STDCALL
option casemap :none
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib
INCLUDELIB gdi32.lib
;INCLUDELIB masm32.lib
INCLUDELIB winmm.lib
INCLUDE windows.inc
INCLUDE user32.inc
INCLUDE kernel32.inc
INCLUDE gdi32.inc
INCLUDE masm32.inc
INCLUDE winmm.inc
INCLUDE GlobalVars.inc

.data
.code
WinMain PROC
	INVOKE GetModuleHandle, NULL
	mov hInstance, eax
	mov MainWin.hInstance, eax
	
	;加载程序的光标和图标
	INVOKE LoadIcon, NULL, IDI_APPLICATION
	mov MainWin.hIcon, eax
	INVOKE LoadCursor, NULL, IDC_ARROW
	mov MainWin.hCursor, eax
	
	;设置窗口属性
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
		call ErrorHandler
		jmp Exit_Program
	.ENDIF	
	;创建应用程序主窗口

	
	INVOKE CreateWindowEx, 0, ADDR className, ADDR windowName,WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 1000,
				630, NULL, NULL, hInstance, NULL
	.IF eax == 0
		call ErrorHandler
		jmp Exit_Program
	.ELSE
		mov hwnd, eax;
	.ENDIF	
	
	INVOKE ShowWindow, hwnd, SW_SHOW
	INVOKE UpdateWindow, hwnd

Message_Loop:
	INVOKE GetMessage, ADDR msg, NULL, NULL, NULL
	.IF eax == 0
		jmp Exit_Program
	.ENDIF

	INVOKE DispatchMessage, ADDR msg
	jmp Message_Loop

Exit_Program:
	INVOKE ExitProcess, 0
WinMain ENDP

;消息处理函数
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

;错误处理函数
ErrorHandler PROC
	ret
ErrorHandler endp

END WinMain