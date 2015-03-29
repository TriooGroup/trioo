; TriooGame.inc

option casemap :none
MAX_NUM EQU 30
OPENING EQU 0
LIVE EQU 1
DEAD EQU 2
PAUSED EQU 3
RED EQU 1
YELLOW EQU 2
GREEN EQU 3
BLUE EQU 4

Ball STRUCT
	positionX SDWORD ?
	positionY SDWORD ?
	velocityX SDWORD ?
	velocityY SDWORD ?
	color DWORD ?
	existed DWORD ?
Ball ENDS

Game STRUCT
	ball Ball MAX_NUM DUP(<>)
	plankPosition DWORD ?
	score DWORD ?
	state DWORD ?
	bestScore DWORD ?
	isActivited DWORD ?
	gravity DWORD ?
Game ENDS

startGame PROTO
step PROTO 