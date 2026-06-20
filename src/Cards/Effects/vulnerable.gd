extends Node
class_name Vulnerable

var real_name = "vulnerable"

var stack: int = 1

func _ready():
	name = real_name

	match get_parent().get_parent().name:
		"Player":
			EventBuss.add_ear("Deal_damage_to_player", add_vulnerability)
			EventBuss.add_ear("Player_turn_started", on_turn_started)
		"Enemy":
			EventBuss.add_ear("Deal_damage_to_enemy", add_vulnerability)
			EventBuss.add_ear("Enemy_turn_started", on_turn_started)
	
func _exit_tree() -> void:
	EventBuss.remove_ear("Deal_damage_to_player", add_vulnerability)
	EventBuss.remove_ear("Player_turn_started", on_turn_started)
	EventBuss.remove_ear("Deal_damage_to_enemy", add_vulnerability)
	EventBuss.remove_ear("Enemy_turn_started", on_turn_started)


func add_vulnerability(data: Dictionary) -> Dictionary:
	print("add_vulnerability")
	data["dmg"] = int(data["dmg"] * 1.5)
	return data

func on_turn_started(data:Dictionary):
	stack = max(0,stack-1)
	if stack == 0:
		queue_free()
	EventBuss.emit("changend_buffs_player", {})
	return data
