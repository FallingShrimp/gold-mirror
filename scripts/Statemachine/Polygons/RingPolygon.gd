@tool
extends Polygon2D
class_name RingPolygon

@export var cornerDetails: int = 64
@export var outerRadius: float = 100
@export var innerRadius: float = 50

func _ready():
	polygon = getPolygon()

func createCircle(radius: float, direction: int) -> Array[Vector2]:
	var result: Array[Vector2] = []
	for i in cornerDetails + 1:
		result.append(Vector2.from_angle(direction * deg_to_rad(359.99) * i / cornerDetails) * radius)
	return result
func getPolygon() -> Array[Vector2]:
	var result: Array[Vector2] = []
	result.append_array(createCircle(outerRadius, 1))
	result.append_array(createCircle(innerRadius, -1))
	return result
