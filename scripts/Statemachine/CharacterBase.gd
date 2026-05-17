extends EntityBase
class_name CharacterBase

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

const GRAVITY = 20
const CONSTANT_FRICTION: float = 0.2

var attackTime: float = 100.0
var movementSpeed: float = 1.0
var mass: float = 1
var frictable: bool = true
var frictionMultipiler: float = 1

var fsm: FiniteStateMachine
var direction: Direction = Direction.RIGHT
var attackCounter: int = 0
var emittedForNextAttack: bool = false
var lastAttackTime: float = 0

func _ready():
	super._ready()
	fsm = FiniteStateMachine.new(self )
func _physics_process(delta):
	super._physics_process(delta)
	fsm.update(delta)
	if abs(velocity.x) >= 1:
		direction = sign(velocity.x)
	velocity += Vector2(0, GRAVITY)
	if frictable:
		velocity.x *= 1 - CONSTANT_FRICTION * frictionMultipiler
	move_and_slide()
	texture.scale.x = direction

func createAttack(_id: int) -> void:
	pass

func forward(directiox: Direction, delta: float):
	velocity += Vector2(sign(directiox) * 5000, 0) * delta
func impact(delta: Vector2):
	velocity += delta
