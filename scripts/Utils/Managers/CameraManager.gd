@tool
extends Camera2D
class_name CameraManager

@export var constantOffset: Vector2 = Vector2.ZERO

@onready var animator: AnimationPlayer = $%animator

var shakeIntensity: float = 0
var shaking: bool = false

static var instance: CameraManager = null
  
func _ready():
	instance = self
func _physics_process(_delta):
	if is_instance_valid(WorldManager.playerInstance):
		position = WorldManager.playerInstance.position + constantOffset
		position += MathUtil.sampleInCircle(shakeIntensity)
 
static func shake(millseconds: float, intensity: float = 10, steper: Callable = func(currentValue, _totalValue, _restPercent): return currentValue):
	var startTime = WorldManager.getCurrentTime()
	instance.shakeIntensity += intensity
	instance.shaking = true
	while WorldManager.getCurrentTime() - startTime < millseconds || !instance.shaking:
		instance.shakeIntensity = steper.call(instance.shakeIntensity, intensity, 1 - (WorldManager.getCurrentTime() - startTime) / millseconds)
		await WorldManager.sceneTree.physics_frame
	shakeStop()
static func shakeStop():
	instance.shaking = false
	instance.shakeIntensity = 0
static func playAnimation(animation: String):
	instance.animator.play(animation)
