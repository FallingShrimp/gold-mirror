extends CharacterBody2D
class_name EntityBase

signal damageTaken(amount: float)
signal died()

@export var maxHealth: float = 100
@export var invincible: bool = false

@onready var animator: AnimationPlayer = $%animator
@onready var texture: Node2D = $%texture
@onready var movebox: CollisionShape2D = $%movebox
@onready var hurtboxArea: Area2D = $%hurtbox
@onready var anchorParent: Node2D = $%anchors

@export var currentHealth: float = 0
var focusingEntity: EntityBase = null
var dieing: bool = false

func _ready():
	register()
	add_to_group("entity")
	currentHealth = maxHealth
	hurtboxArea.add_to_group("hurtboxes")
	LayerUtil.ghostize(self )
	await get_tree().process_frame
	spawn()
func _physics_process(delta):
	if visible && canRunAi():
		ai(delta)

func register():
	pass
func spawn():
	pass
func ai(_delta: float):
	pass
func isPlayer() -> bool:
	assert(false, "未实现isPlayer")
	return false
func overrideDamage(base: float) -> float:
	return base
func canRunAi() -> bool:
	return true
func die():
	pass

func publicDie():
	if dieing: return
	if isPlayer(): return
	dieing = true
	died.emit()
	await die()
	queue_free()
	dieing = false
func takeDamage(amount: float):
	if invincible: return
	var totalDamage = overrideDamage(amount)
	currentHealth -= totalDamage
	currentHealth = clamp(currentHealth, 0, maxHealth)
	DamageLabel.create(get_parent(), position, totalDamage)
	damageTaken.emit(totalDamage)
	if currentHealth == 0:
		publicDie()
func hasAnchor(namx: String) -> bool:
	return !!(anchorParent.get_node_or_null(namx as NodePath))
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
