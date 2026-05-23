extends CharacterStateBar
class_name Bossbar

@onready var animator: AnimationPlayer = $%animator

func die():
	print(global_position)
	EffectPlayer.play("CutLight", global_position, deg_to_rad(30), true, PlayerInterface.instance)
	animator.play("die")
	await animator.animation_finished
	queue_free()
