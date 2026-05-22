extends SkillCard

func attack():
	for i in 3:
		for bullet in BulletBase.create("MagicMissle", player.getAnchorPosition("attack1"), player.directionAsRotation(), player):
			if bullet is MagicMissleBullet:
				bullet.speedV2 += Vector2.from_angle(bullet.rotation + (i - 1) * deg_to_rad(30)) * randf_range(1000, 2000)
