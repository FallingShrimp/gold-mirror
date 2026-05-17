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
					entity.takeDamage(baseDamage)
					EffectPlayer.play(get_parent(), "Blood", position, 0)
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

static func create(root: Node2D, namx: String, positiox: Vector2, rotatiox: float, launchex: EntityBase):
	var instance = load("res://components/Bullets/%s.tscn" % namx).instantiate() as BulletBase
	instance.position = positiox
	instance.rotation = rotatiox
	instance.launcher = launchex
	root.add_child(instance)
	return instance
