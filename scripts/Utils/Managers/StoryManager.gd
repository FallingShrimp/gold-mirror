extends Control
class_name StoryManager

signal clickHide()

enum Character {
	G_BOT
}

@onready var textLabel: Label = $%text
var canClick: bool = true

static var instance: StoryManager

func _ready():
	instance = self
	hide()
func _process(_delta):
	if canClick:
		if Input.is_action_just_pressed("next_story"):
			hide()
			clickHide.emit()

static func text(texx: String, canClicx: bool = true):
	instance.textLabel.text = texx
	instance.canClick = canClicx
	instance.show()
	await instance.clickHide
static func close():
	instance.canClick = false
	instance.hide()
