extends CharacterBase
class_name PlayerBase

func _ready():
	super._ready()
	LayerUtil.config(self , [LayerUtil.Layers.PLAYER], [LayerUtil.Layers.ENEMY, LayerUtil.Layers.WALL])
