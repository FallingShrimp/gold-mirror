extends Area2D
class_name PlayerTriggerArea

enum TriggerType {
	SPAWN_ENEMY
}

@export var type: TriggerType = TriggerType.SPAWN_ENEMY
@export var spawnPosition: Node2D = null
@export var spawnEnemy: StringName = ""
@export var spawnDirection: CharacterBase.Direction = CharacterBase.Direction.RIGHT
@export var triggerOnce: bool = false

var trigged: bool = false

func _ready():
	body_entered.connect(
		func(body: Node2D):
			if triggerOnce && trigged: return
			if body is PlayerBase:
				if type == TriggerType.SPAWN_ENEMY:
					CharacterBase.create(spawnEnemy, spawnPosition.global_position, spawnDirection)
					trigged = true
	)
