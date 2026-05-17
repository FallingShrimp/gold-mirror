class_name LayerUtil

enum Layers {
	ENTITY = 1,
	WALL = 2,
}

static func join(something: CollisionObject2D, layer: Layers):
	something.set_collision_layer_value(layer, true)
	something.set_collision_mask_value(layer, true)
static func exit(something: CollisionObject2D, layer: Layers):
	something.set_collision_layer_value(layer, false)
	something.set_collision_mask_value(layer, false)
static func config(something: CollisionObject2D, cfg: Dictionary[Layers, bool]):
	something.collision_layer = 0
	something.collision_mask = 0
	for layer in cfg:
		if cfg[layer]:
			join(something, layer)
		else:
			exit(something, layer)
