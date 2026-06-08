@tool
extends InteractableBase

@export var id: String = ""

func interact(_player: PlayerBase):
	await TerminalManager.showPanel()
	await PresetSoftware.git(
		"/home/instance-%d" % WorldManager.playerInstance.instanceId,
		"backup data of #%d" % WorldManager.playerInstance.instanceId,
		"master",
		"Hemini-Bot/instance-backup"
	)
	await TimeUtil.millseconds(3000)
	await TerminalManager.hidePanel()
	WorldManager.playerInstance.heal(1145141919810)
	WorldManager.playerInstance.storeStrength(1145141919810)
	WorldManager.playerInstance.storeMagic(Vector2(WorldManager.playerInstance.maxMagicLength, 0))
	GameSaveManager.overrideSave()
