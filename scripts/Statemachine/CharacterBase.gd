extends EntityBase
class_name CharacterBase

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

const GRAVITY = 20
const CONSTANT_FRICTION: float = 0.2

@export var attackTime: float = 50.0
@export var movementSpeed: float = 1.0
@export var mass: float = 1
var frictable: bool = true
var frictionMultipiler: float = 1

@onready var skeleton: Skeleton2D = $%skeleton
@onready var polygonParent: Node2D = $%polygons
var fsm: FiniteStateMachine
var direction: Direction = Direction.RIGHT
var attackCounter: int = 0
var emittedForNextAttack: bool = false
var lastAttackTime: float = 0
var parrying: bool = false

func _ready():
	super._ready()
	fsm = FiniteStateMachine.new(self )
func _physics_process(delta):
	super._physics_process(delta)
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
func parry(_bullet: BulletBase):
	pass

func forward(directiox: Direction, delta: float):
	velocity += Vector2(sign(directiox) * 5000, 0) * delta * movementSpeed
