extends RefCounted
class_name States

class IDLE extends IState:
	func join() -> String:
		return "IDLE"

class WALK extends IState:
	pass
