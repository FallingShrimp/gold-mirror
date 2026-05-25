class_name StoryObject

var displayName: String = ""

func register():
	pass

class StoryCharacter extends StoryObject:
	var type: StoryManager.Character = StoryManager.Character.G_BOT
	var avatar: Texture2D = null
