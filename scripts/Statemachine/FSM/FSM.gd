extends RefCounted
class_name FiniteStateMachine

signal joinState(newState: IState, oldState: IState, animationName: String)
signal updateState(state: IState)
signal exitState(state: IState)

var character: CharacterBase = null
var currentState: IState = null
var firstUpdated: bool = false

func changeState(newStateClass: GDScript, arguments: Array = []) -> bool:
	var newState = newStateClass.new(self , character, arguments)
	if newState is IState:
		if currentState is IState:
			if newState.stateIs() == currentState.stateIs() && ArrayUtil.same(arguments, currentState.arguments): return false
			currentState.exit()
			exitState.emit(currentState)
		var animationName = newState.join()
		NodeUtil.skeletonMakeRest(character.skeleton)
		character.animator.play(animationName)
		joinState.emit(newState, currentState, animationName)
		currentState = newState
		firstUpdated = false
		return true
	else:
		push_error("无效状态类", newStateClass, newState)
		return false
func update(delta: float):
	if currentState is IState:
		currentState.update(delta)
		updateState.emit(currentState)
		if !firstUpdated:
			currentState.firstUpdate(delta)
			firstUpdated = true

func stateIs():
	return currentState.stateIs()

func _init(charactex: CharacterBase):
	character = charactex
	changeState(States.IDLE)
