extends Node

class_name EnemyStatsManager

export (int) var MAX_HP = 1
onready var hp = MAX_HP setget set_hp

signal enemy_died

func set_hp(value):
	hp = clamp(value, 0, MAX_HP)
	if hp <= 0:
		emit_signal("enemy_died")
