extends BulletBase
class_name HeavyShotBullet

func spawn():
	CameraManager.shake(1500, 150)
func ai(delta: float):
	PresetBulletAI.forward(self , delta)
