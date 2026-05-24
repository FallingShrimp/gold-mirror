extends EntityBase
class_name CharacterBase

signal strengthIncreased(amount: float)
signal strengthChanged(to: float)
signal magicChanged(to: Vector2)
signal converse()
signal itemStored(delta: Dictionary[ContentManager.ItemType, int])

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

const GRAVITY = 2000
const CONSTANT_FRICTION: float = 0.2
const PERFECT_PARRY_WINDOW: float = 200.0

@export var isBoss: bool = false
@export var attackTime: float = 50.0
@export var mass: float = 1
@export var movementSpeed: float = 1.0
@export var maxStrength: float = 100
@export var maxMagicLength: float = 100
@export var impactMultiplier: float = 0.25
@export var vulnerability: float = 0.5
@export var strengthRegeneration: float = 5
@export var magicRegeneration: float = 5
var frictable: bool = true
var frictionMultipiler: float = 1

@onready var stateBar: CharacterStateBar = $%stateBar
@onready var skeleton: Skeleton2D = $%skeleton
@onready var polygonParent: Node2D = $%polygons
@export var currentStrength: float = 0
@export var currentMagic: Vector2 = Vector2.ZERO
var fsm: FiniteStateMachine
var direction: Direction = Direction.RIGHT
var attackCounter: int = 0
var emittedForNextAttack: bool = false
var lastAttackTime: float = 0
var parrying: bool = false
var myBossbar: Bossbar = null
var following: bool = false
var followingPosition: Vector2 = Vector2.ZERO
var followingSpeed: float = 1
var followingAutoExit: float = 10
var strengthThrottle: ThrottleController = ThrottleController.new(2000)
var inventory: Dictionary[ContentManager.ItemType, int] = {
	ContentManager.ItemType.MAGIC_BALL: 0
}
var inventoryMax: Dictionary[ContentManager.ItemType, int] = {}

func _ready():
	super._ready()
	currentStrength = maxStrength
	currentMagic = Vector2(maxMagicLength, 0)
	fsm = FiniteStateMachine.new(self )
	stateBar.initCharacter(self )
	strengthIncreased.connect(
		func(amount: float):
			if currentStrength == 0:
				converse.emit()
			if amount < 0:
				strengthThrottle.flag()
	)
	converse.connect(
		func():
			fsm.changeState(States.CONVERSED)
	)
	died.connect(func(): fsm.changeState(States.DIE))
	itemStored.connect(
		func(delta: Dictionary[ContentManager.ItemType, int]):
			for item in delta:
				if item == ContentManager.ItemType.MAGIC_BALL:
					storeMagic(Vector2(10 * delta[item], 0))
	)
func _physics_process(delta):
	super._physics_process(delta)
	fsm.update(delta)
	if currentMagic.x < 0:
		useStrength(strengthRegeneration * 0.25 * delta, false)
		storeMagic(Vector2(magicRegeneration * delta, 0))
	elif strengthThrottle.canExecute():
		storeStrength(strengthRegeneration * delta, true)
	skeleton.scale.x = direction
	polygonParent.scale.x = direction
	anchorParent.scale.x = direction
	if following:
		position = lerp(position, followingPosition, delta * followingSpeed)
		if position.distance_to(followingPosition) <= followingAutoExit:
			unfollow()
	else:
		velocity += Vector2(0, GRAVITY * delta)
		if frictable:
			velocity.x *= 1 - CONSTANT_FRICTION * frictionMultipiler
		move_and_slide()

func createAttack(_id: int) -> void:
	pass
func isInterruptedByDamage(amount: float) -> bool:
	return amount >= 0
func parry(_bullet: BulletBase, _isPerfect: bool):
	pass
func canRunAi() -> bool:
	return !following
func die():
	await animator.animation_finished
func canCollect(_item: ItemBase) -> bool:
	assert(false, "未实现canCollect")
	return false

func follow(positiox: Variant, speed: float = 1, autoExit: float = 10):
	following = true
	followingPosition = positiox if positiox is Vector2 else positiox.call()
	followingSpeed = speed
	followingAutoExit = autoExit
	velocity = Vector2.ZERO
	while following:
		followingPosition = positiox if positiox is Vector2 else positiox.call()
		await get_tree().process_frame
func unfollow():
	following = false
func overrideDamage(base: float) -> float:
	if fsm.stateIs() == States.CONVERSED:
		return base * (1 + vulnerability)
	else:
		return base
func dart(force: float):
	impact(Vector2(direction * 200 * force, 0))
func forward(directiox: Direction, delta: float):
	velocity += Vector2(sign(directiox) * 5000, 0) * delta * movementSpeed
func useStrength(amount: float, underscore: bool = true):
	if underscore:
		if currentStrength <= amount:
			return false
	currentStrength = clamp(currentStrength - amount, 0, maxStrength)
	strengthIncreased.emit(-amount)
	return true
func enoughStrength(amount: float):
	return currentStrength >= amount
func storeStrength(amount: float, justChanged: bool = false):
	currentStrength = clamp(currentStrength + amount, 0, maxStrength)
	if justChanged:
		strengthChanged.emit(currentStrength)
	else:
		strengthIncreased.emit(amount)
func useMagic(delta: Vector2):
	currentMagic = (currentMagic - delta).limit_length(maxMagicLength)
	magicChanged.emit(currentMagic)
func storeMagic(delta: Vector2):
	currentMagic = (currentMagic + delta).limit_length(maxMagicLength)
	magicChanged.emit(currentMagic)
func directionAsRotation() -> float:
	return PI / 2 - direction * PI / 2
func distanceToFocusing():
	if is_instance_valid(focusingEntity):
		return position.distance_to(focusingEntity.position)
	else:
		return INF
func enoughItem(delta: Dictionary[ContentManager.ItemType, int]):
	for item in delta:
		if inventory[item] < delta[item]:
			return false
	return true
func useItem(delta: Dictionary[ContentManager.ItemType, int]):
	var state = enoughItem(delta)
	if state:
		for item in delta:
			inventory[item] -= delta[item]
	return state
func storeItem(delta: Dictionary[ContentManager.ItemType, int]):
	for item in delta:
		inventory[item] = clamp(inventory[item] + delta[item], 0, inventoryMax.get(item, INF))
	itemStored.emit(delta)

static func create(namx: String, positiox: Vector2):
	var instance = load("res://components/Characters/%s.tscn" % namx).instantiate() as CharacterBase
	instance.position = positiox
	WorldManager.rootNode.add_child.call_deferred(instance)
	return instance
