extends Control
class_name PlayerInterface

static var instance: PlayerInterface = null

@onready var bossbars: Control = $%bossbars
@onready var playerStateBar: CharacterStateBar = $%playerState
@onready var skills: Control = $%skills
@onready var animator: FlaggedAnimator = $%animator
@onready var warningContainer: Control = $%warningContainer
@onready var entityName: Label = $%entityName

func _ready():
	instance = self
	NodeUtil.clearChildren(bossbars)

func rebuildInfo():
	var children = bossbars.get_children()
	for index in len(children):
		var bossbar = children[index]
		if bossbar is CharacterStateBar:
			bossbar.y = index * 100

static func addBossBarFor(character: CharacterBase) -> Bossbar:
	var bossbar = load("res://components/Boxes/Bossbar.tscn").instantiate() as Bossbar
	instance.bossbars.add_child(bossbar)
	bossbar.initCharacter(character)
	return bossbar
static func showBossWarning(displayName: String = "BossName", loopTimes: int = 5):
	WorldManager.sceneTree.paused = true
	instance.warningContainer.show()
	instance.entityName.hide()
	instance.animator.play("bosswarningshow")
	await instance.animator.animation_finished
	instance.animator.play("bosswarningloop")
	for i in loopTimes:
		await instance.animator.animationLooped
	instance.animator.play("bosswarninghide")
	await instance.animator.animation_finished
	instance.warningContainer.hide()
	instance.entityName.text = displayName
	instance.entityName.show()
	instance.animator.play("bosswarningshow")
	await instance.animator.animation_finished
	await TimeUtil.millseconds(loopTimes * 500.0)
	instance.animator.play("bosswarninghide")
	await instance.animator.animation_finished
	WorldManager.sceneTree.paused = false
