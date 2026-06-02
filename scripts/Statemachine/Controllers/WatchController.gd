extends RefCounted
class_name WatchController

signal changed(old, new)

var currentValue = null

func _init(initialValue):
	currentValue = initialValue

func setValue(newValue):
	if currentValue != newValue:
		changed.emit(currentValue, newValue)
		currentValue = newValue
