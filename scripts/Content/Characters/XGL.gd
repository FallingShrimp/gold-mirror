extends EnemyBase

func _ready():
	super._ready()
	animator.animation_finished.connect(
		func(_n):
			if fsm.currentState is States.ATTACK:
				fsm.changeState(States.IDLE)
	)
func ai(_delta: float):
	if is_instance_valid(WorldManager.playerInstance):
		var targetDirection = sign(WorldManager.playerInstance.position.x - position.x)
		match fsm.stateIs():
			States.CONVERSED:
				return
			States.WALK, States.IDLE, States.JUMP:
				if !is_on_floor():
					fsm.changeState(States.FALLING)
				elif WorldManager.playerInstance.position.distance_to(position) > 350 || targetDirection != direction:
					fsm.changeState(States.WALK, [targetDirection])
				else:
					fsm.changeState(States.ATTACK, [1])
func createAttack(id: int) -> void:
	match id:
		1:
			BulletBase.create(get_parent(), "BroomSwing", getAnchorPosition("attack1"), PI / 2 - direction * PI / 2, self )
func isInterruptedByDamage(amount: float) -> bool:
	return amount > 100
