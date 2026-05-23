extends SkillCard

var laser: LaserBaseBullet

func holdStart(_time: float):
	for bullet in BulletBase.create("LaserBase", player.getAnchorPosition("attack1"), PI / 2 - player.direction * PI / 2, player):
		if bullet is LaserBaseBullet:
			laser = bullet
			laser.destroied.connect(toHoldEnd)
			player.impact(Vector2.from_angle(laser.rotation) * -3500)
func holdEnd(_continued: float):
	laser.publicDestroy()
