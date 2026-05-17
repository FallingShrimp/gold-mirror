extends CharacterBody2D
class_name EntityBase

signal damageTaken(amount: float)

@export var maxHealth: float = 100
@export var invincible: bool = false

@onready var animator: AnimationPlayer = $%animator
@onready var animationTree: AnimationTree = $%tree
@onready var texture: Node2D = $%texture
@onready var movebox: CollisionShape2D = $%movebox
@onready var hurtboxArea: Area2D = $%hurtbox
@onready var anchorParent: Node2D = $%anchors

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
	if invincible: return
	currentHealth -= amount
	currentHealth = clamp(currentHealth, 0, maxHealth)
	DamageLabel.create(get_parent(), position, amount)
	damageTaken.emit(amount)
	if currentHealth == 0:
		queue_free()
func getAnchorPosition(namx: String):
	var node = anchorParent.get_node_or_null(namx as NodePath)
	if node is Node2D:
		return node.global_position
	else:
		return Vector2.ZERO
func getAnchorRotation(namx: String):
	var node = anchorParent.get_node_or_null(namx as NodePath)
	if node is Node2D:
		return node.global_rotation
	else:
		return 0
func impact(delta: Vector2):
	velocity += delta
