@tool
extends Control
class_name KeypadButton

@export var keys: Array[String] = []
@export var complement: String = ""
@export_tool_button("重建") var refresh = rebuildInfo

@onready var textLabel: Label = $%text
@onready var sep: Control = $%sep
@onready var complementLabel: Label = $%complement

func _ready():
	rebuildInfo()

func rebuildInfo():
	textLabel.text = " / ".join(keys)
	if complement:
		complementLabel.text = complement
		sep.show()
		complementLabel.show()
	else:
		sep.hide()
		complementLabel.hide()

static func create(keyx: Array[String] = []):
	var instance = load("res://components/Boxes/KeypadButton.tscn").instantiate() as KeypadButton
	instance.keys = keyx
	return instance
