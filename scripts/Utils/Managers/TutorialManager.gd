class_name TutorialManager

static var focused: Dictionary[String, bool] = {}

static func tutorialFocus(name: String, position: Vector2, text: String, allowActions: Array[ActionManager.PlayerAction]):
	if focused.get(name, false): return
	focused[name] = true
	PlayerInterface.focusNode(WorldManager.rootNode.get_viewport_transform() * position, 300)
	PlayerInterface.tip(text)
	ActionManager.justEnable(allowActions)
	await ActionManager.instance.did
	ActionManager.enableAll()
	PlayerInterface.tipExit()
	PlayerInterface.unfocus()
