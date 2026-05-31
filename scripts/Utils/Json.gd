class_name JsonUtil

static func parseFromFile(filePath: String):
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file is FileAccess:
		var json = file.get_as_text()
		file.close()
		return parseFromText(json)
static func parseFromText(text: String):
	var jsonObj = JSON.new()
	jsonObj.parse(text)
	return jsonObj.data
static func stringify(data: Variant):
	return JSON.stringify(data, "    ")
