INCLUDELIB winmm.lib

include windows.inc 
include user32.inc 
include kernel32.inc 

INCLUDE winmm.inc

.code
FOR param ,<BGM_01, BGM_02, boom, crash, failure, hit, heart, best>
	play&param PROTO
ENDM

closeMusic PROTO
closeSound PROTO

GameSound STRUCT
	playMusic DWORD 1
	playSound DWORD 1
GameSound ENDS