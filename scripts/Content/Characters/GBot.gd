extends PlayerBase

func ai(_delta: float):
	if velocity.y > 0:
		fsm.changeState(States.FALLING)
	else:
		if Input.is_action_just_pressed("attack"):
			if fsm.stateIs() in [States.IDLE, States.WALK, States.ATTACK]:
				if fsm.changeState(States.ATTACK, [attackCounter % 2 + 1]):
					attackCounter += 1
		elif Input.is_action_just_pressed("jump"):
			if fsm.stateIs() in [States.IDLE, States.WALK] && is_on_floor():
				fsm.changeState(States.JUMP, [1])
		elif Input.is_action_just_pressed("dash"):
			if fsm.stateIs() in [States.IDLE, States.WALK]:
				fsm.changeState(States.DASH, [direction])
		elif Input.is_action_pressed("moving"):
			if fsm.stateIs() in [States.IDLE, States.WALK] && is_on_floor():
				fsm.changeState(States.WALK, [Input.get_axis("move_left", "move_right")])
		else:
			if fsm.stateIs() in [States.WALK]:
				fsm.changeState(States.IDLE)
