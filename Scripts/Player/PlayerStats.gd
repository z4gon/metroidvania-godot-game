extends Resource

class_name PlayerStats

export (int) var MAX_HP = 4
var hp = MAX_HP setget set_hp

signal player_died

func set_hp(value: int):
	hp = clamp(value, 0, MAX_HP)
	if hp <= 0:
		emit_signal("player_died")
