extends EntityBase
class_name WallBase

func _ready():
	super._ready()
	LayerUtil.config(self , [LayerUtil.Layers.WALL], [LayerUtil.Layers.PLAYER, LayerUtil.Layers.ENEMY])

func isPlayer() -> bool:
	return false
