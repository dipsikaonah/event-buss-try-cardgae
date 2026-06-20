extends Label

@onready var enemy: Panel = $"../../../.."

func _ready() -> void:
	text = str(enemy.health)
	enemy.damage_dealt_to_enemy.connect(_update_health)
	
func _update_health():
	text = str(enemy.health)
