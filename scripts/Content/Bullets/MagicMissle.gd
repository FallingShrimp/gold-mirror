extends BulletBase
class_name MagicMissleBullet

var speedV2: Vector2 = Vector2.ZERO

func ai(delta: float):
	if timePassed() < 500:
		speedV2 *= 0.95
	elif is_instance_valid(launcher.focusingEntity):
		speedV2 += (launcher.focusingEntity.getAnchorPosition("trace") - position).normalized() * 1000 * delta
	else:
		speedV2 += speedV2.normalized() * 1000 * delta
	speed = speedV2.length()
	rotation = speedV2.angle()
	PresetBulletAI.forward(self , delta)
func destroy():
	animator.play("destroy")
	await animator.animation_finished
