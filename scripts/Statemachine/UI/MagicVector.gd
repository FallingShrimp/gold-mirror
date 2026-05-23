@tool
extends Node2D
class_name MagicVector

@export var maxLength: float = 100
@export var currentVector: Vector2 = Vector2(100, 0)
@export var arrowColor: Color = Color.RED
@export var arrowLength: float = 50
@export var arrowSize: float = 10
@export var lineWidth: float = 3

func _physics_process(_delta):
	queue_redraw()
func _draw():
	var dust: Vector2 = getDustVector()
	draw_line(Vector2.ZERO, dust, arrowColor, lineWidth)
	draw_line(dust, dust + dust.rotated(PI * 3 / 4).normalized() * arrowSize, arrowColor, lineWidth)
	draw_line(dust, dust + dust.rotated(PI * 3 / -4).normalized() * arrowSize, arrowColor, lineWidth)
	draw_circle(dust, lineWidth / 2, arrowColor)

func getDustVector() -> Vector2:
	return currentVector.normalized() * (currentVector.limit_length(maxLength).length() / maxLength) * arrowLength
