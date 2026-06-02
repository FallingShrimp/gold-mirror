extends EnemyBase

func _ready():
	super._ready()
	animator.animation_finished.connect(
		func(_n):
			if fsm.currentState is States.ATTACK:
				fsm.changeState(States.IDLE)
	)
func ai(delta: float):
	super.ai(delta)
	if is_instance_valid(focusingEntity) && focusingEntity is EntityBase:
		var targetDirection = sign(focusingEntity.position.x - position.x)
		match fsm.stateIs():
			States.WALK, States.IDLE, States.JUMP:
				if !is_on_floor():
					fsm.changeState(States.FALLING)
				else:
					if distanceToFocusing() < 150:
						fsm.changeState(States.WALK, [-targetDirection])
					elif distanceToFocusing() > 300 || targetDirection != direction:
						fsm.changeState(States.WALK, [targetDirection])
					else:
						fsm.changeState(States.ATTACK, [attackCounter % 2 + 1])
						attackCounter += 1
func createAttack(id: int) -> void:
	match id:
		1:
			BulletBase.create("BroomSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
func isInterruptedByDamage(amount: float) -> bool:
	return amount > 25
func focus1():
	TutorialManager.tutorialFocus(
		"parry1",
		(getAnchorPosition("trace") + focusingEntity.getAnchorPosition("trace")) / 2,
		"敌人已经摆出了架势，按下K进行格挡，招架敌人的攻击，注意格挡的方向。",
		[
			ActionManager.PlayerAction.MOVE,
			ActionManager.PlayerAction.PARRY
		],
		[ActionManager.PlayerAction.PARRY]
	)
func focus2():
	TutorialManager.tutorialFocus(
		"parry2",
		(getAnchorPosition("trace") + focusingEntity.getAnchorPosition("trace")) / 2,
		"放轻松，我会为你暂停世界，继续按下K格挡。",
		[
			ActionManager.PlayerAction.MOVE,
			ActionManager.PlayerAction.PARRY
		],
		[ActionManager.PlayerAction.PARRY]
	)
func focus3():
	TutorialManager.tutorialFocus(
		"attack1",
		(getAnchorPosition("trace") + focusingEntity.getAnchorPosition("trace")) / 2,
		"敌人被震晕了！疲劳状态下的敌人将会获得易伤+50%，趁现在近身敌人进行反击。",
		[
			ActionManager.PlayerAction.MOVE,
			ActionManager.PlayerAction.DASH,
			ActionManager.PlayerAction.ATTACK,
			ActionManager.PlayerAction.MAGIC
		],
		[
			ActionManager.PlayerAction.ATTACK,
			ActionManager.PlayerAction.MAGIC,
		]
	)
