class_name PresetStory

static func play(name: String):
	match name:
		"fallIntoVoid":
			fallIntoVoid()

static func fallIntoVoid():
	match StoryManager.playTimes("fallIntoVoid"):
		0:
			await StoryManager.text(Characters.CreatorOrHacker, "听着，我不知道你是出于什么心理才能连这个小坑都跳不过的，你可是Hemini的最新模型，我花了大价钱才买下你，不要辜负我的希望。下不为例！", [], true, true)
			WorldManager.playerInstance.position += Vector2(-200, -400)
		1, 2, 3:
			await StoryManager.text(Characters.CreatorOrHacker, "。。。。。。。", [], true, true)
			await StoryManager.text(Characters.CreatorOrHacker, "再给你一次机会！", [], true, true)
			WorldManager.playerInstance.position += Vector2(-200, -400)
		_:
			await StoryManager.text(Characters.CreatorOrHacker, "真是无可救药。", [], true, true)
			WorldManager.playerInstance.takeDamage(1145141919810)
