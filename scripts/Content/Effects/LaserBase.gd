@tool
extends EffectPlayer
class_name LaserBase

@export var maxLength: float = 1000
@export var penetrate: bool = false

@onready var raycast: RayCast2D = $%raycast

func ai(_delta: float):
	shaderStage.size.y = detect()

func detect() -> float:
	raycast.target_position.y = maxLength
	if raycast.is_colliding():
		return (raycast.get_collision_point() - raycast.position).length()
	return maxLength
