class_name Characters

class GBot extends StoryObject.StoryCharacter:
	func register():
		displayName = "G-Bot"
		avatar = load("res://resources/avatars/gbot.svg")
class CreatorOrHacker extends StoryObject.StoryCharacter:
	func register():
		displayName = "？？？"
		avatar = load("res://resources/avatars/someone.png")
class System extends StoryObject.StoryCharacter:
	func register():
		displayName = ""
class XGL extends StoryObject.StoryCharacter:
	func register():
		displayName = "你的老母"
