class_name FetchUtil

static func getEntityFromHurtbox(box: Node) -> EntityBase:
	if box is Area2D && box.is_in_group("hurtboxes"):
		var parent = box.get_parent()
		if is_instance_valid(parent) && parent is EntityBase:
			if parent.dieing:
				return null
			else:
				return parent
	return null

static func canDamage(bullet: BulletBase, entity: EntityBase) -> bool:
	if !is_instance_valid(bullet) || !is_instance_valid(entity): return false
	if !is_instance_valid(bullet.launcher): return false
	if bullet.launcher == entity: return false
	if bullet.launcher.isPlayer() == entity.isPlayer(): return false
	if entity.invincible: return false
	return true
