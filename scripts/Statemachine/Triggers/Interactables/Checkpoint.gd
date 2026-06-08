@tool
extends InteractableBase

@export var id: String = ""

func interact(_player: PlayerBase):
	await TerminalManager.showPanel()
	PresetSoftware.git(
		"/home/instance-%d" % WorldManager.playerInstance.instanceId,
		"backup data of #%d" % WorldManager.playerInstance.instanceId,
		"master",
		"https://gayhub.com/G-Bot/instance-backup.git/"
	)
	TerminalManager.instance.canClose = true
