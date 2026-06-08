@tool
extends InteractableBase

@export var id: String = ""

func interact(_player: PlayerBase):
	await TerminalManager.showPanel()
	await TerminalManager.simulateCommand("git add /home/instance-%d" % WorldManager.playerInstance.instanceId)
