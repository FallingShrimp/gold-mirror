@tool
extends InteractableBase

@export var id: String = ""

func interact(_player: PlayerBase):
	await TerminalManager.showPanel()
	await TerminalManager.simulateCommand("git add /home/instance-%d" % WorldManager.playerInstance.instanceId)
	await TerminalManager.simulateCommand('git commit -m "update only"')
	await TerminalManager.writeLine("[master %s] update only" % WorldManager.playerInstance.getCommitId())
	await TerminalManager.writeLine("%d files changed, %d insertions(+), %d deletions(-)" % [randi_range(1, 15), randi_range(100, 2000), randi_range(50, 200)])
	# await TerminalManager.simulateCommand("git push"
