extends BulletBase
class_name LaserBaseBullet

@export var shakeIntensity: float = 100

@onready var effect: LaserBase = $%effect
var dotTimer: CooldownController = CooldownController.new(250)

func ai(delta: float):
	if launcher is CharacterBase:
		launcher.useMagic(Vector2(20 * delta, 0))
	if dotTimer.start():
		hitbox.disabled = false
	else:
		hitbox.disabled = true
func register():
	effect.shot()
	CameraManager.shake(lifetime, shakeIntensity, func(_c, initial: float, rest: float): return initial * rest)
func destroy():
	animator.play("hide")
	await animator.animation_finished
	CameraManager.shakeStop()
