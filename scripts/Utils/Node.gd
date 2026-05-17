class_name NodeUtil

static func clearChildren(node: Node):
	var children = node.get_children()
	for child in children:
		node.remove_child(child)
	return children
