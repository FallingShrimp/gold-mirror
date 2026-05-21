extends Control
class_name SkillCard

var player: PlayerBase = null

func attack():
	pass

static func loadCard(namx: String) -> PackedScene:
	return load("res://components/Skills/%s.tscn" % namx)
static func createCard(namx: String) -> SkillCard:
	return loadCard(namx).instantiate() as SkillCard
