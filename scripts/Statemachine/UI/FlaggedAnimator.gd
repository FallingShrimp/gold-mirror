@tool
extends AnimationPlayer
class_name FlaggedAnimator

var states: Dictionary[String, bool] = {}

func setFlag(namx: String, state: bool):
	states[namx] = state
func flag(namx: String):
	states[namx] = true
func unflag(namx: String):
	states[namx] = false
func isFlagged(namx: String) -> bool:
	return states.get(namx, false)
