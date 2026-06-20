extends Node
class_name Strength
var real_name = "strength"
var stack: int = 1

func _ready():
	name = real_name
	EventBuss.add_ear("Get_stat", _on_get_stat)

func _on_get_stat(data: Dictionary) -> Dictionary:
	if data["stat"] == "strength" and data["owner"] == get_parent().get_parent().name:
		data["value"] += stack
	return data

func _exit_tree():
	EventBuss.remove_ear("Get_stat", _on_get_stat)
