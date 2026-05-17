@tool
extends Node2D
class_name ColorBar

@export var size: Vector2 = Vector2(100, 10)
@export var backbox: StyleBoxFlat = null
@export var middlebox1: StyleBoxFlat = null
@export var middlebox2: StyleBoxFlat = null
@export var frontbox: StyleBoxFlat = null
@export var middleSpeed: float = 0.01
@export var frontSpeed: float = 0.9
@export var maxValue: float = 100
@export var currentValue: float = 50
@export var currentDirection: int = 1

var currentMiddle: float = 0.5
var currentFront: float = 0.5

func _ready():
	pass
func _physics_process(_delta):
	currentFront = lerpf(currentFront, getCurrentPercent(), frontSpeed if currentDirection > 0 else middleSpeed)
	currentMiddle = lerpf(currentMiddle, getCurrentPercent(), middleSpeed if currentDirection > 0 else frontSpeed)
	queue_redraw()
func _draw():
	if backbox && middlebox1 && middlebox2 && frontbox:
		drawBack(backbox, Rect2(size / -2, size))
		drawMiddle(middlebox1 if currentDirection > 0 else middlebox2, Rect2(size / -2, size * Vector2(currentMiddle, 1)))
		drawFront(frontbox, Rect2(size / -2, size * Vector2(currentFront, 1)))

func drawBack(box: StyleBoxFlat, rect: Rect2):
	draw_style_box(box, rect)
func drawMiddle(box: StyleBoxFlat, rect: Rect2):
	draw_style_box(box, rect)
func drawFront(box: StyleBoxFlat, rect: Rect2):
	draw_style_box(box, rect)

func getCurrentPercent():
	return currentValue / maxValue
func setValue(newValue: float):
	if currentFront == newValue: return
	currentDirection = sign(currentValue - newValue)
	currentValue = newValue
