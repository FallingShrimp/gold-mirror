extends ForwardBullet
class_name NoteStarBullet

func ai(delta: float):
	super.ai(delta)
	if position.distance_to(launcher.focusingEntity.getAnchorPosition("trace")) < 300:
		focus1()

func focus1():
	TutorialManager.tutorialFocus(
		"dash1",
		(position + launcher.focusingEntity.getAnchorPosition("trace")) / 2,
		"敌人的射弹无法被格挡，按下Shift进行闪避。",
		[
			ActionManager.PlayerAction.DASH
		]
	)
