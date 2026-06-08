extends CharacterBase
class_name PlayerBase

var inputHoldStart: Dictionary[String, float] = {}
var skills: Array[SkillCard] = []
var instanceId: int
var inputStack: Array[InputStack] = []

func _ready():
	super._ready()
	instanceId = randi_range(1234, 9876)
	displayName = "Instance #%d" % instanceId
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
func canCollect(item: ItemBase) -> bool:
	return inventory[item.item] < inventoryMax.get(item.item, INF)

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
# ---- 预输入（input buffer）机制 ----
# 将一次动作输入压入预输入栈，记录触发时刻
func pushInput(action: String) -> void:
	inputStack.append(InputStack.new(action, WorldManager.getCurrentTime()))
# 在时间窗 window（毫秒，默认无限）内查找并消费一条匹配的预输入；成功返回 true
func consumeInput(action: String, window: float = INF) -> bool:
	var now = WorldManager.getCurrentTime()
	for i in range(inputStack.size() - 1, -1, -1):
		var entry = inputStack[i]
		if entry.action == action && now - entry.time <= window:
			inputStack.remove_at(i)
			return true
	return false
# 统计时间窗内某动作的待消费预输入数量
func countInput(action: String, window: float = INF) -> int:
	var now = WorldManager.getCurrentTime()
	var count = 0
	for entry in inputStack:
		if entry.action == action && now - entry.time <= window:
			count += 1
	return count
# 裁剪掉超出时间窗的过期预输入
func pruneInput(window: float) -> void:
	var now = WorldManager.getCurrentTime()
	inputStack = inputStack.filter(func(entry: InputStack): return now - entry.time <= window)
# 清空整个预输入栈
func clearInputStack() -> void:
	inputStack.clear()
