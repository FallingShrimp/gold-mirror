extends SkillCard

func attack():
	for i in 3:
		for bullet in BulletBase.create("MagicMissle", player.getAnchorPosition("attack1"), PI / 2 - player.direction * PI / 2, player):
			if bullet is MagicMissleBullet:
				bullet.baseDamage = 10
