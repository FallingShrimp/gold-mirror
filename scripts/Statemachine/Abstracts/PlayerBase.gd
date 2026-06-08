extends CharacterBase
class_name PlayerBase

var inputHoldStart: Dictionary[String, float] = {}
var skills: Array[SkillCard] = []
var instanceId: int
var inputStack: Array[InputStack] = []

func _ready():
	super._ready()
	displayName = "Instance #%d" % reinstance()
	add_to_group("player")
	LayerUtil.config(self , [LayerUtil.Layers.PLAYER], [LayerUtil.Layers.WALL])
	WorldManager.playerInstance = self
	stateBar.hide()
	died.connect(func(): CameraManager.extreme(self ))
	await get_tree().process_frame
	PlayerInterface.instance.playerStateBar.initCharacter(self )
func ai(delta: float):
	for key in inputHoldStart:
		if Input.is_action_pressed(key):
			inputHoldStart[key] += delta * 1000
		else:
			clearHoldon(key)
	if !is_instance_valid(focusingEntity):
		focusingEntity = ContentUtil.findClosetEntity(position, func(e: EntityBase): return !e.isPlayer())

func reinstance():
	instanceId = randi_range(1234, 9876)
	return instanceId
func canCollect(item: ItemBase) -> bool:
	return inventory[item.item] < inventoryMax.get(item.item, INF)
func getCommitId() -> String:
	return "%x" % hash("%d" % instanceId)
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
func pushInput(action: String) -> void:
	inputStack.append(InputStack.new(action, WorldManager.getCurrentTime()))
func pushUniqueInput(action: String, window: float = INF) -> void:
	if countInput(action, window) == 0:
		pushInput(action)
func consumeInput(action: String, window: float = INF) -> bool:
	var now = WorldManager.getCurrentTime()
	for i in range(inputStack.size() - 1, -1, -1):
		var entry = inputStack[i]
		if entry.action == action && now - entry.time <= window:
			inputStack.remove_at(i)
			return true
	return false
func countInput(action: String, window: float = INF) -> int:
	var now = WorldManager.getCurrentTime()
	var count = 0
	for entry in inputStack:
		if entry.action == action && now - entry.time <= window:
			count += 1
	return count
func pruneInput(window: float) -> void:
	var now = WorldManager.getCurrentTime()
	inputStack = inputStack.filter(func(entry: InputStack): return now - entry.time <= window)
func clearInputStack() -> void:
	inputStack.clear()
