; TriooWindow.inc

InitInstance PROTO
InitGame PROTO
InitImage PROTO
InitData PROTO

DrawPlayingScreen PROTO
DrawBackground PROTO
DrawBalls PROTO
DrawOneBall PROTO, pos_x:DWORD, pos_y:DWORD, color:DWORD
DrawPlank PROTO
DrawScore PROTO
IntToStr PROTO, val:DWORD
StringLen PROTO, pString: PTR BYTE

RED EQU 1
YELLOW EQU 2
GREEN EQU 3
BLUE EQU 4

.data?
hWnd DWORD ?

