extends CharacterBase
class_name PlayerBase

func _ready():
	super._ready()
	LayerUtil.config(self , [LayerUtil.Layers.PLAYER], [LayerUtil.Layers.ENEMY, LayerUtil.Layers.WALL])
	WorldManager.playerInstance = self
	stateBar.hide()
	await get_tree().process_frame
	PlayerInterface.instance.playerStateBar.initCharacter(self )

func isPlayer() -> bool:
	return true
