extends EnemyBase

func _ready():
	super._ready()
	animator.animation_finished.connect(
		func(_n):
			if fsm.currentState is States.ATTACK:
				fsm.changeState(States.IDLE)
	)
func ai(delta: float):
	super.ai(delta)
	if is_instance_valid(focusingEntity) && focusingEntity is EntityBase:
		var targetDirection = sign(focusingEntity.position.x - position.x)
		match fsm.stateIs():
			States.CONVERSED:
				return
			States.WALK, States.IDLE, States.JUMP:
				if !is_on_floor():
					fsm.changeState(States.FALLING)
				elif distanceToFocusing() < 200:
					fsm.changeState(States.WALK, [-targetDirection])
				elif distanceToFocusing() > 350 || targetDirection != direction:
					fsm.changeState(States.WALK, [targetDirection])
				else:
					# fsm.changeState(States.ATTACK, [MathUtil.randomChoiceFromWeights([1, 2, 3], [7, 3, 1])])
					fsm.changeState(States.ATTACK, [3])
func createAttack(id: int) -> void:
	match id:
		1:
			BulletBase.create("BroomSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
		2:
			BulletBase.create("BroomSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
		3:
			BulletBase.create("BroomSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
			await follow(func(): return focusingEntity.position - Vector2(0, 500), 5, -1)
		4:
			unfollow()
			BulletBase.create("BroomStamp", getAnchorPosition("attack1"), PI / -2, self )
			impact(Vector2(0, 5000))
		5:
			BulletBase.create("BroomGun", getAnchorPosition("attack3"), directionAsRotation(), self )
func isInterruptedByDamage(amount: float) -> bool:
	return amount > 50
