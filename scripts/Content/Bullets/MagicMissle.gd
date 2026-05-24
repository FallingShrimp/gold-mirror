extends BulletBase
class_name MagicMissleBullet

var speedV2: Vector2 = Vector2.ZERO

func ai(delta: float):
	speedV2 *= 0.95
	if timePassed() >= 500 && is_instance_valid(launcher.focusingEntity):
		speedV2 += (launcher.focusingEntity.getAnchorPosition("trace") - position).normalized() * 2000 * delta
	else:
		speedV2 += speedV2.normalized() * 2000 * delta
	speed = speedV2.length()
	rotation = speedV2.angle()
	PresetBulletAI.forward(self , delta)
