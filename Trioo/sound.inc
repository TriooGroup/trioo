INCLUDELIB winmm.lib

include windows.inc 
include user32.inc 
include kernel32.inc 

INCLUDE winmm.inc

.code
FOR param ,<BGM_01, BGM_02, boom, crash, failure, hit, jump>
	play&param PROTO
ENDM