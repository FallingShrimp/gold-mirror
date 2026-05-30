@tool
extends HBoxContainer
class_name KeyInsideLabel

@export var text: String = "按下[action]时触发动作"
@export_tool_button("重建") var rebuildBtn = rebuild

func _ready():
	rebuild()

func rebuild():
	NodeUtil.clearChildren(self )
	var parts = ParseUtil.splitByBox(text)
	for i in len(parts):
		var part = parts[i]
		if i % 2 == 1:
			add_child(KeypadButton.create(ParseUtil.readAction(part)))
		else:
			add_child(ComponentUtil.label(part))
