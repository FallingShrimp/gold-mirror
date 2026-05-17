extends RefCounted
class_name States

class IDLE extends IState:
	func join() -> String:
		return "IDLE"

class WALK extends IState:
	func join() -> String:
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
			LayerUtil.mask(character, {LayerUtil.Layers.ENEMY: false})
		elif character is EnemyBase:
			LayerUtil.mask(character, {LayerUtil.Layers.PLAYER: false})
		return "DASH"
	func exit() -> void:
		if character is PlayerBase:
			LayerUtil.mask(character, {LayerUtil.Layers.ENEMY: true})
		elif character is EnemyBase:
			LayerUtil.mask(character, {LayerUtil.Layers.PLAYER: true})
