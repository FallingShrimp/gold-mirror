extends CharacterBase
class_name PlayerBase

var inputHoldStart: Dictionary[String, float] = {}

func _ready():
	super._ready()
	LayerUtil.config(self , [LayerUtil.Layers.PLAYER], [LayerUtil.Layers.ENEMY, LayerUtil.Layers.WALL])
	WorldManager.playerInstance = self
	stateBar.hide()
	await get_tree().process_frame
	PlayerInterface.instance.playerStateBar.initCharacter(self )
func ai(delta: float):
	for key in inputHoldStart:
		if Input.is_action_pressed(key):
			inputHoldStart[key] += delta * 1000
		else:
			clearHoldon(key)

func isPlayer() -> bool:
	return true
func handleHoldon(inp: String):
	inputHoldStart[inp] = 0
func getHoldon(inp: String) -> float:
	return inputHoldStart.get(inp, 0)
func clearHoldon(inp: String):
	inputHoldStart[inp] = 0
