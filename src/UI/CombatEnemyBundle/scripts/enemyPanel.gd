extends Panel

@onready var enemy_sprite: TextureRect = $MarginContainer/EnemySprite

signal damage_dealt_to_enemy

var health: int = 40
var dead = false

func deal_damage(dmg:int):
	health = int(max(0,health - dmg))
	print("dealt: ",dmg, " dmg")
	damage_dealt_to_enemy.emit()
	if health == 0:
		dead = true
		EventBuss.emit("enemy_death",{"enemy":self})
		enemy_sprite.modulate = Color(1.0, 0.596, 0.396)

const CARD = preload("uid://drbh665g42mix")
const SLASH = preload("uid://besbyjeek7w80")
const STRENGTH = preload("uid://dffmu6j2aiyqo")

var deck = [SLASH,STRENGTH]

@onready var player: Panel = $"../Player"

var card

func _ready() -> void:
	create_intent()
func create_intent():
	card = CARD.instantiate()
	card.card_data = deck[randi_range(0,deck.size()-1)].duplicate(true) 
	for effect in card.card_data.effects:
		if effect.target == Enums.Target.PLAYER:
			effect.target = Enums.Target.ENEMY
		elif effect.target == Enums.Target.ENEMY:
			effect.target = Enums.Target.PLAYER
	EventBuss.emit("intent_created", {"card_data": card.card_data})
	
func play_intent() -> void:
	if card:
		EventBuss.emit("card_played", {"card_data": card.card_data})
		create_intent()
