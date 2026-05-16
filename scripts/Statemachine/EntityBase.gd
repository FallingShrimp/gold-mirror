extends CharacterBody2D
class_name EntityBase

@onready var animator: AnimationPlayer = $%animator
@onready var animationTree: AnimationTree = $%tree
@onready var texture: Node2D = $%texture

var animationPlayback: AnimationNodeStateMachinePlayback
var fsm: FiniteStateMachine = FiniteStateMachine.new(self )

func _ready():
	animationTree.active = true
	animationPlayback = animationTree.get("parameters/playback")
func _physics_process(delta):
	fsm.update(delta)

func ai():
	pass
