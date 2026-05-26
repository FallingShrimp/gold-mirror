@tool
extends Control
class_name TalkOption

@onready var textLabel: RichTextLabel = $%text
@onready var indexLabel: Label = $%index
@onready var animator: AnimationPlayer = $%animator

func apply(text: String, index: int):
	textLabel.text = "[font_size=13]%s[/font_size]" % text
	indexLabel.text = "%d" % (index + 1)
	animator.play("show")
	await animator.animation_finished
func close():
	animator.play("hide")
	await animator.animation_finished
	queue_free()

static func create() -> TalkOption:
	return load("res://components/Boxes/TalkOption.tscn").instantiate() as TalkOption
