; TriooWindow.inc
include windows.inc 
include user32.inc 
include kernel32.inc 
include gdi32.inc 

InitInstance PROTO
InitGame PROTO
InitImage PROTO
InitData PROTO

DrawPlayingScreen PROTO
DrawPauseScreen PROTO
DrawBackground PROTO
DrawBalls PROTO
DrawOneBall PROTO, pos_x:DWORD, pos_y:DWORD, color:DWORD
DrawPlank PROTO
DrawHalo PROTO
DrawCircle PROTO, pos_x:DWORD, pos_y:DWORD, side_length:DWORD, handle:DWORD
DrawCross PROTO, pos_x:DWORD, pos_y:DWORD, side_length:DWORD, handle:DWORD
DrawScore PROTO
KeyDownProc PROTO, localMsg: DWORD, wParam: DWORD, lParam: DWORD

jmpToOpening PROTO
jmpToLive PROTO

drawOpeningScreen PROTO
drawDeadScreen PROTO score:DWORD, bestScore:DWORD
drawHelpScreen PROTO
mouseDownOpening PROTO p:POINT
mouseUpOpening PROTO
mouseUpHelp PROTO
mouseDownDead PROTO p:POINT
mouseUpDead PROTO
mouseDownPause PROTO p:POINT

IntToStr PROTO, val:DWORD
StringLen PROTO, pString: PTR BYTE


.data?
hWnd DWORD ?

