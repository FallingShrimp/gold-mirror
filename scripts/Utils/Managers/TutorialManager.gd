class_name TutorialManager

static var focused: Dictionary[String, bool] = {}

static func tutorialFocus(name: String, position: Vector2, text: String, allowActions: Array[ActionManager.PlayerAction], waitActions: Array[ActionManager.PlayerAction]):
	if focused.get(name, false): return
	focused[name] = true
	PlayerInterface.focusNode(WorldManager.rootNode.get_viewport_transform() * position, 300)
	StoryManager.text(Characters.CreatorOrHacker, text, [], false)
	ActionManager.justEnable(allowActions)
	while true:
		if await ActionManager.instance.did in waitActions:
			break
	ActionManager.enableAll()
	StoryManager.close()
	PlayerInterface.unfocus()
