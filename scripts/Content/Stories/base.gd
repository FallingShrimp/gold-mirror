class_name StoryObject

var displayName: String = ""

func _init():
	register()

func register():
	pass

class StoryCharacter extends StoryObject:
	var avatar: Texture2D = null
