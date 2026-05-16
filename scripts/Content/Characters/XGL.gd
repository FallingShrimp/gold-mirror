extends PlayerBase

func ai(_delta: float):
	fsm.changeState(States.WALK, [Direction.RIGHT])
