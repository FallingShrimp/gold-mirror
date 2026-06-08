extends Node2D
class_name DamageLabel

@export var amount: float = 114514

@onready var label: Label = $%label
@onready var animator: AnimationPlayer = $%animator
var initialColor: Color

func _ready():
	initialColor = label.label_settings.font_color
	label.label_settings = label.label_settings.duplicate()
	rebuildInfo()
	animator.play("show")
	await animator.animation_finished
	queue_free()

func rebuildInfo():
	if amount < 0:
		label.label_settings.font_color = Color.GREEN
		label.text = "+%d" % abs(amount)
	elif amount > 0:
		label.label_settings.font_color = initialColor
		label.text = "%d" % amount
	else:
		label.label_settings.font_color = Color.GRAY
		label.text = "MISS"

static func create(root: Node2D, positiox: Vector2, amounx: float):
	var instance = load("res://components/Boxes/DamageLabel.tscn").instantiate() as DamageLabel
	instance.amount = amounx
	instance.position = positiox
	root.add_child(instance)
	return instance
