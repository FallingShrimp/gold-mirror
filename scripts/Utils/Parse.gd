class_name ParseUtil

static func splitByBox(text: String) -> Array[String]:
	var result: Array[String] = []
	var currentPart = ""
	var inBox = false
	for i in text.length():
		var character = text[i]
		if character == "[":
			if inBox:
				push_error("嵌套了")
				return []
			result.append(currentPart)
			currentPart = ""
			inBox = true
		elif character == "]":
			if not inBox:
				push_error("没闭合")
				return []
			result.append(currentPart)
			currentPart = ""
			inBox = false
		else:
			currentPart += character
	if inBox:
		push_error("没闭合")
		return []
	result.append(currentPart)
	return result
static func getActionEvents(action_name: StringName) -> Array[InputEvent]:
	var result: Array[InputEvent] = []
	for item in ProjectSettings.get_setting("input/%s" % action_name)["events"]:
		if item is InputEvent:
			result.append(item)
	return result
static func readAction(action: String) -> Array[String]:
	var result: Array[String] = []
	for event in getActionEvents(action):
		var label = mapEventToKey(event)
		if not label.is_empty():
			result.append(label)
	return result
static func mapEventToKey(event: InputEvent) -> String:
	if event is InputEventKey:
		var key_event = event as InputEventKey
		var keycode = key_event.keycode if key_event.keycode != 0 else key_event.physical_keycode
		return OS.get_keycode_string(keycode)
	return ""
