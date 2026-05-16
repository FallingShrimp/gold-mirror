extends Node
class_name WorldManager

static var runnedTime: float = 0.0

func _physics_process(delta):
	runnedTime += delta

static func getCurrentTime() -> float:
	return runnedTime * 1000.0
