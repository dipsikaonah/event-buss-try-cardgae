extends Panel

@onready var player_sprite: TextureRect = $MarginContainer/Info/PlayerSprite

var health: int = 40
var dead = false

func deal_damage(dmg:int):
	health = int(max(0,health - dmg))
	print("dealt: ",dmg, " dmg")
	EventBuss.emit("player_damaged",{"player":self})
	if health == 0:
		dead = true
		EventBuss.emit("player_death",{"player":self})
		player_sprite.modulate = Color(1.0, 0.596, 0.396)
