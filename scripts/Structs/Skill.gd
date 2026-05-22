extends Control
class_name SkillCard

signal forceHoldEnded()

enum EmitType {
	JUST_CLICK,
	HOLD_RESTART,
	CLICK_HOLD
}

var player: PlayerBase = null

@export var useMagic: Vector2 = Vector2.ZERO
@export var emitType: EmitType = EmitType.JUST_CLICK

func _ready():
	register()
	await get_tree().process_frame
	spawn()

func register():
	pass
func spawn():
	pass
func holdStart(_time: float):
	pass
func attack():
	pass
func holdEnd(_continued: float):
	pass

func toHoldEnd():
	forceHoldEnded.emit()

static func loadCard(namx: String) -> PackedScene:
	return load("res://components/Skills/%s.tscn" % namx)
static func createCard(namx: String) -> SkillCard:
	return loadCard(namx).instantiate() as SkillCard
