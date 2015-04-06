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
KeyDownProc PROTO, localMsg: DWORD, wParam: DWORD, lParam: DWORD


.data?
hWnd DWORD ?

