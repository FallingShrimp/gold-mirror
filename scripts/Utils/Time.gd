class_name TimeUtil

static func millseconds(ms: float) -> Signal:
	return WorldManager.sceneTree.create_timer(ms / 1000.0).timeout
