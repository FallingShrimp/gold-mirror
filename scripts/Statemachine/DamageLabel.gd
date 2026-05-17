@tool
extends Node2D
class_name DamageLabel

@onready var label: Label = $%label
@onready var animator: AnimationPlayer = $%animator

@export var amount: float = 114514

func _ready():
	rebuildInfo()
	animator.play("show")
	await animator.animation_finished
	queue_free()

func rebuildInfo():
	label.text = "%d" % amount

static func create(root: Node2D, positiox: Vector2, amounx: float):
	var instance = load("res://components/Boxes/DamageLabel.tscn").instantiate() as DamageLabel
	instance.amount = amounx
	instance.position = positiox
	root.add_child(instance)
	return instance
