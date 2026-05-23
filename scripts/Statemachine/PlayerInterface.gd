extends Control
class_name PlayerInterface

static var instance: PlayerInterface = null

@onready var bossbars: Control = $%bossbars
@onready var playerStateBar: CharacterStateBar = $%playerState
@onready var skills: Control = $%skills

func _ready():
	instance = self
	NodeUtil.clearChildren(bossbars)

func rebuildInfo():
	var children = bossbars.get_children()
	for index in len(children):
		var bossbar = children[index]
		if bossbar is CharacterStateBar:
			bossbar.y = index * 100

static func addBossBarFor(character: CharacterBase):
	var bossbar = load("res://components/Boxes/Bossbar.tscn").instantiate() as CharacterStateBar
	instance.bossbars.add_child(bossbar)
	bossbar.initCharacter(character)
	return bossbar
