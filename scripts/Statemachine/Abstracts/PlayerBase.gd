extends CharacterBase
class_name PlayerBase

var inputHoldStart: Dictionary[String, float] = {}
var skills: Array[SkillCard] = []

func _ready():
	super._ready()
	add_to_group("player")
	LayerUtil.config(self , [LayerUtil.Layers.PLAYER], [LayerUtil.Layers.WALL])
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
	if !is_instance_valid(focusingEntity):
		focusingEntity = WorldManager.findClosetEntity(position, func(e: EntityBase): return !e.isPlayer())

func installSkill(card: SkillCard):
	card.player = self
	skills.append(card)
	PlayerInterface.instance.skills.add_child(card)
func uninstallSkill(index: int):
	var card = skills[index]
	if card is SkillCard:
		card.player = null
		skills.remove_at(index)
		PlayerInterface.instance.skills.remove_child(card)
func isPlayer() -> bool:
	return true
func handleHoldon(inp: String):
	inputHoldStart[inp] = 0
func getHoldon(inp: String) -> float:
	return inputHoldStart.get(inp, 0)
func clearHoldon(inp: String):
	inputHoldStart[inp] = 0
func holdup(inp: String, maxTime: float = INF):
	var result = inputHoldStart[inp]
	while inputHoldStart[inp] != 0:
		result = inputHoldStart[inp]
		if result >= maxTime:
			result = maxTime
			break
		await get_tree().process_frame
	return result
