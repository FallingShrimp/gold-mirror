class_name MouseUtil

static func getPositionByScreen(anchor: Vector2, by: Node):
	var viewport = by.get_viewport()
	return viewport.get_mouse_position() - viewport.get_visible_rect().size * anchor
