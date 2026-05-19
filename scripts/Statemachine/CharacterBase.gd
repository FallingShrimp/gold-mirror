extends EntityBase
class_name CharacterBase

signal strengthIncreased(amount: float)
signal strengthChanged(to: float)
signal converse()

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

const GRAVITY = 20
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
var myBossbar: CharacterStateBar = null

var strengthThrottle: ThrottleController = ThrottleController.new(2000)

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
func _physics_process(delta):
	super._physics_process(delta)
	if strengthThrottle.canExecute():
		storeStrength(strengthRegeneration * delta, true)
	fsm.update(delta)
	velocity += Vector2(0, GRAVITY)
	if frictable:
		velocity.x *= 1 - CONSTANT_FRICTION * frictionMultipiler
	move_and_slide()
	skeleton.scale.x = direction
	polygonParent.scale.x = direction
	anchorParent.scale.x = direction

func createAttack(_id: int) -> void:
	pass
func isInterruptedByDamage(amount: float) -> bool:
	return amount >= 0
func parry(_bullet: BulletBase, _isPerfect: bool):
	pass

func overrideDamage(base: float) -> float:
	if fsm.stateIs() == States.CONVERSED:
		return base * (1 + vulnerability)
	else:
		return base

func forward(directiox: Direction, delta: float):
	velocity += Vector2(sign(directiox) * 5000, 0) * delta * movementSpeed
func useStrength(amount: float, check: bool = true):
	if check:
		if currentStrength <= amount:
			return false
	currentStrength = clamp(currentStrength - amount, 0, maxStrength)
	strengthIncreased.emit(-amount)
	return true
func storeStrength(amount: float, justChanged: bool = false):
	currentStrength = clamp(currentStrength + amount, 0, maxStrength)
	if justChanged:
		strengthChanged.emit(currentStrength)
	else:
		strengthIncreased.emit(amount)
func useMagic(delta: Vector2):
	currentMagic = (currentMagic - delta).limit_length(maxMagicLength)
func storeMagic(delta: Vector2):
	currentMagic = (currentMagic + delta).limit_length(maxMagicLength)
