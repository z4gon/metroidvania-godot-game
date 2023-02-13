extends Node

class_name EnemyStats

export (int) var MAX_HP = 1
onready var hp = MAX_HP setget set_hp

signal enemy_died

func set_hp(value):
	hp = value
	if hp <= 0:
		emit_signal("enemy_died")
