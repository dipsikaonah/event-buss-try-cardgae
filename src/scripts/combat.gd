extends CanvasLayer

const CARD = preload("uid://drbh665g42mix")

@onready var hand: HBoxContainer = $Seene/Hand/Hbox
@onready var player: Panel = $Seene/Player
@onready var enemy: Panel = $Seene/Enemy
@onready var combat_ended: Button = $"Seene/Combat ended"

#lololo
const DAMAGE_NUMBER = preload("uid://dp55yir5oss2r")

var turn:int = 0
var energy:int = 3

var enemies = []

const SLASH = preload("uid://besbyjeek7w80")
const STRENGTH = preload("uid://dffmu6j2aiyqo")
const BERSERK = preload("uid://0ghjju7y47yb")

var deck = [SLASH, STRENGTH, BERSERK]

func _ready() -> void:
	enemies.append(enemy)
	EventBuss.add_ear("card_played", _on_card_played)
	
	EventBuss.add_ear("enemy_death", _on_enemy_death)
	EventBuss.add_ear("player_death", _on_player_death)
	EventBuss.add_ear("Player_turn_ended", start_enemies_turn)
	await get_tree().process_frame 
	start_combat()

func _on_enemy_death(data:Dictionary):
	if data["enemy"] in enemies:
		enemies.erase(data["enemy"])
		if enemies.is_empty():
			end_combat()

func _on_player_death(data:Dictionary):
	end_combat()

func start_combat():
	EventBuss.emit("Combat_Started", {})
	start_player_turn()
	
func start_player_turn():
	turn += 1
	spawn_card(5)
	EventBuss.emit("Player_turn_started", {"turn" = turn})

func start_enemies_turn(data:Dictionary):
	for e in enemies:
		if !e.dead: 
			await e.play_intent()
	start_player_turn()
	
func end_combat():
	combat_ended.visible = true
	
func spawn_card(amount:int) -> void:
	for i in (5 - hand.get_child_count()):
		var card = CARD.instantiate()
		hand.add_child(card)
		card.card_data = deck[randi_range(0,deck.size()-1)]
		card.setup()
		await get_tree().create_timer(0.02).timeout

func _on_card_played(data:Dictionary):
	var card_data = data["card_data"]
	var effects = card_data.effects
	for effect in effects:
		match effect.type:
			Enums.Type.DAMAGE:
				
				var amount = effect.value
				
				if effect.target == Enums.Target.PLAYER:
					deal_damage_to_player(amount)
				if effect.target == Enums.Target.ENEMY:
					deal_damage_to_enemy(amount)
			Enums.Type.SHEILD: 
				apply_sheild()
			Enums.Type.BUFF:

				if effect.target == Enums.Target.PLAYER:
					apply_buff(effect, player)
				if effect.target == Enums.Target.ENEMY:
					apply_buff(effect, enemies[0])


func deal_damage_to_player(value: int, is_attack: bool = true):
	var final_value = value
	if is_attack:
		var stat_data = EventBuss.emit("Get_stat", {"stat": "strength", "owner": "Enemy", "value": 0})
		final_value += stat_data["value"]

	var damage_data = EventBuss.emit("Deal_damage_to_player", {"dmg": final_value})
	player.deal_damage(damage_data["dmg"])
	if !enemies.is_empty():
		dmg_number_anim(player, damage_data)
	
func deal_damage_to_enemy(value: int, enemy_id: int = 0, is_attack: bool = true):
	var final_value = value
	if is_attack:
		var stat_data = EventBuss.emit("Get_stat", {"stat": "strength", "owner": "Player", "value": 0})
		final_value += stat_data["value"]

	var damage_data = EventBuss.emit("Deal_damage_to_enemy", {"dmg": final_value})
	enemies[enemy_id].deal_damage(damage_data["dmg"])
	if !enemies.is_empty():
		dmg_number_anim(enemies[enemy_id], damage_data)
	
func apply_buff(effect: CardEffect, target: Panel) -> void:
	var buff_type = effect.buff_script.resource_path.get_file().trim_suffix(".gd")
	var buff_parent = target.get_node("Buffs")
	var existing = null
	for child in buff_parent.get_children():
		if child.real_name == buff_type:
			existing = child
			break
	
	if existing:
		existing.stack += effect.value    # Stack it
	else:
		var newbuff = effect.buff_script.new()
		newbuff.stack = effect.value  
		buff_parent.add_child(newbuff)
	
	EventBuss.emit("changend_buffs_player", {})


func apply_sheild():
	print('sheild aplied')

func dmg_number_anim(target,damage_data):
	var dmgNUM = DAMAGE_NUMBER.instantiate()
	dmgNUM.text = str(damage_data["dmg"])
	target.add_child(dmgNUM)
	dmgNUM.position.x += 180
	
func _on_combat_ended_button_down() -> void:
	EventBuss.clear()
	get_tree().reload_current_scene()
