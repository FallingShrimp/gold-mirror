class_name LayerUtil

enum Layers {
	PLAYER = 1,
	ENEMY = 2,
	WALL = 3,
    GHOST_ENTITY = 4
}

static func belong(something: CollisionObject2D, layers: Dictionary[Layers, bool]):
	for layer in layers:
		something.set_collision_layer_value(layer, layers[layer])
static func mask(something: CollisionObject2D, layers: Dictionary[Layers, bool]):
	for layer in layers:
		something.set_collision_mask_value(layer, layers[layer])
static func config(something: CollisionObject2D, belongs: Array[Layers], masks: Array[Layers]):
	something.collision_layer = 0
	something.collision_mask = 0
	for layer in belongs:
		belong(something, {layer: true})
	for layer in masks:
		mask(something, {layer: true})
static func ghostize(something: CollisionObject2D):
	config(something, [], [])
