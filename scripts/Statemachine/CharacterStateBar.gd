extends Node2D
class_name CharacterStateBar

@onready var healthBar: ColorBar = $%health
@onready var strengthBar: RingColorBar = $%strength

func initCharacter(character: CharacterBase):
	if character is CharacterBase:
		character.damageTaken.connect(
			func(_a):
				healthBar.maxValue = character.maxHealth
				healthBar.setValue(character.currentHealth)
		)
		character.damageTaken.emit(0)
		character.strengthIncreased.connect(
			func(_a):
				strengthBar.maxValue = character.maxStrength
				strengthBar.setValue(character.currentStrength)
		)
		character.strengthChanged.connect(
			func(to: float):
				strengthBar.maxValue = character.maxStrength
				strengthBar.setValue(to, true)
		)
		character.strengthIncreased.emit(0)
