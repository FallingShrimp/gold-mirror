@tool
extends Control
class_name KeypadButton

@export var keys: Array[String] = []
@export_tool_button("重建") var refresh = rebuildInfo

@onready var textLabel: Label = $%text

func _ready():
	rebuildInfo()

func rebuildInfo():
	textLabel.text = " / ".join(keys)

static func create(keyx: Array[String] = []):
	var instance = load("res://components/Boxes/KeypadButton.tscn").instantiate() as KeypadButton
	instance.keys = keyx
	return instance
