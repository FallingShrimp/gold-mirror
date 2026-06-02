extends Node
class_name ActionManager

signal did(action: PlayerAction)

enum PlayerAction {
	ATTACK,
	PARRY,
	MOVE,
	DASH,
	JUMP,
	MAGIC
}

static var instance: ActionManager = null
static var enables: Array[PlayerAction] = []

func _ready():
	instance = self

static func _static_init() -> void:
	enableAll()
static func emitDid(action: PlayerAction):
	instance.did.emit(action)
static func disable(action: PlayerAction):
	if action in enables:
		enables.erase(action)
static func enable(action: PlayerAction):
	if action not in enables:
		enables.append(action)
static func justEnable(actions: Array[PlayerAction]):
	enables = actions.duplicate()
static func enableAll():
	enables = []
	for action in PlayerAction.values():
		enables.append(action)
static func canI(action: PlayerAction):
	return action in enables
