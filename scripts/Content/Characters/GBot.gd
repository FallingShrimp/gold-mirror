extends PlayerBase


func _ready():
	super._ready()
	animationTree.animation_finished.connect(
		func(_n):
			if fsm.currentState is States.ATTACK:
				if !emittedForNextAttack:
					attackCounter = 0
					fsm.changeState(States.IDLE)
	)
	fsm.updateState.connect(
		func(state):
			if state is States.ATTACK && !emittedForNextAttack:
				if Input.is_action_just_pressed("attack") && WorldManager.getCurrentTime() - lastAttackTime > attackTime:
					emittedForNextAttack = true
					await animationTree.animation_finished
					fsm.changeState(States.ATTACK, [attackCounter % 2 + 1])
					attackCounter += 1
	)
	fsm.joinState.connect(
		func(newState, _o, _a):
			print(_a)
			if newState is States.ATTACK:
				emittedForNextAttack = false
	)
func ai(_delta: float):
	if velocity.y > 0 && fsm.stateIs() in [States.IDLE, States.WALK, States.JUMP]:
		fsm.changeState(States.FALLING)
	elif Input.is_action_just_pressed("attack"):
		if fsm.stateIs() in [States.IDLE, States.WALK, States.FALLING]:
			if fsm.changeState(States.ATTACK, [attackCounter % 2 + 1]):
				attackCounter += 1
	elif Input.is_action_just_pressed("dash"):
		if fsm.stateIs() in [States.IDLE, States.WALK, States.JUMP]:
			fsm.changeState(States.DASH, [direction])
	elif Input.is_action_just_pressed("jump"):
		if fsm.stateIs() in [States.IDLE, States.WALK] && is_on_floor():
			fsm.changeState(States.JUMP, [1])
	elif Input.is_action_pressed("moving"):
		if fsm.stateIs() in [States.IDLE, States.WALK] && is_on_floor():
			fsm.changeState(States.WALK, [Input.get_axis("move_left", "move_right")])
	else:
		if fsm.stateIs() in [States.WALK]:
			fsm.changeState(States.IDLE)
