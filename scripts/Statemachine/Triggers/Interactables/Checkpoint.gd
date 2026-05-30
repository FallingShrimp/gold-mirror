@tool
extends InteractableBase

func interact(_player: PlayerBase):
	await StoryManager.text(Characters.System, "存档")
