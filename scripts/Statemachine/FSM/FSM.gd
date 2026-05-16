extends RefCounted
class_name FSM

var entity: EntityBase = null
var currentState: IState = States.IDLE.new(null)
var firstUpdated: bool = false

func changeState(newStateClass: GDScript, arguments: Array = []):
	var newState = newStateClass.new(entity, arguments)
	if newState is IState:
		if newState == currentState: return
		currentState.exit()
		firstUpdated = false
		newState.join()
		entity.animationPlayback.travel(newState.animationNodeName)
	else:
		push_error("无效状态类", newStateClass, newState)
