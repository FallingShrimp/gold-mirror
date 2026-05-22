extends Node2D
class_name WorldManager

static var rootNode: WorldManager
static var sceneTree: SceneTree
static var runnedTime: float = 0.0
static var playerInstance: PlayerBase = null

func _ready():
	rootNode = self
	sceneTree = get_tree()
func _physics_process(delta):
	runnedTime += delta

static func getCurrentTime() -> float:
	return runnedTime * 1000.0
