extends BulletBase
class_name LaserBaseBullet

@export var shakeIntensity: float = 100

@onready var effect: LaserBase = $%effect

func register():
	effect.shot()
	CameraManager.shake(lifetime, shakeIntensity, func(_c, initial: float, rest: float): return initial * rest)
func destroy():
	animator.play("hide")
	await animator.animation_finished
