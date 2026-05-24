extends BulletBase
class_name LaserBaseBullet

@export var shakeIntensity: float = 100

@onready var effect: LaserBase = $%effect
var dotTimer: CooldownController = CooldownController.new(500)

func ai(delta: float):
	if launcher is CharacterBase:
		launcher.useMagic(Vector2(20 * delta, 0))
		launcher.impact(Vector2.from_angle(rotation) * -1000 * delta)
		PresetBulletAI.lockLauncher(self , "magic")
	if dotTimer.start():
		hitbox.disabled = false
	else:
		hitbox.disabled = true
	var hb = hitbox.shape as RectangleShape2D
	hb.size.x = effect.currentLength + effect.laserHeight
	hitbox.position.x = effect.currentLength / 2
func register():
	effect.shot()
	CameraManager.shake(lifetime, shakeIntensity, func(_c, initial: float, rest: float): return initial * rest)
	hitEntity.connect(func(e: EntityBase): e.impact(Vector2.from_angle(rotation) * 500))
	hitbox.shape = hitbox.shape.duplicate()
func destroy():
	CameraManager.shakeStop()
