extends Button

@onready var combat: CanvasLayer = $"../../../.."

var card_data:CardData

func setup() -> void:
	text = card_data.name
	
func _on_button_down() -> void:
	if combat.energy < card_data.cost:
		return
	EventBuss.emit("card_played", {"card_data": card_data})
	queue_free()
	
func _on_mouse_entered() -> void:
	scale = Vector2(1.1,1.1)
	#card_hovered.emit(card_data)

func _on_mouse_exited() -> void:
	scale = Vector2(1,1)
