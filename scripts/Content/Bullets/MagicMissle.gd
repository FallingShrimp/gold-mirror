extends BulletBase
class_name MagicMissleBullet

func ai(delta: float):
	PresetBulletAI.trace(self , 1.0 * delta)
	PresetBulletAI.forward(self , delta)
	speed += 300 * delta
