class_name GameBusManager

static func isRelease():
	return !OS.has_feature("debug")
static func isEditor():
	return Engine.is_editor_hint()
