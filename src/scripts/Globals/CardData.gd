extends Resource
class_name CardData

@export var name: String
@export var cost: int
@export var description: String
@export var icon: Texture2D

@export var effects: Array[CardEffect] = []
