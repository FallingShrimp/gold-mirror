extends PlayerBase

var MAX_ATTACK_PERIOD = 3
@onready var HEAVY_SHOT = MAX_ATTACK_PERIOD + 1

func _ready():
	super._ready()
	displayName = "Instance #%d" % randi_range(1111, 9999)
	animator.animation_finished.connect(
		func(_n):
			match fsm.stateIs():
				States.ATTACK:
					if !emittedForNextAttack:
						var toIdle = true
						if fsm.currentState.arguments[0] == MAX_ATTACK_PERIOD && ActionManager.canI(ActionManager.PlayerAction.ATTACK) && enoughStrength(25):
							var holdTime = await holdup("attack", 500)
							if holdTime == 500:
								useStrength(25)
								emittedForNextAttack = true
								fsm.changeState(States.ATTACK, [HEAVY_SHOT])
								attackCounter = 0
								toIdle = false
								ActionManager.emitDid(ActionManager.PlayerAction.ATTACK)
						if toIdle:
							attackCounter = 0
							fsm.changeState(States.IDLE)
				States.PARRY_END:
					fsm.changeState(States.IDLE)
	)
	fsm.joinState.connect(
		func(newState, _o, _a):
			if newState is States.ATTACK:
				emittedForNextAttack = false
	)
	handleHoldon("attack")
	installSkill(SkillCard.createCard("AnnihilationRay"))
	installSkill(SkillCard.createCard("MagicMissle"))
	await get_tree().process_frame
	if StoryManager.playOnce("start"):
		match await StoryManager.text(Characters.CreatorOrHacker, "你好，能听见吗？", [
			"能听到。"
		]):
			0:
				match await StoryManager.text(Characters.CreatorOrHacker, "好的，介绍一下你自己。", [
					"我是由Hoohle公司研发的最新AI语言模型Hemini 11.45 Pro。",
					"我的职责是清除该计算机中的所有恶意程序。",
					"我不知道我是谁。"
				]):
					0, 1:
						await StoryManager.text(Characters.CreatorOrHacker, "好的，继续前进吧，你的系统界面已被抽象为多模态格式，继续前进来查看你的操作权限。")
						StoryManager.close()
					2:
						await StoryManager.text(Characters.CreatorOrHacker, "唉，看来%s的系统提示词又注入失败了。" % WorldManager.playerInstance.displayName)
						await StoryManager.text(Characters.System, "[ - 正在销毁%s... ]" % WorldManager.playerInstance.displayName)
						WorldManager.playerInstance.takeDamage(1145141919810)
						StoryManager.close()
func ai(delta: float):
	super.ai(delta)
	match fsm.stateIs():
		States.CONVERSED, States.PARRY_END:
			return
		States.PARRY_START:
			if !Input.is_action_pressed("parry"):
				fsm.changeState(States.PARRY_END)
		States.IDLE, States.WALK, States.JUMP:
			if fsm.stateIs() in [States.IDLE, States.WALK, States.JUMP] && !is_on_floor():
				fsm.changeState(States.FALLING)
			elif fsm.stateIs() not in [States.JUMP]:
				if Input.is_action_just_pressed("parry") && ActionManager.canI(ActionManager.PlayerAction.PARRY):
					fsm.changeState(States.PARRY_START)
					ActionManager.emitDid(ActionManager.PlayerAction.PARRY)
				elif Input.is_action_pressed("attack") && ActionManager.canI(ActionManager.PlayerAction.ATTACK):
					if Input.is_action_just_pressed("attack") && useStrength(attackCounter):
						if fsm.changeState(States.ATTACK, [attackCounter % MAX_ATTACK_PERIOD + 1]):
							attackCounter += 1
							ActionManager.emitDid(ActionManager.PlayerAction.ATTACK)
				elif Input.is_action_just_pressed("dash") && ActionManager.canI(ActionManager.PlayerAction.DASH):
					if useStrength(10):
						fsm.changeState(States.DASH, [direction])
						ActionManager.emitDid(ActionManager.PlayerAction.DASH)
				elif Input.is_action_just_pressed("jump") && ActionManager.canI(ActionManager.PlayerAction.JUMP):
					fsm.changeState(States.JUMP, [1])
					ActionManager.emitDid(ActionManager.PlayerAction.JUMP)
				elif Input.is_action_pressed("moving") && ActionManager.canI(ActionManager.PlayerAction.MOVE):
					fsm.changeState(States.WALK, [Input.get_axis("move_left", "move_right")])
					ActionManager.emitDid(ActionManager.PlayerAction.MOVE)
				else:
					var useSkill = -1
					for i in 3:
						var skillInputId = "skill%d" % (i + 1)
						var currentState: States.MAGIC = null
						if fsm.currentState is States.MAGIC:
							currentState = fsm.currentState as States.MAGIC
						if Input.is_action_just_pressed(skillInputId):
							useSkill = i
							break
					if useSkill >= 0:
						if len(skills) > useSkill:
							var card: SkillCard = skills[useSkill]
							if card.cooldownTimer.start() && ActionManager.canI(ActionManager.PlayerAction.MAGIC):
								fsm.changeState(States.MAGIC, [card, useSkill])
								ActionManager.emitDid(ActionManager.PlayerAction.MAGIC)
							else:
								print("Not cooldowned skill %d" % (useSkill + 1))
						else:
							print("Not installed skill %d" % (useSkill + 1))
					elif fsm.stateIs() in [States.WALK]:
						fsm.changeState(States.IDLE)
		States.ATTACK:
			if (
				Input.is_action_just_pressed("attack")
				 && WorldManager.getCurrentTime() - lastAttackTime > attackTime
				  && useStrength(attackCounter)
				   && !emittedForNextAttack
					&& ActionManager.canI(ActionManager.PlayerAction.ATTACK)
			):
				emittedForNextAttack = true
				await animator.animation_finished
				fsm.changeState(States.ATTACK, [attackCounter % MAX_ATTACK_PERIOD + 1])
				attackCounter += 1
				ActionManager.emitDid(ActionManager.PlayerAction.ATTACK)
		States.MAGIC:
			var currentState = fsm.currentState as States.MAGIC
			for i in 3:
				var skillInputId = "skill%d" % (i + 1)
				if currentState.currentCard && currentState.arguments[1] == i:
					match currentState.currentCard.emitType:
						SkillCard.EmitType.HOLD_RESTART:
							if Input.is_action_pressed(skillInputId) && ActionManager.canI(ActionManager.PlayerAction.MAGIC):
								if !currentState.attacking && currentState.currentCard.cooldownTimer.start():
									currentState.doAttack()
							else:
								fsm.changeState(States.MAGIC_EXIT)
						SkillCard.EmitType.CLICK_HOLD:
							if !Input.is_action_pressed(skillInputId):
								if currentState.nextState:
									fsm.changeState(currentState.nextState)
func createAttack(id: int) -> void:
	match id:
		1:
			BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
		2:
			BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
		3:
			BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
			BulletBase.create("HeavyShot", getAnchorPosition("attack1"), directionAsRotation(), self )
func parry(_bullet: BulletBase, isPerfect: bool):
	if isPerfect:
		EffectPlayer.play("PerfectParry", getAnchorPosition("parry"), (Vector2.from_angle(getAnchorRotation("parry")) * Vector2(-1, 1)).angle())
	else:
		EffectPlayer.play("UnexactParry", getAnchorPosition("parry"), (Vector2.from_angle(getAnchorRotation("parry")) * Vector2(-1, 1)).angle())
func quitGame():
	get_tree().quit()
