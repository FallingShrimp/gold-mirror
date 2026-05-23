extends RigidBody2D
class_name ItemBase

@export var displayName: String = ""
@export var icon: Texture2D = null

@onready var textureSprite: Sprite2D = $%texture

func _ready():
	textureSprite.texture = icon
