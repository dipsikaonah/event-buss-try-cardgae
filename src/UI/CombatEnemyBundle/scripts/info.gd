extends HBoxContainer


@onready var intent: Label = $State/Intent
@onready var enemy: Panel = $"../.."
@onready var buffs_label: Label = $Stats/Buffs
@onready var buffs: Node = $"../../Buffs"

func _ready() -> void:
	await get_tree().get_frame()
	EventBuss.add_ear("changend_buffs_player", show_buffs)
	EventBuss.add_ear("intent_created", _on_intent_created)

func _on_intent_created(data:Dictionary):
	intent.text = ""
	for effect in data["card_data"].effects:
		match effect.type:
			Enums.Type.DAMAGE:
				intent.text += str(effect.value) + " DMG"
			Enums.Type.SHEILD: 
				intent.text += str(effect.value) + " SHE"
			Enums.Type.BUFF:
				intent.text += str(effect.value) + " " + effect.buff_script.resource_path.get_file().trim_suffix(".gd")
		intent.text += "\n"


var Buffs: Dictionary[String, int] = {}

func show_buffs(data: Dictionary) -> void:
	buffs_label.text = ""
	Buffs.clear()
	for buff in buffs.get_children():
		var name = buff.real_name
		if buff.stack > 0:  # Skip if stack is 0
			Buffs[name] = Buffs.get(name, 0) + int(buff.stack)
	for buff_name in Buffs:
		buffs_label.text += str(Buffs[buff_name]) + " "
		match buff_name:
			"strength":
				buffs_label.text += "🦾"
			"vulnerable":
				buffs_label.text += "💔"
