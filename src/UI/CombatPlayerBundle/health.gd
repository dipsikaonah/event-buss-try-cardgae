extends Label


@onready var player: Panel = $"../../../.."

func _ready() -> void:
	text = str(player.health)
	EventBuss.add_ear("player_damaged",_update_health)
	
func _update_health(data:Dictionary):
	text = str(player.health)
