extends Resource

class_name PlayerStats

export (int) var MAX_MISSILES = 300
export (int) var MAX_HP = 4
var hp = MAX_HP setget set_hp
var missiles = 3 setget set_missiles

signal player_died
signal player_hp_changed(current_hp)
signal player_missiles_changed(current_count)

func set_hp(value: int):
	hp = clamp(value, 0, MAX_HP)
	emit_signal("player_hp_changed", hp)
	if hp <= 0:
		emit_signal("player_died")

func set_missiles(value: int):
	missiles = clamp(value, 0, MAX_MISSILES)
	emit_signal("player_missiles_changed", missiles)
