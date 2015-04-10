.386 
option casemap:none 
.model flat,stdcall 
include sound.inc

.data

FOR param ,<BGM_01, BGM_02>
closeCmd&param BYTE "close &param", 0
openCmd&param BYTE "open sound/&param.mp3 alias &param type mpegvideo",0
playCmd&param BYTE "play &param repeat",0
ENDM

FOR param ,<boom, crash, failure, hit, jump>
closeCmd&param BYTE "close &param", 0
openCmd&param BYTE "open sound/&param.mp3 alias &param type mpegvideo",0
playCmd&param BYTE "play &param",0
ENDM

.code
playBGM_01 PROC
	invoke mciSendString,ADDR closeCmdBGM_02, NULL, 0, 0
	invoke mciSendString,ADDR closeCmdBGM_01, NULL, 0, 0	
	invoke mciSendString,ADDR openCmdBGM_01, NULL, 0, 0
	invoke mciSendString,ADDR playCmdBGM_01, NULL, 0, 0
	ret
playBGM_01 ENDP

playBGM_02 PROC
	invoke mciSendString,ADDR closeCmdBGM_02, NULL, 0, 0
	invoke mciSendString,ADDR closeCmdBGM_01, NULL, 0, 0	
	invoke mciSendString,ADDR openCmdBGM_02, NULL, 0, 0
	invoke mciSendString,ADDR playCmdBGM_02, NULL, 0, 0
	ret
playBGM_02 ENDP

FOR param, <boom, crash, failure, hit, jump>
play&param PROC
	invoke mciSendString,ADDR closeCmd&param, NULL, 0, 0	
	invoke mciSendString,ADDR openCmd&param, NULL, 0, 0
	invoke mciSendString,ADDR playCmd&param, NULL, 0, 0
	ret
play&param ENDP
ENDM
END