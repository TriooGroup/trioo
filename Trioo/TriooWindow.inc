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
DrawCircle PROTO, pos_x:DWORD, pos_y:DWORD, side_length:DWORD, handle:DWORD
DrawCross PROTO, pos_x:DWORD, pos_y:DWORD, side_length:DWORD, handle:DWORD
DrawScore PROTO
KeyDownProc PROTO, localMsg: DWORD, wParam: DWORD, lParam: DWORD

IntToStr PROTO, val:DWORD
StringLen PROTO, pString: PTR BYTE


.data?
hWnd DWORD ?

