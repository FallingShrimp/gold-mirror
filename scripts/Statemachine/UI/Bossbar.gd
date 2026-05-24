extends CharacterStateBar
class_name Bossbar

@onready var animator: AnimationPlayer = $%animator
@onready var nameLabel: Label = $%name

func handleValueChange(character: CharacterBase):
	super.handleValueChange(character)
	nameLabel.text = character.displayName
func die():
	EffectPlayer.play("CutLight", global_position, deg_to_rad(30), true, PlayerInterface.instance)
	animator.play("die")
	await animator.animation_finished
	queue_free()
