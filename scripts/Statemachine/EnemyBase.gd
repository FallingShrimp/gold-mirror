extends CharacterBase
class_name EnemyBase

func _ready():
	super._ready()
	LayerUtil.config(self , [LayerUtil.Layers.ENEMY], [LayerUtil.Layers.PLAYER, LayerUtil.Layers.WALL])
	if isBoss:
		stateBar.hide()
		await get_tree().process_frame
		myBossbar = PlayerInterface.addBossBarFor(self )
		die.connect(func(): myBossbar.queue_free())

func isPlayer() -> bool:
	return false
func fixDirection():
	if is_instance_valid(WorldManager.playerInstance):
		direction = sign(WorldManager.playerInstance.position.x - position.x)
