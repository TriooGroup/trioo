TITLE GlobalVars
.386
.model flat, STDCALL
option casemap :none

INCLUDE windows.inc
INCLUDE user32.inc
INCLUDE kernel32.inc
INCLUDE gdi32.inc
INCLUDE masm32.inc
INCLUDE winmm.inc
public windowName, className, MainWin, msg, hInstance, rect, TotalRect, hwnd, hFinalDC, BimpBackground
.data
windowName	BYTE "LineRunner"
className 	BYTE "Runner", 0
MainWin		WNDCLASS <>
msg		MSG  <>
hInstance	DWORD ?
rect	RECT	<>

; ´°ÌåÉè±¸¾ä±ú
TotalRect	DWORD ?
hwnd		DWORD ?
hFinalDC		dd ?

BimpBackground	dd ?

END