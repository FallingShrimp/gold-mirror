@tool
extends CanvasLayer
class_name CentralLayer

@export_range(0, 360, 0.1, "radians_as_degrees") var centralRotation: float = 0
@export var centralScale: Vector2 = Vector2.ONE

func _ready():
	update(centralRotation, centralScale)
func _physics_process(_delta):
	update(centralRotation, centralScale)

func update(rotatiox: float, scalx: Vector2):
	var center = get_viewport().get_visible_rect().size / 2.0
	var centerTransform = Transform2D().translated(-center)
	var deltaTranform = Transform2D()
	deltaTranform = deltaTranform.scaled(scalx)
	deltaTranform = deltaTranform.rotated(rotatiox)
	var back = Transform2D().translated(center)
	transform = back * deltaTranform * centerTransform
