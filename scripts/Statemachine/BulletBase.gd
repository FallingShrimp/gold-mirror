extends Area2D
class_name BulletBase

enum MotionType {
	SWING,
	STAB,
	PROJECTILE
}

@export var baseDamage: float = 10
@export var motionType: MotionType = MotionType.SWING
@export var lifetime: float = 1000
@export var penetrate: bool = false
@export var knockback: float = 0
@export var impulse: float = 0

@onready var spawnTime: float = WorldManager.getCurrentTime()
var launcher: EntityBase = null

func _ready():
	area_entered.connect(
		func(hurtbox):
			var entity = FetchUtil.getEntityFromHurtbox(hurtbox)
			if entity is EntityBase:
				if FetchUtil.canDamage(self , entity):
					if entity is CharacterBase:
						var chara = entity as CharacterBase
						if chara.invincible:
							return
						elif chara.fsm.currentState is States.DASH:
							return
						elif chara.fsm.currentState is States.PARRY_START:
							if chara.direction != getDirection():
								var parryState = chara.fsm.currentState as States.PARRY_START
								var isPerfect = parryState.timePassed() <= chara.PERFECT_PARRY_WINDOW
								chara.parry(self , isPerfect)
								parryState.maxHoldTime *= 0.5
								if isPerfect:
									launcher.impact(Vector2(-getDirection(), 0).normalized() * 3000)
									chara.impact(Vector2(getDirection(), 0).normalized() * 1500)
									CameraManager.shake(300, 400)
								else:
									chara.impact(Vector2(getDirection(), 0).normalized() * 3000)
									launcher.impact(Vector2(-getDirection(), 0).normalized() * 1500)
									CameraManager.shake(200, 150)
								if launcher is CharacterBase:
									if isPerfect:
										var averageMultiplier = (launcher.impactMultiplier + chara.impactMultiplier) / 2.0
										chara.useStrength(impulse * averageMultiplier)
										launcher.useStrength(impulse * (2 - averageMultiplier))
									else:
										var averageMultiplier = (launcher.impactMultiplier + chara.impactMultiplier) / 2.0
										chara.useStrength(impulse * (2 - averageMultiplier))
										launcher.useStrength(impulse * averageMultiplier)
								return
						if chara.isInterruptedByDamage(baseDamage):
							chara.fsm.changeState(States.HURT, [-Vector2.from_angle(rotation).x])
					EffectPlayer.play(get_parent(), "Blood", Vector2(entity.position.x, position.y), 0)
					entity.takeDamage(baseDamage)
					entity.impact(Vector2.from_angle(rotation) * 1000 * knockback)
					if penetrate:
						queue_free()
	)
func _physics_process(delta):
	if timePassed() > lifetime:
		queue_free()
	ai(delta)

func register():
	pass
func ai(_delta: float):
	pass

func timePassed():
	return WorldManager.getCurrentTime() - spawnTime
func getDirection():
	return sign(Vector2.from_angle(rotation).x)

static func create(root: Node2D, namx: String, positiox: Vector2, rotatiox: float, launchex: EntityBase):
	var instance = load("res://components/Bullets/%s.tscn" % namx).instantiate() as BulletBase
	instance.position = positiox
	instance.rotation = rotatiox
	instance.launcher = launchex
	root.add_child(instance)
	return instance
