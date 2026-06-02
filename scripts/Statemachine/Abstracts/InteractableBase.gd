@tool
extends Area2D
class_name InteractableBase

@export var interactActions: Array[StringName] = ["interact"]
@export var allowPlayer: bool = true
@export var allowEnemy: bool = false
@export var allowInteract: bool = true

@onready var animator: AnimationPlayer = $%animator
@onready var hitbox: CollisionShape2D = $%hitbox
@onready var keysBtn: KeypadButton = $%keysBtn

func _ready():
	body_entered.connect(
		func(body):
			if body is EntityBase:
				if body.isPlayer():
					if allowPlayer:
						join(body)
				else:
					if allowEnemy:
						join(body)
	)
	body_exited.connect(
		func(body):
			if body is EntityBase:
				exit(body)
	)
	LayerUtil.config(self , [], [LayerUtil.Layers.PLAYER, LayerUtil.Layers.ENEMY])
	keysBtn.keys = interactActions.map(ParseUtil.readAction).reduce(
		func(acc: Array[String], item):
			acc.append_array(item)
			return acc,
		[] as Array[String]
	)
func _physics_process(_delta):
	if GameBusManager.isEditor(): return
	if allowPlayer && allowInteract:
		var player = playerInside()
		if player:
			keysBtn.show()
			for action in interactActions:
				if Input.is_action_just_pressed(action):
					interact(player)
					break
		else:
			keysBtn.hide()
	else:
		keysBtn.hide()

func interact(_player: PlayerBase):
	pass
func join(_entity: EntityBase):
	pass
func exit(_entity: EntityBase):
	pass

func playerInside() -> PlayerBase:
	if !allowPlayer: return null
	for body in get_overlapping_bodies():
		if body is PlayerBase:
			return body
	return null
func enemyInsides() -> Array[EnemyBase]:
	if !allowEnemy: return []
	return get_overlapping_bodies().filter(func(x): return x is EnemyBase)
