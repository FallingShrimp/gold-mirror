extends CharacterBase
class_name EnemyBase

func _ready():
	super._ready()
	add_to_group("enemy")
	LayerUtil.config(self , [LayerUtil.Layers.ENEMY], [LayerUtil.Layers.WALL])
	if isBoss:
		add_to_group("boss")
		stateBar.hide()
		await get_tree().process_frame
		myBossbar = PlayerInterface.addBossBarFor(self )
		died.connect(
			func():
				CameraManager.extreme(self )
				if is_instance_valid(myBossbar):
					myBossbar.die()
		)

func ai(_delta: float):
	if !is_instance_valid(focusingEntity):
		focusingEntity = ContentUtil.findClosetEntity(position, func(e: EntityBase): return e.isPlayer())

func isPlayer() -> bool:
	return false
func fixDirection():
	if is_instance_valid(focusingEntity):
		direction = sign(focusingEntity.position.x - position.x)
