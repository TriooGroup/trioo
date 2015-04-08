; TriooGame.inc

option casemap :none
MAX_NUM EQU 30
OPENING EQU 0
LIVE EQU 1
DEAD EQU 2
PAUSED EQU 3
HELP EQU 4

Ball STRUCT
	positionX SDWORD ?
	positionY SDWORD ?
	velocityX SDWORD ?
	velocityY SDWORD ?
	speedType SDWORD ?
	color DWORD ?
	existed DWORD ?
Ball ENDS

Game STRUCT
	ball Ball MAX_NUM DUP(<>)
	plankPosition DWORD ?
	score DWORD ?
	state DWORD ?
	bestScore DWORD ?
	isActivated DWORD ?
	activeCountdown DWORD ?
	gravity DWORD ?
Game ENDS

RED EQU 1
YELLOW EQU 2
GREEN EQU 3
BLUE EQU 4

SCREEN_X = 1120
SCREEN_Y = 640
PLANK_X1 = 24
PLANK_X2 = 392
PLANK_X3 = 760
PLANK_Y = 496
PLANK_WIDTH = 320
PLANK_HEIGHT = 16
DIMETER = 47
RADIUS = 24
FLOATING_DISTANCE = 10

startGame PROTO
step PROTO 
movePlank PROTO, position: DWORD