extends CharacterBody2D
class_name EntityBase

@onready var animator: AnimationPlayer = $%animator
@onready var animationTree: AnimationTree = $%tree
@onready var texture: Node2D = $%texture

var animationPlayback: AnimationNodeStateMachinePlayback

func _ready():
	register()
	animationTree.active = true
	animationPlayback = animationTree.get("parameters/playback")
	animationTree.set("parameters/conditions/always", true)
	spawn()
func _physics_process(delta):
	ai(delta)

func register():
	pass
func spawn():
	pass
func ai(_delta: float):
	pass
