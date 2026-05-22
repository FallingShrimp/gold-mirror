extends CharacterBase
class_name EnemyBase

func _ready():
	super._ready()
	add_to_group("enemy")
	LayerUtil.config(self , [LayerUtil.Layers.ENEMY], [LayerUtil.Layers.PLAYER, LayerUtil.Layers.WALL])
	if isBoss:
		add_to_group("boss")
		stateBar.hide()
		await get_tree().process_frame
		myBossbar = PlayerInterface.addBossBarFor(self )
		die.connect(func(): myBossbar.queue_free())

func ai(_delta: float):
	if !is_instance_valid(focusingEntity):
		focusingEntity = WorldManager.findClosetEntity(position, func(e: EntityBase): return e.isPlayer())

func isPlayer() -> bool:
	return false
func fixDirection():
	if is_instance_valid(WorldManager.playerInstance):
		direction = sign(WorldManager.playerInstance.position.x - position.x)
