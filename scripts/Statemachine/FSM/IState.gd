extends RefCounted
class_name IState

var enterTime: float = 0
var fsm: FiniteStateMachine = null
var character: CharacterBase = null
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

func stateIs():
	return get_script()
func timePassed():
	return WorldManager.getCurrentTime() - enterTime

func _init(fsmx: FiniteStateMachine, charactex: CharacterBase, argumentx: Array = []):
	register()
	enterTime = WorldManager.getCurrentTime()
	fsm = fsmx
	character = charactex
	arguments = argumentx
