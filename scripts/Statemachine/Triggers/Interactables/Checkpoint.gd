@tool
extends InteractableBase

@export var id: String = ""

func interact(_player: PlayerBase):
	await TerminalManager.showPanel()
	TerminalManager.write("")
