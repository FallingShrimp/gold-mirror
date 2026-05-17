@tool
extends Node2D
class_name ShaderStage

@export var size: Vector2 = Vector2.ONE * 100
@export var background: Color = Color.WHITE
@export var shader: ShaderMaterial = null

func _ready():
	material = shader
func _physics_process(_delta):
	queue_redraw()
func _draw():
	draw_rect(Rect2(size / -2, size), background)
