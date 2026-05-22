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
@export var speed: float = 10
@export var spawnSound: StringName = ""
@export var spawnAnimation: StringName = ""

@onready var sounds: SoundStage = $%sounds
@onready var animator: AnimationPlayer = $%animator
@onready var spawnTime: float = WorldManager.getCurrentTime()
var launcher: EntityBase = null

func _ready():
	register()
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
								if isPerfect:
									parryState.maxHoldTime += 250
									launcher.impact(Vector2(-getDirection(), 0).normalized() * 1500)
									chara.impact(Vector2(getDirection(), 0).normalized() * 3000)
									CameraManager.shake(300, 400)
								else:
									parryState.maxHoldTime -= 500
									chara.impact(Vector2(getDirection(), 0).normalized() * 1500)
									launcher.impact(Vector2(-getDirection(), 0).normalized() * 3000)
									CameraManager.shake(200, 150)
								if launcher is CharacterBase:
									if isPerfect:
										var averageMultiplier = (launcher.impactMultiplier + chara.impactMultiplier) / 2.0
										chara.useStrength(impulse * averageMultiplier, false)
										launcher.useStrength(impulse * (2 - averageMultiplier), false)
									else:
										var averageMultiplier = (launcher.impactMultiplier + chara.impactMultiplier) / 2.0
										chara.useStrength(impulse * (2 - averageMultiplier), false)
										launcher.useStrength(impulse * averageMultiplier, false)
								return
						if chara.isInterruptedByDamage(baseDamage):
							chara.fsm.changeState(States.HURT, [-Vector2.from_angle(rotation).x])
					EffectPlayer.play(get_parent(), "Blood", Vector2(entity.position.x, position.y), 0)
					entity.takeDamage(baseDamage)
					entity.impact(Vector2.from_angle(rotation) * 1000 * knockback)
					if !penetrate:
						publicDestroy()
	)
	if spawnSound:
		sounds.play(spawnSound)
	if spawnAnimation:
		animator.play(spawnAnimation)
	await get_tree().process_frame
	spawn()
func _physics_process(delta):
	if timePassed() > lifetime:
		publicDestroy()
	else:
		ai(delta)

func register():
	pass
func spawn():
	pass
func ai(_delta: float):
	pass
func destroy():
	pass

func publicDestroy():
	await destroy()
	queue_free()
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
