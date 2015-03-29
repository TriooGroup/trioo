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
INCLUDE TriooWindow.inc

.data
msg MSG <>
.code
WinMain PROC
	INVOKE InitInstance

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
END WinMain