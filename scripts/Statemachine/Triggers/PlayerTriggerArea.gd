extends Area2D
class_name PlayerTriggerArea

enum TriggerType {
	SPAWN_ENEMY,
	VOID_AREA,
	PLAY_STORY
}

@export var type: TriggerType = TriggerType.SPAWN_ENEMY
@export var allowPlayer: bool = true
@export var allowEnemy: bool = false
@export var spawnPosition: Node2D = null
@export var spawnEnemy: StringName = ""
@export var spawnDirection: CharacterBase.Direction = CharacterBase.Direction.RIGHT
@export var storyPreset: StringName = ""
@export var triggerOnce: bool = false
@export var delay: float = 0

var trigged: bool = false

func _ready():
	body_entered.connect(
		func(body: Node2D):
			if triggerOnce && trigged: return
			if (allowPlayer && body is PlayerBase) || (allowEnemy && body is EnemyBase):
				await TimeUtil.millseconds(delay)
				match type:
					TriggerType.SPAWN_ENEMY:
						CharacterBase.create(spawnEnemy, spawnPosition.global_position, spawnDirection)
						trigged = true
					TriggerType.VOID_AREA:
						body.takeDamage(1145141919810)
						body.velocity.y *= 0
					TriggerType.PLAY_STORY:
						PresetStory.play(storyPreset)
	)
