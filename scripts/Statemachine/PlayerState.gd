extends CharacterStateBar
class_name PlayerState

@onready var magicVector: MagicVector = $%magic

func handleValueChange(character: CharacterBase):
	super.handleValueChange(character)
	character.magicChanged.connect(
		func(to: Vector2):
			magicVector.maxLength = character.maxMagicLength
			magicVector.currentVector = to
	)
