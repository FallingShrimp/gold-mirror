extends PlayerBase

var MAX_ATTACK_PERIOD = 3
@onready var HEAVY_SHOT = MAX_ATTACK_PERIOD + 1
var INPUT_BUFFER_WINDOW = 350
var COYOTE_TIME = 50
var COUNTER_ATTACK_WINDOW = 5000
var MAX_COUNTER_ATTACK_LOOP = 3

var lastGroundedTime = 0
var coyoteJumpAvailable = false
var counterAttackStartTime = - INF
var counterAttackLoopCount = 0

func _ready():
	super._ready()
	animator.animation_finished.connect(
		func(_n):
			if handleCounterAttackAnimationFinished():
				return
			match fsm.stateIs():
				States.ATTACK:
					var toIdle = true
					if fsm.currentState.arguments[0] == MAX_ATTACK_PERIOD && ActionManager.canI(ActionManager.PlayerAction.ATTACK) && enoughStrength(25):
						var holdTime = await holdup("attack", 500)
						if holdTime == 500 && useStrength(25):
							pushInput("attack")
							fsm.changeState(States.ATTACK, [HEAVY_SHOT], false)
							attackCounter = 0
							toIdle = false
							ActionManager.emitDid(ActionManager.PlayerAction.ATTACK)
					if toIdle && countInput("attack", INPUT_BUFFER_WINDOW) > 0 && ActionManager.canI(ActionManager.PlayerAction.ATTACK) && useStrength(3):
						fsm.changeState(States.ATTACK, [attackCounter % MAX_ATTACK_PERIOD + 1], false)
						attackCounter += 1
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
				consumeInput("attack")
	)
	madeEntityConversed.connect(
		func(_entity: CharacterBase):
			counterAttackStartTime = WorldManager.getCurrentTime()
			counterAttackLoopCount = 0
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
					"我的名字是G-Bot，我的职责是清除该计算机中的所有恶意程序。",
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
	collectPlayerInputs()
	pruneInput(INPUT_BUFFER_WINDOW)
	if is_on_floor() && fsm.stateIs() in [States.IDLE, States.WALK]:
		lastGroundedTime = WorldManager.getCurrentTime()
		coyoteJumpAvailable = true
	match fsm.stateIs():
		States.PARRY_START:
			if countInput("attack", INPUT_BUFFER_WINDOW) > 0 && ActionManager.canI(ActionManager.PlayerAction.ATTACK) && useStrength(15):
				consumeInput("attack", INPUT_BUFFER_WINDOW)
				fsm.changeState(States.KICK, [], false)
				ActionManager.emitDid(ActionManager.PlayerAction.ATTACK)
			elif !Input.is_action_pressed("parry"):
				fsm.changeState(States.PARRY_END)
		States.IDLE, States.WALK, States.JUMP:
			if fsm.stateIs() in [States.IDLE, States.WALK, States.JUMP] && !is_on_floor():
				if fsm.stateIs() != States.JUMP || velocity.y < 0:
					fsm.changeState(States.FALLING)
			elif fsm.stateIs() not in [States.JUMP]:
				if !tryBufferedAction():
					if Input.is_action_pressed("moving") && ActionManager.canI(ActionManager.PlayerAction.MOVE):
						fsm.changeState(States.WALK, [Input.get_axis("move_left", "move_right")])
						ActionManager.emitDid(ActionManager.PlayerAction.MOVE)
					elif fsm.stateIs() in [States.WALK]:
						fsm.changeState(States.IDLE)
		States.FALLING:
			tryBufferedCoyoteJump()
		States.ATTACK:
			if tryStartCounterAttack():
				return true
			if fsm.currentState.arguments[0] == HEAVY_SHOT:
				if countInput("parry", INPUT_BUFFER_WINDOW) > 0 && ActionManager.canI(ActionManager.PlayerAction.PARRY):
					consumeInput("parry", INPUT_BUFFER_WINDOW)
					await animator.animation_finished
					fsm.changeState(States.PARRY_START, [3, true])
					ActionManager.emitDid(ActionManager.PlayerAction.PARRY)
			else:
				pass
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
func collectPlayerInputs() -> void:
	if Input.is_action_just_pressed("attack"):
		pushUniqueInput("attack", INPUT_BUFFER_WINDOW)
	if Input.is_action_just_pressed("parry"):
		pushUniqueInput("parry", INPUT_BUFFER_WINDOW)
	if Input.is_action_just_pressed("dash"):
		pushUniqueInput("dash", INPUT_BUFFER_WINDOW)
	if Input.is_action_just_pressed("jump"):
		pushUniqueInput("jump", INPUT_BUFFER_WINDOW)
	for i in 3:
		var skillInputId = "skill%d" % (i + 1)
		if Input.is_action_just_pressed(skillInputId):
			pushUniqueInput(skillInputId, INPUT_BUFFER_WINDOW)
func tryBufferedAction() -> bool:
	if countInput("parry", INPUT_BUFFER_WINDOW) > 0 && ActionManager.canI(ActionManager.PlayerAction.PARRY):
		if fsm.changeState(States.PARRY_START, [1, false]):
			consumeInput("parry", INPUT_BUFFER_WINDOW)
			ActionManager.emitDid(ActionManager.PlayerAction.PARRY)
			return true
	if countInput("attack", INPUT_BUFFER_WINDOW) > 0 && ActionManager.canI(ActionManager.PlayerAction.ATTACK) && useStrength(3):
		if fsm.changeState(States.ATTACK, [attackCounter % MAX_ATTACK_PERIOD + 1]):
			attackCounter += 1
			ActionManager.emitDid(ActionManager.PlayerAction.ATTACK)
			return true
		consumeInput("attack", INPUT_BUFFER_WINDOW)
	if countInput("dash", INPUT_BUFFER_WINDOW) > 0 && ActionManager.canI(ActionManager.PlayerAction.DASH) && useStrength(10):
		if fsm.changeState(States.DASH, [direction]):
			consumeInput("dash", INPUT_BUFFER_WINDOW)
			ActionManager.emitDid(ActionManager.PlayerAction.DASH)
			return true
	if countInput("jump", INPUT_BUFFER_WINDOW) > 0 && ActionManager.canI(ActionManager.PlayerAction.JUMP):
		if fsm.changeState(States.JUMP, [1]):
			consumeInput("jump", INPUT_BUFFER_WINDOW)
			coyoteJumpAvailable = false
			ActionManager.emitDid(ActionManager.PlayerAction.JUMP)
			return true
	for i in 3:
		var skillInputId = "skill%d" % (i + 1)
		if countInput(skillInputId, INPUT_BUFFER_WINDOW) > 0:
			consumeInput(skillInputId, INPUT_BUFFER_WINDOW)
			if len(skills) > i:
				var card: SkillCard = skills[i]
				if card.cooldownTimer.start() && ActionManager.canI(ActionManager.PlayerAction.MAGIC):
					if fsm.changeState(States.MAGIC, [card, i]):
						ActionManager.emitDid(ActionManager.PlayerAction.MAGIC)
						return true
				else:
					print("Not cooldowned skill %d" % (i + 1))
			else:
				print("Not installed skill %d" % (i + 1))
	return false
func tryStartCounterAttack() -> bool:
	if (
		countInput("attack", INPUT_BUFFER_WINDOW) > 0
		&& WorldManager.getCurrentTime() - counterAttackStartTime <= COUNTER_ATTACK_WINDOW
		&& ActionManager.canI(ActionManager.PlayerAction.ATTACK)
	):
		consumeInput("attack", INPUT_BUFFER_WINDOW)
		counterAttackStartTime = - INF
		counterAttackLoopCount = 0
		attackCounter = 0
		if fsm.changeState(States.COUNTER_ATTACK_START):
			ActionManager.emitDid(ActionManager.PlayerAction.ATTACK)
			return true
	return false
func handleCounterAttackAnimationFinished() -> bool:
	match fsm.stateIs():
		States.COUNTER_ATTACK_START:
			if countInput("attack", INPUT_BUFFER_WINDOW) > 0:
				consumeInput("attack", INPUT_BUFFER_WINDOW)
				counterAttackLoopCount += 1
				fsm.changeState(States.COUNTER_ATTACK_LOOP, [counterAttackLoopCount], false)
			else:
				fsm.changeState(States.COUNTER_ATTACK_END)
			return true
		States.COUNTER_ATTACK_LOOP:
			if counterAttackLoopCount < MAX_COUNTER_ATTACK_LOOP && countInput("attack", INPUT_BUFFER_WINDOW) > 0:
				consumeInput("attack", INPUT_BUFFER_WINDOW)
				counterAttackLoopCount += 1
				fsm.changeState(States.COUNTER_ATTACK_LOOP, [counterAttackLoopCount], false)
			else:
				fsm.changeState(States.COUNTER_ATTACK_END)
			return true
		States.COUNTER_ATTACK_END:
			counterAttackLoopCount = 0
			fsm.changeState(States.IDLE)
			return true
	return false
func tryBufferedCoyoteJump() -> bool:
	if (
		coyoteJumpAvailable
		&& countInput("jump", INPUT_BUFFER_WINDOW) > 0
		&& WorldManager.getCurrentTime() - lastGroundedTime <= COYOTE_TIME
		&& ActionManager.canI(ActionManager.PlayerAction.JUMP)
	):
		if fsm.changeState(States.JUMP, [1]):
			consumeInput("jump", INPUT_BUFFER_WINDOW)
			coyoteJumpAvailable = false
			ActionManager.emitDid(ActionManager.PlayerAction.JUMP)
			return true
	return false
func createAttack(id: int) -> void:
	match id:
		1:
			for b in BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self ):
				if b is BulletBase:
					b.baseDamage = 8
			EffectPlayer.play("SwordSwing", getAnchorPosition("effect1"), directionAsRotation())
		2:
			for b in BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self ):
				if b is BulletBase:
					b.baseDamage = 11
			EffectPlayer.play("SwordSwing", getAnchorPosition("effect1"), directionAsRotation())
		3:
			for b in BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self ):
				if b is BulletBase:
					b.baseDamage = 12
			EffectPlayer.play("SwordStab", getAnchorPosition("effect2"), directionAsRotation())
		4:
			BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self )
			BulletBase.create("HeavyShot", getAnchorPosition("attack1"), directionAsRotation(), self )
		5:
			for b in BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self ):
				if b is BulletBase:
					b.baseDamage = 7
			EffectPlayer.play("SwordSwing", getAnchorPosition("effect3"), directionAsRotation())
		6:
			for b in BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self ):
				if b is BulletBase:
					b.baseDamage = 25
			EffectPlayer.play("Kick", getAnchorPosition("effect4"), 0, Vector2(direction, 1))
		7:
			for b in BulletBase.create("KnifeSwing", getAnchorPosition("attack1"), directionAsRotation(), self ):
				if b is BulletBase:
					b.baseDamage = 15
			EffectPlayer.play("SwordSwing", getAnchorPosition("effect3"), directionAsRotation())
func parry(_bullet: BulletBase, isPerfect: bool, isSuper: bool):
	if isSuper:
		EffectPlayer.play("SuperParry", getAnchorPosition("parry"), (Vector2.from_angle(getAnchorRotation("parry")) * Vector2(-1, 1)).angle())
	elif isPerfect:
		EffectPlayer.play("PerfectParry", getAnchorPosition("parry"), (Vector2.from_angle(getAnchorRotation("parry")) * Vector2(-1, 1)).angle())
	else:
		EffectPlayer.play("UnexactParry", getAnchorPosition("parry"), (Vector2.from_angle(getAnchorRotation("parry")) * Vector2(-1, 1)).angle())
func quitGame():
	get_tree().quit()
