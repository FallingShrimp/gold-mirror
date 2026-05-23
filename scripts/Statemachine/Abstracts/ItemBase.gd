@tool
extends RigidBody2D
class_name ItemBase

@export var displayName: String = ""
@export var icon: Texture2D = null
@export var item: ContentManager.ItemType = ContentManager.ItemType.MAGIC_BALL
@export var count: int = 1

@onready var textureSprite: Sprite2D = $%texture
@onready var animator: AnimationPlayer = $%animator
var focusingCharacter: CharacterBase = null
var collecting: bool = false

func _ready():
	textureSprite.texture = icon
func _physics_process(delta):
	if !GameBusManager.isEditor():
		rotation += 10 * delta
		if is_instance_valid(focusingCharacter):
			apply_central_force((focusingCharacter.getAnchorPosition("trace") - position).normalized() * 300000 * delta)
			if position.distance_to(focusingCharacter.getAnchorPosition("trace")) < 100:
				publicCollect()
		else:
			focusingCharacter = ContentUtil.findClosetEntity(position,
				func(e: EntityBase):
					if e is CharacterBase:
						return e.canCollect(self )
					else:
						return false
			)

func collect():
	pass

func publicCollect():
	if collecting: return
	collecting = true
	focusingCharacter.storeItem({item: count})
	await collect()
	animator.play("hide")
	await animator.animation_finished
	queue_free()
	collecting = false

static func create(itex: ContentManager.ItemType, positiox: Vector2, speed: Vector2):
	var instance = load("res://components/Items/%s.tscn" % ContentManager.itemTypeToName[itex]).instantiate() as ItemBase
	instance.position = positiox
	instance.linear_velocity = speed
	WorldManager.rootNode.add_child.call_deferred(instance)
	return instance
