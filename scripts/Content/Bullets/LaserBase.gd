extends BulletBase
class_name LaserBaseBullet

@export var shakeIntensity: float = 100

@onready var effect: LaserBase = $%effect
var dotTimer: CooldownController = CooldownController.new(250)

func ai(_delta: float):
	if dotTimer.start():
		hitbox.disabled = false
		if launcher is CharacterBase:
			launcher.useMagic(Vector2(10, 0))
	else:
		hitbox.disabled = true
func register():
	effect.shot()
	CameraManager.shake(lifetime, shakeIntensity, func(_c, initial: float, rest: float): return initial * rest)
func destroy():
	animator.play("hide")
	await animator.animation_finished
	CameraManager.shakeStop()
