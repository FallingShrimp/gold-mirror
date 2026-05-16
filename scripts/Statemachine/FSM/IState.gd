extends RefCounted
class_name IState

var entity: EntityBase = null
var arguments: Array = []

func register() -> void:
	pass
func canChangeTo() -> bool:
	return true
func join() -> String:
	return "AnimationName"
func firstUpdate(_delta: float) -> void:
	pass
func update(_delta: float) -> void:
	pass
func exit() -> void:
	pass

func _init(entitx: EntityBase, argumentx: Array = []):
	register()
	entity = entitx
	arguments = argumentx
