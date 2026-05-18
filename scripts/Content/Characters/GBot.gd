extends PlayerBase

func _ready():
	super._ready()
	animationTree.animation_finished.connect(
		func(_n):
			if fsm.currentState is States.ATTACK:
				if !emittedForNextAttack:
					attackCounter = 0
					fsm.changeState(States.IDLE)
			elif fsm.stateIs() in [States.PARRY_END, States.HURT]:
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
					useStrength(10)
	)
	fsm.joinState.connect(
		func(newState, _o, _a):
			if newState is States.ATTACK:
				emittedForNextAttack = false
	)
func ai(_delta: float):
	if fsm.stateIs() in [States.CONVERSED, States.PARRY_END]: return
	if fsm.currentState is States.PARRY_START:
		if !Input.is_action_pressed("parry"):
			fsm.changeState(States.PARRY_END)
	else:
		if velocity.y > 0 && fsm.stateIs() in [States.IDLE, States.WALK, States.JUMP]:
			fsm.changeState(States.FALLING)
		elif Input.is_action_just_pressed("parry"):
			if fsm.stateIs() in [States.IDLE, States.WALK] || (fsm.currentState is States.ATTACK && fsm.currentState.arguments[0] == 1):
				fsm.changeState(States.PARRY_START)
		elif Input.is_action_just_pressed("attack"):
			if fsm.stateIs() in [States.IDLE, States.WALK]:
				if fsm.changeState(States.ATTACK, [attackCounter % 2 + 1]):
					attackCounter += 1
					useStrength(10)
		elif Input.is_action_just_pressed("dash"):
			if fsm.stateIs() in [States.IDLE, States.WALK]:
				fsm.changeState(States.DASH, [direction])
				useStrength(5)
		elif Input.is_action_just_pressed("jump"):
			if fsm.stateIs() in [States.IDLE, States.WALK, States.DASH] && is_on_floor():
				fsm.changeState(States.JUMP, [1])
		elif Input.is_action_pressed("moving"):
			if fsm.stateIs() in [States.IDLE, States.WALK] && is_on_floor():
				fsm.changeState(States.WALK, [Input.get_axis("move_left", "move_right")])
		else:
			if fsm.stateIs() in [States.WALK]:
				fsm.changeState(States.IDLE)
func createAttack(id: int) -> void:
	match id:
		1:
			BulletBase.create(get_parent(), "KnifeSwing", getAnchorPosition("attack1"), PI / 2 - direction * PI / 2, self )
		2:
			BulletBase.create(get_parent(), "KnifeSwing", getAnchorPosition("attack1"), PI / 2 - direction * PI / 2, self )
func parry(_bullet: BulletBase, isPerfect: bool):
	if isPerfect:
		EffectPlayer.play(get_parent(), "PerfectParry", getAnchorPosition("parry"), (Vector2.from_angle(getAnchorRotation("parry")) * Vector2(-1, 1)).angle())
