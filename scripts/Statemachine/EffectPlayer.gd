extends Node2D
class_name EffectPlayer

@export var oneShot: bool = false
@export var autoplayAnimation: StringName = ""
@export var autoplayFrames: StringName = ""
@export var autoplaySound: StringName = ""

@onready var sounds: SoundStage = $%sounds
@onready var animator: AnimationPlayer = $%animator
@onready var shaderStage: ShaderStage = $%shaderStage
@onready var frameSprite: AnimatedSprite2D = $%frameSprite
@onready var texture: Sprite2D = $%texture
@onready var particles: GPUParticles2D = $%particles

func _ready():
	particles.one_shot = oneShot
func shot():
	if autoplayAnimation:
		animator.play(autoplayAnimation)
	if autoplayFrames:
		frameSprite.play(autoplayFrames)
	if autoplaySound:
		sounds.play(autoplaySound)
	if particles.process_material:
		particles.emitting = true
	
	if oneShot:
		if frameSprite.is_playing():
			if !frameSprite.sprite_frames.get_animation_loop(frameSprite.animation):
				await frameSprite.animation_finished
				frameSprite.hide()
		if animator.is_playing():
			await animator.animation_finished
		if sounds.isPlaying():
			await sounds.soundStopped
		
		queue_free()
