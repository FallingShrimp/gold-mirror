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

static func findClosetEntity(to: Vector2, validator: Callable = func(_e: EntityBase): return true) -> EntityBase:
	var result = null
	var lastDistance = INF
	for entity in sceneTree.get_nodes_in_group("entity"):
		if entity is EntityBase:
			var currentDistance = entity.position.distance_to(to)
			if currentDistance < lastDistance && validator.call(entity):
				result = entity
				lastDistance = currentDistance
	return result
