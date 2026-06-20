extends Node

@warning_ignore("unused_signal")
signal _on_player_hp_changed
@warning_ignore("unused_signal")
signal _on_enemy_hp_changed

@warning_ignore("unused_signal")
signal _on_player_death

var _listeners: Dictionary = {}

func add_ear(name: String, fn: Callable) -> void:
	if name not in _listeners:
		_listeners[name] = []
	_listeners[name].append(fn)  # APPEND, not assign

func remove_ear(name: String, fn: Callable) -> void:
	if name in _listeners:
		_listeners[name].erase(fn)

func emit(name: String, data: Dictionary) -> Dictionary:
	for listener in _listeners.get(name, []):
		var result = listener.call(data)
		if result != null:
			data = result
	return data

func clear():
	_listeners.clear()
