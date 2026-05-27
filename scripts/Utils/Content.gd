class_name ContentUtil

static func getEntityFromHurtbox(box: Node) -> EntityBase:
	if box is Area2D && box.is_in_group("hurtboxes"):
		var parent = box.get_parent()
		if is_instance_valid(parent) && parent is EntityBase:
			if parent.dieing:
				return null
			else:
				return parent
	return null
static func findClosetEntity(to: Vector2, validator: Callable = func(_e: EntityBase): return true) -> EntityBase:
	var result = null
	var lastDistance = INF
	for entity in WorldManager.sceneTree.get_nodes_in_group("entity"):
		if entity is EntityBase:
			var currentDistance = entity.position.distance_to(to)
			if currentDistance < lastDistance && validator.call(entity):
				result = entity
				lastDistance = currentDistance
	return result

static func canDamageEntity(bullet: BulletBase, entity: EntityBase) -> bool:
	if !is_instance_valid(bullet) || !is_instance_valid(entity): return false
	if !is_instance_valid(bullet.launcher): return false
	if bullet.launcher == entity: return false
	if bullet.launcher.isPlayer() == entity.isPlayer(): return false
	if entity.invincible: return false
	return true
