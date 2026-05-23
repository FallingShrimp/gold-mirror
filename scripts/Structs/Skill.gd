@tool
extends Control
class_name SkillCard

signal forceHoldEnded()

enum EmitType {
	JUST_CLICK,
	HOLD_RESTART,
	CLICK_HOLD
}

@export var displayName: String = "SkillName"
@export var icon: Texture2D = null
@export var useMagic: Vector2 = Vector2.ZERO
@export var emitType: EmitType = EmitType.JUST_CLICK
@export var cooldown: float = 1000

@onready var iconTexture: TextureRect = $%icon
@onready var animator: FlaggedAnimator = $%animator
var player: PlayerBase = null
var cooldownTimer: CooldownController = null

func _ready():
	register()
	cooldownTimer = CooldownController.new(cooldown)
	cooldownTimer.cold.connect(func(): animator.play("show"))
	cooldownTimer.hot.connect(func(): animator.play("hide"))
	iconTexture.texture = icon
	await get_tree().process_frame
	spawn()
func _physics_process(_delta):
	cooldownTimer.eventLoop()

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
