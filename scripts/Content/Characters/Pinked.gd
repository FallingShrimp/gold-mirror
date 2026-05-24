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
			States.WALK, States.IDLE, States.JUMP:
				if !is_on_floor():
					fsm.changeState(States.FALLING)
				else:
					if distanceToFocusing() < 500:
						fsm.changeState(States.WALK, [-targetDirection])
					elif distanceToFocusing() > 1500 || targetDirection != direction:
						fsm.changeState(States.WALK, [targetDirection])
					else:
						fsm.changeState(States.ATTACK, [attackCounter % 2 + 1])
						attackCounter += 1
func createAttack(id: int) -> void:
	match id:
		1:
			BulletBase.create(
				"NoteStar",
				getAnchorPosition("attack1"),
				getAnchorPosition("attack1").angle_to_point(focusingEntity.getAnchorPosition("trace")) + randf_range(-1, 1) * deg_to_rad(10),
				self
			)
func isInterruptedByDamage(amount: float) -> bool:
	return amount > 20
