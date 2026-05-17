extends RefCounted
class_name States

class IDLE extends IState:
	func join() -> String:
		return "IDLE"

class WALK extends IState:
	func join() -> String:
		if abs(arguments[0]) > 0:
			character.direction = sign(arguments[0])
		return "WALK"
	func update(delta: float) -> void:
		character.forward(arguments[0], delta)

class ATTACK extends IState:
	func join() -> String:
		character.lastAttackTime = WorldManager.getCurrentTime()
		return "ATTACK%d" % arguments[0]

class JUMP extends IState:
	func join() -> String:
		character.impact(Vector2(0, -arguments[0] * 750))
		character.frictable = false
		return "JUMP"

class FALLING extends IState:
	func join() -> String:
		return "FALLING"
	func update(_delta: float) -> void:
		if character.is_on_floor():
			fsm.changeState(IDLE)
			character.frictable = true
 
class DASH extends IState:
	func join() -> String:
		character.frictionMultipiler *= 0.5
		character.impact(Vector2(arguments[0] * 3000, 0))
		SignalUtil.once(character.animationTree.animation_finished,
			func(_n):
				character.frictionMultipiler /= 0.5
				fsm.changeState(IDLE)
		)
		if character is PlayerBase:
			LayerUtil.belong(character, {
				LayerUtil.Layers.GHOST_ENTITY: true,
				LayerUtil.Layers.PLAYER: false
			})
			LayerUtil.mask(character, {LayerUtil.Layers.ENEMY: false})
		return "DASH"
	func exit() -> void:
		if character is PlayerBase:
			LayerUtil.belong(character, {
				LayerUtil.Layers.GHOST_ENTITY: false,
				LayerUtil.Layers.PLAYER: true
			})
			LayerUtil.mask(character, {LayerUtil.Layers.ENEMY: true})

class PARRY_START extends IState:
	var maxHoldTime: float = 1000
	func join() -> String:
		character.parrying = true
		return "PARRY_START"
	func update(_delta: float) -> void:
		if timePassed() > maxHoldTime:
			fsm.changeState(PARRY_END)

class PARRY_END extends IState:
	func join() -> String:
		character.attackCounter = 0
		character.parrying = false
		return "PARRY_END"

class HURT extends IState:
	func join() -> String:
		character.direction = sign(arguments[0])
		return "HURT"

class CONVERSED extends IState:
	func join() -> String:
		SignalUtil.once(character.animationTree.animation_finished,
			func(_a):
				character.storeStrength(character.maxStrength)
				character.fsm.changeState(IDLE)
		)
		return "CONVERSED"
