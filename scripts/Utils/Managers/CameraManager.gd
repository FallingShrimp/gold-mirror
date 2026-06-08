@tool
extends Camera2D
class_name CameraManager

@export var constantOffset: Vector2 = Vector2.ZERO

@onready var animator: AnimationPlayer = $%animator

var shakeIntensity: float = 0
var shaking: bool = false
var extremingNode: Node2D = null
var extreming: bool = false
var extremingOffset: float = 1

static var instance: CameraManager = null
  
func _ready():
	instance = self
func _physics_process(delta):
	if extreming:
		if is_instance_valid(extremingNode):
			position = extremingNode.global_position + constantOffset * extremingOffset
			position += MathUtil.sampleInCircle(shakeIntensity)
		else:
			extremeStop()
	elif is_instance_valid(WorldManager.playerInstance):
		position = WorldManager.playerInstance.position + constantOffset
		position += MathUtil.sampleInCircle(shakeIntensity)
	Engine.time_scale = 0.35 if extreming else 1.0
	instance.zoom = lerp(instance.zoom, Vector2.ONE * (2.25 if extreming else 1.0), delta * 10)
 
static func shake(millseconds: float, intensity: float = 10, steper: Callable = func(currentValue, _initialValue, _restPercent): return currentValue):
	var startTime = WorldManager.getCurrentTime()
	instance.shakeIntensity += intensity
	instance.shaking = true
	while WorldManager.getCurrentTime() - startTime < millseconds && instance.shaking:
		instance.shakeIntensity = steper.call(instance.shakeIntensity, intensity, 1 - (WorldManager.getCurrentTime() - startTime) / millseconds)
		await WorldManager.sceneTree.physics_frame
	shakeStop()
static func shakeStop():
	instance.shaking = false
	instance.shakeIntensity = 0
static func extreme(something: Node2D):
	instance.extreming = true
	instance.extremingNode = something
static func extremeStop():
	instance.extreming = false
	instance.extremingNode = null
static func autoExtreme(something: Node2D, millseconds: float):
	extreme(something)
	await TimeUtil.millseconds(millseconds)
	extremeStop()
static func freezeTime(millseconds: float):
	WorldManager.sceneTree.paused = true
	await TimeUtil.millseconds(millseconds * Engine.time_scale)
	WorldManager.sceneTree.paused = false

static func playAnimation(animation: String):
	instance.animator.play(animation)
