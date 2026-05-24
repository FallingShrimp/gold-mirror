@tool
extends EffectPlayer
class_name LaserBase

var currentLength: float = 0
var particleMaterial: ParticleProcessMaterial = null

@export var maxLength: float = 1000
@export var penetrate: bool = false
@export var laserHeight: float = 50

@onready var raycast: RayCast2D = $%raycast

func spawn():
	particles.process_material = particles.process_material.duplicate()
	particleMaterial = particles.process_material
	applyLength()
func ai(_delta: float):
	applyLength()

func detectLength() -> float:
	if penetrate:
		return maxLength
	raycast.target_position.y = maxLength
	if raycast.is_colliding():
		return (raycast.get_collision_point() - raycast.global_position).length()
	return maxLength
func applyLength():
	currentLength = detectLength()
	shaderStage.size = Vector2(laserHeight / 2, currentLength)
	shaderStage.position.x = currentLength / 2
	particleMaterial.emission_box_extents.y = currentLength / 2
	particleMaterial.initial_velocity_max = laserHeight
	particleMaterial.initial_velocity_min = - laserHeight
	particles.position = Vector2.RIGHT * currentLength / 2
	particles.visibility_rect.position = Vector2(laserHeight, currentLength) / -2
	particles.visibility_rect.size = Vector2(laserHeight, currentLength)
