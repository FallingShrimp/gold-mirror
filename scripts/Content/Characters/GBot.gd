extends PlayerBase

func _ready():
	super._ready()
	animator.animation_finished.connect(
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
				if Input.is_action_just_pressed("attack") && WorldManager.getCurrentTime() - lastAttackTime > attackTime && useStrength(attackCounter):
					emittedForNextAttack = true
					await animator.animation_finished
					fsm.changeState(States.ATTACK, [attackCounter % 2 + 1])
					attackCounter += 1
	)
	fsm.joinState.connect(
		func(newState, _o, _a):
			if newState is States.ATTACK:
				emittedForNextAttack = false
	)
func ai(_delta: float):
	match fsm.stateIs():
		States.CONVERSED, States.PARRY_END:
			return
		States.PARRY_START:
			if !Input.is_action_pressed("parry"):
				fsm.changeState(States.PARRY_END)
		States.IDLE, States.WALK, States.JUMP, States.ATTACK:
			if fsm.stateIs() in [States.IDLE, States.WALK, States.JUMP] && !is_on_floor():
				fsm.changeState(States.FALLING)
			elif fsm.stateIs() not in [States.JUMP, States.ATTACK]:
				if Input.is_action_just_pressed("parry"):
					fsm.changeState(States.PARRY_START)
				elif Input.is_action_just_pressed("attack"):
					if useStrength(attackCounter):
						if fsm.changeState(States.ATTACK, [attackCounter % 2 + 1]):
							attackCounter += 1
				elif Input.is_action_just_pressed("dash"):
					if useStrength(10):
						fsm.changeState(States.DASH, [direction])
				elif Input.is_action_just_pressed("jump"):
					fsm.changeState(States.JUMP, [1])
				elif Input.is_action_pressed("moving"):
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
	else:
		EffectPlayer.play(get_parent(), "UnexactParry", getAnchorPosition("parry"), (Vector2.from_angle(getAnchorRotation("parry")) * Vector2(-1, 1)).angle())
