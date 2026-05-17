extends EnemyBase

func register():
	movementSpeed = 0.5
func ai(_delta: float):
	if is_instance_valid(WorldManager.playerInstance):
		var targetDir = sign(WorldManager.playerInstance.position.x - position.x)
		if WorldManager.playerInstance.position.distance_to(position) > 300 || targetDir != direction:
			fsm.changeState(States.WALK, [targetDir])
		else:
			fsm.changeState(States.ATTACK, [1])
func createAttack(id: int) -> void:
	match id:
		1:
			BulletBase.create(get_parent(), "BroomSwing", position + Vector2(direction * 200, -100), 0, self )
