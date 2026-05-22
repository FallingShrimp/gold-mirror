extends RefCounted
class_name CooldownController

@export var cooldown: float = 0

var lastStart: float = 0

func _init(cooldowx: float):
	cooldown = cooldowx

func start():
	var state = canStart()
	if state:
		lastStart = WorldManager.getCurrentTime()
	return state
func timePassedSinceLastFlag() -> float:
	return WorldManager.getCurrentTime() - lastStart
func canStart():
	return timePassedSinceLastFlag() >= cooldown
