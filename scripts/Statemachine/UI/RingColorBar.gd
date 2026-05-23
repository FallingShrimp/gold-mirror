@tool
extends ColorBar
class_name RingColorBar

@export var cornerDetails: int = 8
@export var innerR: float = 50
@export var outerR: float = 100
@export var usePointer: bool = false
@export var pointerWidth: float = 3
@export var pointerColor: Color = Color.RED

func drawBack(box: StyleBoxFlat, _rect: Rect2):
	draw_colored_polygon(getPolygon(size.x, size.x / -2), box.bg_color)
func drawMiddle(box: StyleBoxFlat, _rect: Rect2):
	draw_colored_polygon(getPolygon(size.x * currentMiddle, size.x / -2), box.bg_color)
func drawFront(box: StyleBoxFlat, _rect: Rect2):
	draw_colored_polygon(getPolygon(size.x * currentFront, size.x / -2), box.bg_color)
	if usePointer:
		draw_colored_polygon(pointerPolygon(size.x * getCurrentPercent(), size.x / -2), pointerColor)

func getPolygon(angle: float, start: float) -> PackedVector2Array:
	angle = deg_to_rad(angle)
	start = deg_to_rad(start)
	var result: PackedVector2Array = []
	for i in range(cornerDetails + 1):
		var t = angle * (i * 1.0 / cornerDetails) + start
		result.append(Vector2.from_angle(t) * outerR)
	for i in range(cornerDetails, -1, -1):
		var t = angle * (i * 1.0 / cornerDetails) + start
		result.append(Vector2.from_angle(t) * innerR)
	return result
func pointerPolygon(angle: float, start: float):
	angle = deg_to_rad(angle)
	start = deg_to_rad(start)
	var base = Vector2.from_angle(start + angle)
	return [
		base * (outerR + innerR) / 2,
		base.rotated(PI / 2) * pointerWidth / 2,
		base.rotated(PI / -2) * pointerWidth / 2
	]
