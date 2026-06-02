class_name NodeUtil

static func clearChildren(node: Node):
	var children = node.get_children()
	for child in children:
		node.remove_child(child)
	return children
static func skeletonMakeRest(node: Node):
	if node is Bone2D:
		node.apply_rest()
		for child in node.get_children():
			skeletonMakeRest(child)
	elif node is Skeleton2D:
		for child in node.get_children():
			skeletonMakeRest(child)
	return node
static func caretMoveToEnd(editor: TextEdit):
	var line = editor.get_line_count() - 1
	var column = editor.get_line(line).length()
	editor.set_caret_line(line)
	editor.set_caret_column(column)
	editor.adjust_viewport_to_caret()
	editor.grab_focus()
	return editor
