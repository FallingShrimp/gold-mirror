class_name GameBusManager

static var gameProgress: float = 0

static func isRelease():
	return !OS.has_feature("debug")
static func isEditor():
	return Engine.is_editor_hint()
