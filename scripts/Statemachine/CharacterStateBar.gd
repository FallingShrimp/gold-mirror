@tool
extends Node
class_name CharacterStateBar

@export var character: CharacterBase = null

@onready var healthBar: ColorBar = $%health
@onready var strengthBar: RingColorBar = $%strength

func _ready():
	if character is CharacterBase:
		character.damageTaken.connect(
			func(_a):
				healthBar.maxValue = character.maxHealth
				healthBar.setValue(character.currentHealth)
		)
		character.damageTaken.emit(0)
