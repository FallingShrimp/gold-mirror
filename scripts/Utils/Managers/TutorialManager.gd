class_name TutorialManager

static var focused: Dictionary[String, int] = {}

static func tutorialFocus(name: String, position: Vector2, text: String, allowActions: Array[ActionManager.PlayerAction]):
	if name not in focused:
		focused[name] = 0
	focused[name] += 1
	PlayerInterface.focusNode(WorldManager.rootNode.get_viewport_transform() * position, 300)
	PlayerInterface.tip(text)
	ActionManager.justEnable(allowActions)
	await ActionManager.instance.did
	ActionManager.enableAll()
	PlayerInterface.tipExit()
	PlayerInterface.unfocus()
