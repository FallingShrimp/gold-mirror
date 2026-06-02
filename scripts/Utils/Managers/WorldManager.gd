extends Node2D
class_name WorldManager

var saveTimer: CooldownController = CooldownController.new(30000)

static var rootNode: WorldManager
static var sceneTree: SceneTree
static var runnedTime: float = 0.0
static var playerInstance: PlayerBase = null

func _ready():
	rootNode = self
	sceneTree = get_tree()
	GameBusManager.start()
func _physics_process(delta):
	runnedTime += delta
	if saveTimer.start():
		GameSaveManager.overrideSave()

static func getCurrentTime() -> float:
	return runnedTime * 1000.0
