extends RefCounted
class_name CooldownController

signal cold()
signal hot()

@export var cooldown: float = 0

var canColdByEventLoop: bool = true
var lastStart: float = 0

func _init(cooldowx: float):
	cooldown = cooldowx
	lastStart = WorldManager.getCurrentTime()

func eventLoop():
	if canStart() && canColdByEventLoop:
		cold.emit()
		canColdByEventLoop = false
	elif !canStart() && !canColdByEventLoop:
		hot.emit()
		canColdByEventLoop = true
func start():
	var state = canStart()
	if state:
		lastStart = WorldManager.getCurrentTime()
	return state
func timePassedSinceLastFlag() -> float:
	return WorldManager.getCurrentTime() - lastStart
func canStart():
	return timePassedSinceLastFlag() >= cooldown
func makeCooldowned():
	lastStart = 0
