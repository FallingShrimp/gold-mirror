extends Node
class_name WorldManager

static var instance: WorldManager
static var sceneTree: SceneTree
static var runnedTime: float = 0.0
static var playerInstance: PlayerBase = null

func _ready():
	instance = self
	sceneTree = get_tree()
func _physics_process(delta):
	runnedTime += delta

static func getCurrentTime() -> float:
	return runnedTime * 1000.0
