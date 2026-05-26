extends Control
class_name PlayerInterface

static var instance: PlayerInterface = null

@onready var bossbars: Control = $%bossbars
@onready var playerStateBar: CharacterStateBar = $%playerState
@onready var skills: Control = $%skills
@onready var animator: FlaggedAnimator = $%animator
@onready var warningContainer: Control = $%warningContainer
@onready var entityName: Label = $%entityName
@onready var focuser: Control = $%focuser
@onready var mask: Polygon2D = $%mask

func _ready():
	instance = self
	NodeUtil.clearChildren(bossbars)
	mask.hide()

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
static func showBossWarning(displayName: String = "BossName", loopTimes: int = 3):
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
	await TimeUtil.millseconds(3000)
	instance.animator.play("bosswarninghide")
	await instance.animator.animation_finished
	WorldManager.sceneTree.paused = false
static func focusNode(positiox: Vector2, radius: float, cornerDetails: int = 64):
	WorldManager.sceneTree.paused = true
	WorldManager.playerInstance.process_mode = Node.PROCESS_MODE_ALWAYS
	var polygon: Array[Vector2] = []
	var center = positiox
	var halfWidth = instance.focuser.size.x / 2.0
	var halfHeight = instance.focuser.size.y / 2.0
	polygon.append(Vector2(0, 0))
	polygon.append(Vector2(halfWidth * 2, 0))
	polygon.append(Vector2(halfWidth * 2, halfHeight * 2))
	polygon.append(Vector2(0, halfHeight * 2))
	polygon.append(Vector2(0, 0))
	for i in cornerDetails + 1:
		var angle = PI * 2.0 * i / cornerDetails + PI / 2
		var x = center.x + radius * cos(angle)
		var y = center.y - radius * sin(angle)
		polygon.append(Vector2(x, y))
	instance.mask.polygon = polygon
	instance.mask.show()
static func unfocus():
	WorldManager.sceneTree.paused = false
	WorldManager.playerInstance.process_mode = Node.PROCESS_MODE_INHERIT
	instance.mask.hide()
	instance.mask.polygon = []
