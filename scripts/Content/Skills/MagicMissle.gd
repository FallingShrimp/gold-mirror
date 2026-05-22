extends SkillCard

func attack():
	for i in 3:
		for bullet in BulletBase.create("MagicMissle", player.getAnchorPosition("attack1"), randf_range(0, 2 * PI), player):
			if bullet is MagicMissleBullet:
				bullet.baseDamage = 10
