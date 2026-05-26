extends Control
class_name StoryManager

signal clickHide(index: int)

enum Character {
	G_BOT
}

@onready var textLabel: Label = $%text
@onready var optionsBox: Control = $%options
var canClick: bool = true

static var instance: StoryManager
static var played: Array[String] = []

func _ready():
	instance = self
	hide()
func _process(_delta):
	if canClick:
		var count = optionsBox.get_child_count()
		if count > 0:
			for i in count:
				if Input.is_action_just_pressed("skill%d" % (i + 1)):
					for child in optionsBox.get_children():
						if child is TalkOption:
							child.close()
					while optionsBox.get_child_count() > 0:
						await get_tree().process_frame
					hide()
					clickHide.emit(i)
					break
		elif Input.is_action_just_pressed("next_story"):
			hide()
			clickHide.emit(-1)

static func playOnce(id: String):
	if isPlayed(id):
		return false
	else:
		played.append(id)
		return true
static func isPlayed(id: String) -> bool:
	return id in played
static func text(_character: GDScript, texx: String, options: Array[String] = [], canClicx: bool = true):
	instance.show()
	instance.canClick = false
	instance.textLabel.text = texx
	NodeUtil.clearChildren(instance.optionsBox)
	if len(options) > 0:
		instance.optionsBox.show()
		for i in len(options):
			var optionBox = TalkOption.create()
			instance.optionsBox.add_child(optionBox)
			optionBox.apply(options[i], i)
			await TimeUtil.millseconds(100)
	else:
		instance.optionsBox.hide()
	instance.canClick = canClicx
	return await instance.clickHide
static func close():
	instance.canClick = false
	instance.hide()
