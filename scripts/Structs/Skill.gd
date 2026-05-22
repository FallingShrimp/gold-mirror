extends Control
class_name SkillCard

enum EmitType {
	JUST_CLICK,
	HOLD_RESTART,
	CLICK_HOLD
}

var player: PlayerBase = null

@export var useMagic: Vector2 = Vector2.ZERO
@export var emitType: EmitType = EmitType.JUST_CLICK

func attack():
	pass

static func loadCard(namx: String) -> PackedScene:
	return load("res://components/Skills/%s.tscn" % namx)
static func createCard(namx: String) -> SkillCard:
	return loadCard(namx).instantiate() as SkillCard
