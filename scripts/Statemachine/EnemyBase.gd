extends CharacterBase
class_name EnemyBase

func _ready():
	super._ready()
	LayerUtil.config(self , [LayerUtil.Layers.ENEMY], [LayerUtil.Layers.PLAYER, LayerUtil.Layers.WALL])
