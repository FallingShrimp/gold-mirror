extends BulletBase
class_name HeavyShotBullet

func ai(delta: float):
	PresetBulletAI.forward(self , delta)
