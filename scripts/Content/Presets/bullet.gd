class_name PresetBulletAI

static func forward(bullet: BulletBase, delta: float):
	bullet.position += Vector2.from_angle(bullet.rotation) * bullet.speed * delta
static func lockLauncher(bullet: BulletBase, anchor: String):
	bullet.position = bullet.launcher.getAnchorPosition(anchor)
