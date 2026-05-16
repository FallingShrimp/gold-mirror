extends CharacterBase
class_name PlayerBase

func _ready():
	super._ready()
	animationTree.animation_finished.connect(
		func(_n):
			if fsm.currentState is States.ATTACK:
				attackCounter = 0
				fsm.changeState(States.IDLE)
	)
	fsm.joinState.connect(print)
