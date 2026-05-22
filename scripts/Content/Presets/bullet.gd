class_name PresetBulletAI

static func forward(bullet: BulletBase, delta: float):
	bullet.position += Vector2.from_angle(bullet.rotation) * bullet.speed * delta
static func lockLauncher(bullet: BulletBase, anchor: String):
	bullet.position = bullet.launcher.getAnchorPosition(anchor)
static func trace(bullet: BulletBase, speed: float):
	if is_instance_valid(bullet.launcher.focusingEntity):
		bullet.rotation = lerp_angle(bullet.rotation, bullet.position.angle_to_point(bullet.launcher.focusingEntity.getAnchorPosition("trace")), speed)
