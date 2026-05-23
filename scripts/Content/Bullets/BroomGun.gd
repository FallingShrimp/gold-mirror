extends BulletBase
class_name BroomGunBullet

func ai(delta: float):
	PresetBulletAI.forward(self , delta)
