extends Area2D
class_name BulletBase

signal destroied()
signal hitEntity(entity: EntityBase)
signal hitoutEntity(entity: EntityBase)

enum MotionType {
	SWING,
	STAB,
	PROJECTILE,
	LASER,
	DANMAKU
}

@export var baseDamage: float = 10
@export var motionType: MotionType = MotionType.SWING
@export var canParry: bool = true
@export var canDash: bool = true
@export var lifetime: float = 1000
@export var penetrate: bool = false
@export var knockback: float = 0
@export var recoil: float = 0
@export var impulse: float = 0
@export var speed: float = 500
@export var magic: Vector2 = Vector2.ZERO
@export var spawnSound: StringName = ""
@export var spawnAnimation: StringName = ""
@export var destroyAnimation: StringName = ""
@export var verticalDirection: bool = false
@export var freezeTime: float = 0

@onready var sounds: SoundStage = $%sounds
@onready var animator: AnimationPlayer = $%animator
@onready var hitbox: CollisionShape2D = $%hitbox
@onready var spawnTime: float = WorldManager.getCurrentTime()
var launcher: EntityBase = null
var destroying: bool = false
var freezed: bool = false

func _ready():
	register()
	add_to_group("bullet")
	area_entered.connect(handleAreaEnter)
	if spawnSound:
		sounds.play(spawnSound)
	if spawnAnimation:
		animator.play(spawnAnimation)
	destroied.connect(func(): hitoutEntity.emit(null))
	hitEntity.connect(
		func(_e):
			if !freezed:
				CameraManager.freezeTime(freezeTime)
				freezed = true
	)
	await get_tree().process_frame
	spawn()
func _physics_process(delta):
	if timePassed() > lifetime || !is_instance_valid(launcher):
		publicDestroy()
	elif !destroying:
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
	if destroying: return
	destroying = true
	await destroy()
	if destroyAnimation:
		animator.play(destroyAnimation)
		await animator.animation_finished
	destroied.emit()
	queue_free()
	destroying = false
func timePassed():
	return WorldManager.getCurrentTime() - spawnTime
func getDirection():
	return sign(Vector2.from_angle(rotation).x)
func handleAreaExit(node: Node2D):
	var entity = ContentUtil.getEntityFromHurtbox(node)
	if entity is EntityBase:
		hitoutEntity.emit(entity)
func handleAreaEnter(node: Node2D):
	var entity = ContentUtil.getEntityFromHurtbox(node)
	if entity is EntityBase:
		if ContentUtil.canDamageEntity(self , entity):
			if entity is CharacterBase:
				entity = entity as CharacterBase
				if entity.invincible:
					return
				elif entity.fsm.currentState is States.DASH:
					if canDash:
						if motionType == MotionType.DANMAKU:
							if launcher is CharacterBase:
								for i in 3:
									var positiox = position + MathUtil.sampleInCircle(100)
									ItemBase.create(ContentManager.ItemType.MAGIC_BALL, positiox, (positiox - position).normalized() * 3500)
									EffectPlayer.play("PerfectDash", position, 0)
						return
				elif entity.fsm.currentState is States.PARRY_START:
					if canParry && (entity.direction != getDirection() || verticalDirection):
						var parryState = entity.fsm.currentState as States.PARRY_START
						var isPerfect = parryState.timePassed() <= entity.PERFECT_PARRY_WINDOW
						var isSuper = entity.fsm.currentState.arguments[1]
						entity.parry(self , isPerfect, isSuper)
						if isSuper:
							parryState.maxHoldTime += 1000
							launcher.impact(Vector2(-getDirection(), 0).normalized() * 3000)
							entity.impact(Vector2(getDirection(), 0).normalized() * 3000)
						elif isPerfect:
							parryState.maxHoldTime += 250
							launcher.impact(Vector2(-getDirection(), 0).normalized() * 1500)
							entity.impact(Vector2(getDirection(), 0).normalized() * 3000)
						else:
							parryState.maxHoldTime -= 500
							entity.impact(Vector2(getDirection(), 0).normalized() * 1500)
							launcher.impact(Vector2(-getDirection(), 0).normalized() * 3000)
						if launcher is CharacterBase:
							if isPerfect:
								var averageMultiplier = (launcher.impactMultiplier + entity.impactMultiplier) / 2.0
								entity.useStrength(impulse * averageMultiplier, false)
								launcher.useStrength(impulse * (2 - averageMultiplier) * parryState.arguments[0], false)
							else:
								var averageMultiplier = (launcher.impactMultiplier + entity.impactMultiplier) / 2.0
								entity.useStrength(impulse * (2 - averageMultiplier) / parryState.arguments[0], false)
								launcher.useStrength(impulse * averageMultiplier, false)
						return
				if entity.isInterruptedByDamage(baseDamage):
					entity.fsm.changeState(States.HURT, [-Vector2.from_angle(rotation).x])
			if launcher.isPlayer():
				launcher.focusingEntity = entity
			if entity is CharacterBase && launcher is CharacterBase:
				(entity as CharacterBase).focusingEntity = launcher
			EffectPlayer.play("Blood", Vector2(entity.position.x, position.y), 0)
			entity.takeDamage(baseDamage)
			entity.impact(Vector2.from_angle(rotation) * 1000 * knockback)
			launcher.impact(Vector2.from_angle(rotation) * -1000 * recoil)
			hitEntity.emit(entity)
			if !penetrate:
				publicDestroy()

static func create(namx: String, positiox: Vector2, rotatiox: float, launchex: EntityBase) -> Array[BulletBase]:
	var instance = load("res://components/Bullets/%s.tscn" % namx).instantiate() as BulletBase
	instance.position = positiox
	instance.rotation = rotatiox
	instance.launcher = launchex
	WorldManager.rootNode.add_child(instance)
	return [instance]
