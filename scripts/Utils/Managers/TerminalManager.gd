extends Control
class_name TerminalManager

static var instance: TerminalManager

@export_multiline var infoTemplate: String

@onready var formatter: TypedFormatter = $%formatter
@onready var terminalEdit: CodeEdit = $%terminal
var showing: bool = false

func _ready():
	instance = self
func _physics_process(_delta):
	if showing:
		if Input.is_action_just_pressed("ui_exit"):
			hidePanel()

static func showPanel():
	WorldManager.sceneTree.paused = true
	instance.formatter.setData("gameProgress", GameBusManager.gameProgress)
	instance.formatter.setData("healthPercent", WorldManager.playerInstance.getHealthPercent())
	instance.formatter.setData("maxHealth", WorldManager.playerInstance.maxHealth)
	instance.formatter.setData("strengthPercent", 1 - WorldManager.playerInstance.getStrengthPercent())
	instance.terminalEdit.text = instance.formatter.getOutput()
	PlayerInterface.instance.animator.play("terminalshow")
	await PlayerInterface.instance.animator.animation_finished
	instance.showing = true
static func hidePanel():
	instance.showing = false
	PlayerInterface.instance.animator.play("terminalhide")
	await PlayerInterface.instance.animator.animation_finished
	WorldManager.sceneTree.paused = false
