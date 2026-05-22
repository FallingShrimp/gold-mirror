extends SkillCard

func attack():
	BulletBase.create(WorldManager.instance, "LaserBase", player.getAnchorPosition("attack1"), PI / 2 - player.direction * PI / 2, player)
