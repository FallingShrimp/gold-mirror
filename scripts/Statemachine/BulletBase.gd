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
								chara.impact(Vector2(getDirection(), 0).normalized() * 2000)
								chara.parry(self )
								var parryState = chara.fsm.currentState as States.PARRY_START
								parryState.maxHoldTime *= 0.5
								CameraManager.shake(300, 300)
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
