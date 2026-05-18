extends RefCounted
class_name ThrottleController

@export var cooldown: float = 0

var lastFlag: float = 0

func _init(cooldowx: float):
	cooldown = cooldowx

func flag():
	lastFlag = WorldManager.getCurrentTime()
func timePassedSinceLastFlag() -> float:
	return WorldManager.getCurrentTime() - lastFlag
func canExecute() -> bool:
	return timePassedSinceLastFlag() >= cooldown
