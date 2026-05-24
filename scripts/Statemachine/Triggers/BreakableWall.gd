extends StaticBody2D
class_name BreakableWall

@export var minDamage: float = 50
@export var isPlayer: bool = false

func _ready():
	LayerUtil.belong(self , {LayerUtil.Layers.WALL: true})

func handleBroke(by: BulletBase):
	if by.baseDamage >= minDamage:
		queue_free()
