extends BulletBase
class_name LockLauncherBullet

@export var anchor: String = ""

func ai(_delta: float):
	PresetBulletAI.lockLauncher(self , anchor)
