extends CharacterBody2D
class_name EntityBase

signal damageTaken(amount: float)

@export var maxHealth: float = 100

@onready var animator: AnimationPlayer = $%animator
@onready var animationTree: AnimationTree = $%tree
@onready var texture: Node2D = $%texture
@onready var movebox: CollisionShape2D = $%movebox
@onready var hurtboxArea: Area2D = $%hurtbox

@onready var currentHealth = maxHealth
var animationPlayback: AnimationNodeStateMachinePlayback

func _ready():
	register()
	animationTree.active = true
	animationPlayback = animationTree.get("parameters/playback")
	animationTree.set("parameters/conditions/always", true)
	hurtboxArea.add_to_group("hurtboxes")
	LayerUtil.ghostize(self )
	await get_tree().process_frame
	spawn()
func _physics_process(delta):
	ai(delta)

func register():
	pass
func spawn():
	pass
func ai(_delta: float):
	pass
func isPlayer() -> bool:
	push_error("未实现isPlayer")
	return false

func takeDamage(amount: float):
	currentHealth -= amount
	currentHealth = clamp(currentHealth, 0, maxHealth)
	DamageLabel.create(get_parent(), position, amount)
	damageTaken.emit(amount)
	if currentHealth == 0:
		queue_free()
