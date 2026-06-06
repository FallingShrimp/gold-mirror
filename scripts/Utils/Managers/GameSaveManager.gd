class_name GameSaveManager

const SAVE_PATH = "user://save.json"

static var saveFile: FileAccess

static var unlockedCheckpoints: Array[String] = []

static func init() -> void:
	saveFile = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.READ_WRITE)
	if !saveFile:
		overrideSave()
	loadSave()
static func gatherIn():
	return {
		"cp": unlockedCheckpoints,
		"sid": StoryManager.playedCount
	}
static func overrideSave():
	clear()
	saveFile.store_string(JsonUtil.stringify(gatherIn()))
static func loadSave():
	var data = JsonUtil.parseFromText(saveFile.get_as_text())
	if data:
		var cp = data["cp"] as Array[String]
		for c in cp:
			unlockedCheckpoints.append(c)
		for key in data["sid"]:
			StoryManager.playedCount[key] = data["sid"][key]
		print("存档加载完成")
	else:
		print("存档文件无效")
static func clear():
	if saveFile:
		saveFile.close()
	saveFile = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.WRITE_READ)
