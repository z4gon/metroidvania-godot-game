extends Resource

class_name PlayerStats

export (int) var MAX_HP = 4
var hp = MAX_HP setget set_hp

signal player_died
signal player_hp_changed(current_hp)

func set_hp(value: int):
	hp = clamp(value, 0, MAX_HP)
	emit_signal("player_hp_changed", hp)
	if hp <= 0:
		emit_signal("player_died")
