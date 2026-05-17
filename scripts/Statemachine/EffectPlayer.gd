extends Node2D
class_name EffectPlayer

@export var oneShot: bool = false
@export var autoplayAnimation: StringName = ""
@export var autoplayFrames: StringName = ""
@export var autoplaySound: StringName = ""

@onready var sounds: SoundStage = $%sounds
@onready var animator: AnimationPlayer = $%animator
@onready var shaderStage: ShaderStage = $%shader
@onready var frameSprite: AnimatedSprite2D = $%frames
@onready var texture: Sprite2D = $%texture
@onready var particles: GPUParticles2D = $%particles

func _ready():
	particles.one_shot = oneShot
	particles.emitting = false
func shot():
	particles.emitting = true
	if autoplayAnimation:
		animator.play(autoplayAnimation)
	if autoplayFrames:
		frameSprite.play(autoplayFrames)
	if autoplaySound:
		sounds.play(autoplaySound)
	
	if oneShot:
		if frameSprite.is_playing():
			if !frameSprite.sprite_frames.get_animation_loop(frameSprite.animation):
				await frameSprite.animation_finished
				frameSprite.hide()
		if animator.is_playing():
			await animator.animation_finished
		if sounds.isPlaying():
			await sounds.soundStopped
		if particles.emitting:
			await particles.finished
		
		queue_free()

static func play(root: Node, namx: StringName, positiox: Vector2, rotatiox: float, autoShot: bool = true):
	var instance = load("res://components/Effects/%s.tscn" % namx).instantiate() as EffectPlayer
	instance.position = positiox
	instance.rotation = rotatiox
	root.add_child(instance)
	if autoShot:
		instance.shot()
	return instance
