@tool
extends InteractableBase

@export var id: String = ""

func interact(_player: PlayerBase):
	await TerminalManager.showPanel()
	PresetSoftware.git(
		"/home/instance-%d" % WorldManager.playerInstance.instanceId,
		"backup data of #%d" % WorldManager.playerInstance.instanceId,
		"master",
		"Hemini-Bot/instance-backup"
	)
	TerminalManager.instance.canClose = true
