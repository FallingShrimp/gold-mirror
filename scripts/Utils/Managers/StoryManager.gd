extends Control
class_name StoryManager

signal clickHide(index: int)

@onready var avatarTexture: TextureRect = $%avatar
@onready var sayerLabel: Label = $%sayer
@onready var textLabel: Label = $%text
@onready var textTip: Label = $%tip
@onready var optionsBox: Control = $%options
var canClick: bool = true

static var instance: StoryManager
static var playedCount: Dictionary[String, int] = {}

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
		elif Input.is_action_just_pressed("interact"):
			hide()
			clickHide.emit(-1)

static func playOnce(id: String):
	if isPlayed(id):
		return false
	else:
		if id not in playedCount:
			playedCount[id] = 0
		playedCount[id] += 1
		GameSaveManager.overrideSave()
		return true
static func playTimes(id: String) -> int:
	var current = playedCount.get(id, 0)
	playedCount[id] = current + 1
	GameSaveManager.overrideSave()
	return current
static func isPlayed(id: String) -> bool:
	return playTimes(id) > 0
static func text(character: GDScript, texx: String, options: Array[String] = [], canClicx: bool = true, pause: bool = false) -> int:
	if pause:
		WorldManager.sceneTree.paused = true
	ActionManager.justEnable([])
	var characterInstance = character.new()
	if characterInstance is StoryObject.StoryCharacter:
		if characterInstance.avatar:
			instance.avatarTexture.texture = characterInstance.avatar
			instance.avatarTexture.show()
		else:
			instance.avatarTexture.hide()
		if characterInstance.displayName:
			instance.sayerLabel.text = characterInstance.displayName
			instance.sayerLabel.show()
		else:
			instance.sayerLabel.hide()
	instance.show()
	instance.canClick = false
	instance.textLabel.text = texx
	NodeUtil.clearChildren(instance.optionsBox)
	if len(options) > 0:
		instance.textTip.hide()
		instance.optionsBox.show()
		for i in len(options):
			var optionBox = TalkOption.create()
			instance.optionsBox.add_child(optionBox)
			optionBox.apply(options[i], i)
			await TimeUtil.millseconds(100)
	else:
		if canClicx:
			instance.textTip.show()
		else:
			instance.textTip.hide()
		instance.optionsBox.hide()
	instance.canClick = canClicx
	var result = await instance.clickHide
	ActionManager.enableAll()
	if pause:
		WorldManager.sceneTree.paused = false
	return result
static func close():
	instance.canClick = false
	instance.hide()
