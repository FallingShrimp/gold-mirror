extends Control
class_name TerminalManager

static var instance: TerminalManager

@export_multiline var infoTemplate: String

@onready var formatter: TypedFormatter = $%formatter
@onready var terminalEdit: TextEdit = $%terminal
@onready var titleNumber: Label = $%titleNumber
var showing: bool = false
var decrypted: bool = false
var canClose: bool = false

func _ready():
	instance = self
func _physics_process(_delta):
	if showing:
		if canClose && Input.is_action_just_pressed("ui_exit"):
			hidePanel()

static func showPanel():
	instance.canClose = false
	WorldManager.sceneTree.paused = true
	instance.formatter.setData("gameProgress", GameBusManager.gameProgress)
	instance.formatter.setData("healthPercent", WorldManager.playerInstance.getHealthPercent())
	instance.formatter.setData("maxHealth", WorldManager.playerInstance.maxHealth)
	instance.formatter.setData("strengthPercent", 1 - WorldManager.playerInstance.getStrengthPercent())
	instance.titleNumber.text = "%d" % WorldManager.playerInstance.instanceId
	clear()
	PlayerInterface.instance.animator.play("terminalshow")
	await PlayerInterface.instance.animator.animation_finished
	instance.showing = true
	await TimeUtil.millseconds(500)
	await writeLine("No user logon.")
	await TimeUtil.millseconds(500)
	await PresetSoftware.openssl("TIMENODE_BACKUP.enc", "G_BOT.pem", "TIMENODE_BACKUP.tar.gz")
	instance.decrypted = true
	await writeLine("[- SYSTEM DECRYPTED -]", 50, 2)
	await write(instance.formatter.getOutput())
	await TimeUtil.millseconds(1000)
static func hidePanel():
	instance.decrypted = false
	await write("\n\n[- SYSTEM ENCRYPTED -]", 50)
	await TimeUtil.millseconds(1000)
	instance.showing = false
	PlayerInterface.instance.animator.play("terminalhide")
	await PlayerInterface.instance.animator.animation_finished
	WorldManager.sceneTree.paused = false
static func write(content: String, duration: float = 0):
	for character in content:
		instance.terminalEdit.text += character
		NodeUtil.caretMoveToEnd(instance.terminalEdit)
		if duration > 0:
			await TimeUtil.millseconds(duration)
static func writeLine(content: String, duration: float = 0, lineCount: int = 1):
	await write(content + "\n".repeat(lineCount), duration)
static func clear():
	instance.terminalEdit.text = ""
static func simulateCommand(cmd: String):
	if instance.decrypted:
		await write("\nroot@instance-%d:~# " % WorldManager.playerInstance.instanceId)
	else:
		await write("\n/dev/null:~> ")
	await writeLine(cmd, 10, sign(len(cmd)))
static func progress(count: int, background: String = ".", foreground: String = "#", duration: float = 200):
	const FLOWER = "-\\|/"
	await writeLine("")
	for i in count:
		var process = (i + 1.0) / count
		resetLine()
		await write("%s [%s] %.1f" % [
			FLOWER[i % len(FLOWER)],
			foreground.repeat(floor(process * count)) + background.repeat(count - floor(process * count)),
			process * 100
		] + "%")
		await TimeUtil.millseconds(duration)
	resetLine()
	await write("* [%s] 100" % foreground.repeat(count) + "%")
static func resetLine():
	instance.terminalEdit.set_line(instance.terminalEdit.get_caret_line(), "")
