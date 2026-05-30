extends Node
class_name TypedFormatter

enum DataType {
	INTEGER,
	FLOAT,
	PERCENT,
	ANGLE,
	FREQUENCY,
	MEMORY
}

@export_multiline var template: String = ""
@export var slot: Dictionary[String, DataType] = {}
@export var data: Dictionary[String, float] = {}

func addSlot(namx: String, type: DataType):
	slot[namx] = type
func setData(namx: String, value: float):
	data[namx] = value
func getData(namx: String):
	return data.get(namx, 0)
func buildData(type: DataType, value: float) -> String:
	match type:
		DataType.INTEGER:
			return "%d" % value
		DataType.FLOAT:
			return "%.1f" % value
		DataType.PERCENT:
			return "%.1f" % (value * 100) + "%"
		DataType.ANGLE:
			return "%.1f°" % value
		DataType.FREQUENCY:
			return "%dHz" % value
		DataType.MEMORY:
			return "%dGB" % value
		_:
			return ""
func getOutput() -> String:
	var result = template
	for key in slot:
		result = result.replace("$%s$" % key, buildData(slot[key], getData(key)))
	return result
