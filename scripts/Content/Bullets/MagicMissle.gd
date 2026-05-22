extends BulletBase
class_name MagicMissleBullet

func ai(delta: float):
	PresetBulletAI.trace(self , 100 * delta)
	PresetBulletAI.forward(self , delta)
	speed += 200 * delta
